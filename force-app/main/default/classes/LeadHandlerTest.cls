@Istest
public class LeadHandlerTest {
	
//------------- TESTE DO METODO HandlerCalculations -------------------
//-------------TESTES POSITIVOS ---------------------
@IsTest
    static void TestHandlerLead(){
	Lead ld = new Lead(
    	LastName = 'Testando',
        Company = 'Testei',
        Quantidade_de_Veiculos__c = 10,
        Preco_do_Veiculo__c = 1000,
        Status = 'Working - Contacted'
    );
        
        Test.startTest();
        insert ld;
        Test.stopTest();
        
        Lead ResultLD = [SELECT Preco_do_Veiculo__c FROM Lead WHERE Id = :ld.Id];
        Assert.areEqual(10000, ResultLD.Preco_do_Veiculo__c, 'A Handler deveria ter calculado o preco do veiculo que seria 10000');
    }
    
 // ------------ TESTE NEGATIVO --------------
 
    @IsTest
    static void TestHandlerNegativo(){
        Lead ld = new Lead(
    	LastName = 'Testando',
        Company = 'Testei',
        Quantidade_de_Veiculos__c = 40,
        Preco_do_Veiculo__c = 1000,
        Status = 'Working - Contacted'
    );
        Test.startTest();
        try{
            insert ld;
            Assert.fail('O sistema deveria ter lançado uma exceção para quantidades de veiculos acima de 20');
        } catch(DmlException e){
            String menssagemErro = e.getDmlMessage(0);
            Assert.areEqual('vendas acima de 20 veículos é necessário falar com o Diretor Comercial', menssagemErro, 'A mensagem de erro retirnada esta incorreta');
        }
        Test.stopTest();
    }
    
 // -------------------- TEST PARA O METODO HandlerNewTask ----------------------
 //  ------------ TESTE POSITIO ---------------------
 	@IsTest
    static void TestHandlerNewTask(){
        Lead ld = new Lead(
    	LastName = 'Testando',
        Company = 'Testei',
        Quantidade_de_Veiculos__c = 10,
        Preco_do_Veiculo__c = 1000,
        Status = 'Working - Contacted'
    );
        
        insert ld;
        ld.Status = 'Closed - Converted';
        Test.startTest();
        update ld;
        Test.stopTest();
        
         List<Task> tasks = [SELECT Id FROM Task WHERE WhatId = :ld.Id];
        
        Assert.areEqual(1, tasks.size(), 'Deveria ter sido criada uma tarefa para o lead fechado como "Closed - Converted"');
    }
    
 // --- TESTE NEGATIVO: VERIFICAR SE UMA TASK NÃO É CRIADA QUANDO UMA LEAD É ATT PARA UM STATUS DIFERENTE DE CLOSED - CONVERTED

    @IsTest
    static void TestHandlerNewTaskNegative(){
        Lead ld = new Lead(
    	LastName = 'Testando',
        Company = 'Testei',
        Quantidade_de_Veiculos__c = 10,
        Preco_do_Veiculo__c = 1000,
        Status = 'Working - Contacted'
		);
        
        insert ld;
        ld.Status = 'Closed - Not Converted';
        Test.startTest();
        
        update ld;
        Test.stopTest();
        
        List<Task> tasks = [SELECT Id FROM Task WHERE WhatId = :ld.Id];
        Assert.areEqual(0, tasks.size(), 'Não deveria ter sido criada uma taks nova, pois o status é diferente de "Closed - Converted"');
       
    }
}