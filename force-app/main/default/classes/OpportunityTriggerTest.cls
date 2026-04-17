@IsTest
public with sharing class OpportunityTriggerTest {
    
    // --- TESTE POSITIVO: Verificar se a tarefa é criada corretamente após atualizar para Closed Won ---
    @IsTest
    static void testTriggerAfterUpdate_CreateTask() {
        // Criando uma oportunidade para teste
        Opportunity opp = new Opportunity(
        Name = 'Test Opportunity',
        StageName = 'Prospecting',
        CloseDate = Date.today().addDays(30),
        Amount = 10000,
        Discount_Percentage__c = 0
            );
        
        insert opp; // Inserindo a oportunidade para disparar o trigger before insert
        
        Test.startTest();
        // Atualizando a oportunidade para disparar o trigger after update
        opp.StageName = 'Closed Won';
        update opp;
        Test.stopTest();
        
        List<Task> tasks = [SELECT Id, Subject, WhatId FROM Task WHERE WhatId = :opp.Id];
        Assert.areEqual(1, tasks.size(), 'Deve criar uma tarefa relacionada à oportunidade');
        Assert.areEqual('Obrigado por fechar a oportunidade', tasks[0].Subject, 'O assunto da tarefa está incorreto');
    }

    // --- TESTE NEGATIVO: Verificar que nenhuma tarefa é criada para estágios diferentes de Closed Won ---
    
    @isTest
    static void testTriggerAfterUpdate_Negative() {
        // 1. Arrange: Criar a Oportunidade em Prospecting
        Opportunity opp = new Opportunity(
        Name = 'Teste Negativo Trigger',
        StageName = 'Prospecting',
        CloseDate = Date.today().addDays(30),
        Amount = 5000,
        Discount_Percentage__c = 0
            );
        insert opp;
        
        // 2. Act: Atualizar para um estágio que NÃO seja Closed Won
        Test.startTest();
        opp.StageName = 'Qualification'; // Mudança válida, mas não deve gerar tarefa
        update opp;
        Test.stopTest();
        
        // 3. Assert: Verificar que NENHUMA tarefa foi criada
        List<Task> tasksCriadas = [SELECT Id FROM Task WHERE WhatId = :opp.Id];
        
        // O tamanho da lista deve ser 0
        Assert.areEqual(0, tasksCriadas.size(), 'Não deveria ter sido criada nenhuma tarefa para estágios diferentes de Closed Won.');
    }
}