@IsTest
public class LeadTriggerTest {
  
   // ------------ TESTE POSITIVO ----------------
    @IsTest
    static void testTriggerAfterUpdate_createTask(){
        Lead ld = new Lead(
        LastName = 'Testando',
        Company = 'Testei',
        Quantidade_de_Veiculos__c = 10,
        Preco_do_Veiculo__c = 1000,
        Status = 'Working - Contacted'	
        );
        
        insert ld;
        
        Test.startTest();
        ld.Status = 'Closed - Converted';
        update ld;
        Test.stopTest();
        
        List<Task> tasks = [SELECT Id FROM Task WHERE WhatId = :ld.Id];
		Assert.areEqual(1, tasks.size(), 'Deveria ter sido criada uma tarefa para o lead fechado como "Closed - Converted"');
        Assert.areEqual('Obrigado por fechar a a Lead!', tasks[0].subject, 'O assunto da tarefa está incorreto');
    }
    
    // ------- TESTE NEGATIVO -----------------------
    
    @IsTest
    static void testTriggerHandlerNegatio(){
        Lead ld = new Lead(
        LastName = 'Testando',
        Company = 'Testei',
        Quantidade_de_Veiculos__c = 10,
        Preco_do_Veiculo__c = 1000,
        Status = 'Working - Contacted'	
        );
        
        insert ld;
        
        Test.startTest();
        ld.Status = 'Closed - Not Converted';
        update ld;
        Test.stopTest();
        
        List<Task> tasks = [SELECT Id FROM Task WHERE WhatId = :ld.Id];
		Assert.areEqual(0, tasks.size(), 'Não Deveria ter sido criada uma tarefa para o lead fechado como "Closed - Not Conerted"');
       
        
    }

}