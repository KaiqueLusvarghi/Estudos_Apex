@IsTest
public class LeadServiceTest {

    //------- METODO ValorTotalVenda -----------
    //----------- TESTES POSITIVOS -------------------------
    
    
    @Istest
    static void ValorTotalVendaPositivo(){
        Decimal QtdVeiculo = 12;
        Decimal PrecoVeiculo = 1000;
        Decimal ValorTotal = 12000;
        
        Test.startTest();
        Decimal resultado = LeadService.ValorTotalVenda(QtdVeiculo, PrecoVeiculo);
        Test.stopTest();
        
        Assert.areEqual(12000, resultado, 'O cálculo do valor total não retornou 12000 como esperado!');
    }
    
    
    // -------------- TESTES NEGATIVOS ----------------
    
    @IsTest
   	static void ValorTotalVendaNull(){
        Decimal QtdVeiculo = null;
        Decimal PrecoVeiculo = null;
        String mensagemEsperada = 'Não pode ser nulo os valores';
        
        Test.startTest();
        Try{
            LeadService.ValorTotalVenda(QtdVeiculo, PrecoVeiculo);
            System.assert(false, 'Deveria ter lançado uma exceção para Quantidade de veiculos !');
        }catch(IllegalArgumentException e){
            Assert.areEqual(mensagemEsperada, e.getMessage(), 'A menssagem de erro não correponde a mensagem esperada!');
        }
        Test.stopTest();
    }
    
    
    @IsTest
   	static void ValorTotalVendaCarroNegativo(){
        Decimal QtdVeiculo = -3;
        Decimal PrecoVeiculo = 1000;
        String mensagemEsperada = 'por favor informe um valor positivo';
        
        Test.startTest();
        Try{
            LeadService.ValorTotalVenda(QtdVeiculo, PrecoVeiculo);
            System.assert(false, 'Deveria ter lançado uma exceção para Quantidade de veiculos negativos !');
        }catch(IllegalArgumentException e){
            Assert.areEqual(mensagemEsperada, e.getMessage(),'A menssagem de erro não correponde a mensagem esperada!');
        }
        Test.stopTest();
    }

    
    
    @IsTest
    static void ValorTotalVendaNegativo(){
        Decimal QtdVeiculo = 30;
        Decimal PrecoVeiculo = 1000;
        String mensagemEsperada = 'vendas acima de 20 veículos é necessário falar com o Diretor Comercial';
        
        Test.startTest();
        Try{
            LeadService.ValorTotalVenda(QtdVeiculo, PrecoVeiculo);
            System.assert(false, 'Deveria ter lançado uma exceção para Quantidade de veiculos !');
        }catch(IllegalArgumentException e){
            Assert.areEqual(mensagemEsperada, e.getMessage(), 'A menssagem de erro não correponde a mensagem esperada!');
        }
        Test.stopTest();
    }
    
    
    //------------------METODO CreatTask --------
    //---------- TESTES POSITIVOS --------
    
    @IsTest
    static void CreatTaskPositivo(){
        Lead ld = new Lead(LastName = 'TestLead', Company = 'TestCompany', Status = 'Closed - Converted');
        insert ld;
        
        Test.startTest();
        LeadService.CreatTask(new List<Lead>{ld});
        Test.stopTest();
        
        List<Task> tasks = [SELECT Id, Subject, WhatId FROM Task WHERE What.Id =:ld.Id];
        Assert.areEqual(1, tasks.size(), 'Deveria ter criado uma tarefa de CreatTask para a LEAD fechada como "Closed - Converted".');
        Assert.areEqual('Obrigado por fechar a a Lead!', tasks[0].subject, 'O assunto da tarefa não corresponde ao esperado');
        
    }
}