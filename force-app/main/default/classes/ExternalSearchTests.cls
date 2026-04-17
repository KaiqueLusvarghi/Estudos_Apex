@IsTest
private class ExternalSearchTests {

    // Mock único e flexível que aceita parâmetros
    private class HttpMockFactory implements HttpCalloutMock {
        Integer code;
        String body;

        public HttpMockFactory(Integer code, String body) {
            this.code = code;
            this.body = body;
        }

        public HTTPResponse respond(HTTPRequest req) {
            HTTPResponse res = new HTTPResponse();
            res.setStatusCode(this.code);
            res.setBody(this.body);
            return res;
        }
    }

    @IsTest
    static void testPositiveMocking() {
        // Usa a factory passando 200
        Test.setMock(HttpCalloutMock.class, new HttpMockFactory(200, '{"data": "dummy data"}'));
        
        Test.startTest();
            String result = ExternalSearch.googleIt('Salesforce');
        Test.stopTest();
        
        Assert.areEqual('{"data": "dummy data"}', result);
    }

    @IsTest
    static void testNegativeMocking() {
        // O desafio exige que você use 'HttpMockFactory' para retornar 500 aqui
        Test.setMock(HttpCalloutMock.class, new HttpMockFactory(500, 'Internal Server Error'));
        
        Test.startTest();
            try {
                ExternalSearch.googleIt('Salesforce');
                Assert.fail('Deveria ter lançado ExternalSearchException');
            } catch (ExternalSearch.ExternalSearchException e) {
                Assert.isTrue(e.getMessage().contains('500'), 'Mensagem esperada não encontrada');
            }
        Test.stopTest();
    }
}