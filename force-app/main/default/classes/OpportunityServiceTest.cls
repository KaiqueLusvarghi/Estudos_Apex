@IsTest
public with sharing class OpportunityServiceTest {

    // ------------- TESTES PARA O MÉTODO calculateDiscount -------------

    // -- TEST POSITIVO --
   @IsTest
    static void testCalculateDiscountSuccess() {
        // Teste para calcular o desconto corretamente
        Decimal valorOriginal = 1000;
        Decimal desconto = 10;
        Decimal resultadoEsperado = 900;

        Test.startTest();
        Decimal resultado = OpportunityService.calculateDiscount(valorOriginal, desconto);
        Test.stopTest();

        Assert.areEqual(900, resultado, 'O cálculo do desconto não retornou o valor esperado, deveria retonar 900.');
    }

    // ---- TESTES NEGATIVOS ----

    @IsTest
    static void testCalculateDiscountErrorNullValues() {
        // Teste para verificar se o método lança uma exceção quando os valores são nulos
        String mensagemEsperada = 'Não pode haver valores nulos para totalAmount ou discountPercent.  ';

        Test.startTest();
        try {
            OpportunityService.calculateDiscount(null, null);
            System.assert(false, 'Deveria ter lançado uma exceção para valores nulos.');
        } catch (IllegalArgumentException e) {
            Assert.areEqual(mensagemEsperada, e.getMessage(), 'A mensagem de erro não corresponde à esperada para valores nulos.');
        }
        Test.stopTest();
    }

    @IsTest
    static void testCalculateDiscountErrorAbove50(){
        Decimal valorOriginal = 1000;
        Decimal descontoInvalido = 60; // Desconto acima de 50%
        String mensagemEsperada = 'Desconto acima de 50% não é permitido.';

        Test.startTest();
        try {
            OpportunityService.calculateDiscount(valorOriginal, descontoInvalido);
            System.assert(false, 'Deveria ter lançado uma exceção para desconto acima de 50%.');
        } catch (IllegalArgumentException e) {
            Assert.areEqual(mensagemEsperada, e.getMessage(), 'A mensagem de erro não corresponde à esperada para desconto acima de 50%.');
        }
        Test.stopTest();
    }

    @IsTest
    static void testCalculateDiscountErrorNegative(){
        Decimal valorOriginal = 1000;
        Decimal descontoInvalido = -10; // Desconto negativo
        String mensagemEsperada = 'Desconto não pode ser negativo.';

        Test.startTest();
        try {
            OpportunityService.calculateDiscount(valorOriginal, descontoInvalido);
            System.assert(false, 'Deveria ter lançado uma exceção para desconto negativo.');
        } catch (IllegalArgumentException e) {
            Assert.areEqual(mensagemEsperada, e.getMessage(), 'A mensagem de erro não corresponde à esperada para desconto negativo.');
        }
        Test.stopTest();
    }


    //-- TESTES PARA O MÉTODO creatFollowUpTask --  
    // TESTES POSITIVOS

    @IsTest
    static void testCreateFollowUpTaskSuccess() {
        // Teste para verificar se as tarefas de follow-up são criadas corretamente para oportunidades 'Closed Won'
        Opportunity opp = new Opportunity(Name = 'Test Opportunity', StageName = 'Closed Won', CloseDate = Date.today());
        insert opp;

        Test.startTest();
        OpportunityService.creatFollowUpTask(new List<Opportunity>{opp});
        Test.stopTest();

        List<Task> tasks = [SELECT Id, Subject, WhatId FROM Task WHERE WhatId = :opp.Id];
        Assert.areEqual(1, tasks.size(), 'Deveria ter criado uma tarefa de follow-up para a oportunidade fechada como "Closed Won".');
        Assert.areEqual('Obrigado por fechar a oportunidade!', tasks[0].Subject, 'O assunto da tarefa de follow-up não corresponde ao esperado.');
    }

    // -- Testes negativos para o método creatFollowUpTask --

    @IsTest
    static void testCreateFollowUpTaskNoClosedWon() {
        // Teste para verificar que nenhuma tarefa é criada para oportunidades que não estão no estágio 'Closed Won'
        Opportunity opp = new Opportunity(Name = 'Test Opportunity', StageName = 'Prospecting', CloseDate = Date.today());
        insert opp;

        Test.startTest();
        OpportunityService.creatFollowUpTask(new List<Opportunity>{opp});
        Test.stopTest();

        List<Task> tasks = [SELECT Id FROM Task WHERE WhatId = :opp.Id];
        Assert.areEqual(0, tasks.size(), 'Não deveria ter criado nenhuma tarefa de follow-up para oportunidades que não estão no estágio "Closed Won".');
    }
}