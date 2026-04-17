@isTest
public with sharing class OpportunityHandlerTest {
    
    // -------- TESTE PARA O MÉTODO BEFORE INSERT --------
    // ----- TESTE POSITIVO: Verificar se o preço final é calculado corretamente com desconto -----
    
    @isTest
    static void testHandlerBeforeInsert_Positive() { // O método é static, então pode ser chamado diretamente sem instanciar a classe
        
        Opportunity opp = new Opportunity( // Criamos uma oportunidade de teste com valores válidos para o campo Amount e Discount_Percentage__c
        Name = 'Test Opportunity',
        Amount = 1000,
        Discount_Percentage__c = 10,
        CloseDate = Date.today(),
        StageName = 'Prospecting' // Campo obrigatório padrão
        );
        
        
        Test.startTest(); // Iniciamos o teste para garantir que as operações de banco de dados sejam isoladas e que os limites de governança sejam aplicados corretamente durante a execução do teste
        insert opp; // Inserimos a oportunidade, o que acionará o método HandlerBeforeInsert para calcular o preço final com desconto
        Test.stopTest(); // Finalizamos o teste para garantir que todas as operações assíncronas sejam concluídas e que os resultados possam ser verificados corretamente
        
        
        Opportunity oppResult = [SELECT Final_Price__c FROM Opportunity WHERE Id = :opp.Id]; // Consultamos a oportunidade recém-inserida para verificar se o campo Final_Price__c foi atualizado corretamente com o preço final após o desconto
        
        Assert.areEqual(900, oppResult.Final_Price__c, 'A Handler deveria ter calculado o preço final como 900 antes de inserir.'); 
        // Verificamos se o valor do campo Final_Price__c é igual a 900, que é o resultado esperado após aplicar um desconto de 10%
        // sobre o valor original de 1000. Se o valor for diferente, a mensagem de erro personalizada será exibida.
    }
    
    
    //----- TESTE NEGATIVO: Verificar se o método lança um erro quando os valores são inválidos -----
    @isTest
    static void testHandlerBeforeInsert_Negative() {
        
        Opportunity opp = new Opportunity( // Criamos uma oportunidade de teste com um desconto acima de 50% para verificar se o método lança um erro corretamente
            Name = 'Test Negative',
        Amount = 1000,
        Discount_Percentage__c = 60,
        StageName = 'Prospecting',
        CloseDate = Date.today()
            );
        
        Test.startTest();
        try { // Tentamos inserir a oportunidade, esperando que o método lance um erro devido ao desconto acima de 50%
            insert opp;
            // Se o insert for bem-sucedido, isso significa que o método não lançou o erro como esperado, então falhamos o teste
            Assert.fail('O sistema deveria ter lançado uma exceção para desconto acima de 50%.');
        } catch (DmlException e) {
            // No Salesforce, quando um insert falha, ele lança uma DmlException
            // Nós verificamos se a mensagem que você escreveu está lá
            String mensagemErro = e.getDmlMessage(0);
            
            // 3. Assert: Verificar se a mensagem é a que você definiu no Service
            Assert.areEqual('Desconto acima de 50% não é permitido.', mensagemErro, 'A mensagem de erro retornada está incorreta.');
        }
        Test.stopTest();
    }
    
    
    
    
    //-------- TESTE PARA O MÉTODO AFTER UPDATE --------
    // ----- TESTE POSITIVO: Verificar se as tarefas de follow-up são criadas corretamente quando a oportunidade é atualizada para 'Closed Won' -----
    @isTest
    static void testHandlerAfterUpdate_Positive() {

        Opportunity opp = new Opportunity( // Criamos uma oportunidade de teste com um estágio inicial diferente de 'Closed Won'
        Name = 'Test After Update',
        Amount = 1000,
        Discount_Percentage__c = 10,
        StageName = 'Prospecting',
        CloseDate = Date.today()
        );
        
        insert opp; // Inserimos a oportunidade para que ela exista no banco de dados e possa ser atualizada posteriormente
        
        opp.StageName = 'Closed Won'; // Atualizamos o estágio da oportunidade para 'Closed Won' para acionar o método HandlerAfterUpdate
        Test.startTest();
        update opp; // Atualizamos a oportunidade, o que acionará o método HandlerAfterUpdate para verificar se as tarefas de follow-up são criadas corretamente
        Test.stopTest();
        
        List<Task> tasks = [SELECT Id FROM Task WHERE WhatId = :opp.Id]; // Consultamos as tarefas associadas à oportunidade para verificar se as tarefas de follow-up foram criadas
        
        Assert.areEqual(1, tasks.size(), 'Deveria ter sido criada uma tarefa de follow-up para a oportunidade fechada como "Closed Won".');
        // Verificamos se exatamente uma tarefa foi criada para a oportunidade. Se não for o caso, a mensagem de erro personalizada será exibida.

     }

     // --- TESTE NEGATIVO: Verificar se as tarefas de follow-up não são criadas quando a oportunidade é atualizada para um estágio diferente de 'Closed Won' ---
        @isTest
        static void testHandlerAfterUpdate_Negative() {

            Opportunity opp = new Opportunity( // Criamos uma oportunidade de teste com um estágio inicial diferente de 'Closed Won'
            Name = 'Test After Update Negative',
            Amount = 1000,
            Discount_Percentage__c = 10,
            StageName = 'Prospecting',
            CloseDate = Date.today()
            );
            
            insert opp; // Inserimos a oportunidade para que ela exista no banco de dados e possa ser atualizada posteriormente
            
            opp.StageName = 'Negotiation/Review'; // Atualizamos o estágio da oportunidade para um estágio diferente de 'Closed Won' para verificar se as tarefas de follow-up não são criadas
            Test.startTest();
            update opp; // Atualizamos a oportunidade, o que acionará o método HandlerAfterUpdate para verificar se as tarefas de follow-up não são criadas
            Test.stopTest();
            
            List<Task> tasks = [SELECT Id FROM Task WHERE WhatId = :opp.Id]; // Consultamos as tarefas associadas à oportunidade para verificar se as tarefas de follow-up foram criadas
            
            Assert.areEqual(0, tasks.size(), 'Não deveria ter sido criada nenhuma tarefa de follow-up para a oportunidade que não foi fechada como "Closed Won".');
            // Verificamos se nenhuma tarefa foi criada para a oportunidade. Se for o caso, a mensagem de erro personalizada será exibida.

         }

    
}