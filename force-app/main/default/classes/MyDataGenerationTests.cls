@IsTest
public class MyDataGenerationTests {

    @TestSetup
    static void otherAccountData(){
        
     	List<sObject> accounts = Test.loadData(Account.SObjectType, 'otherAccountData');
    }
    
    @IsTest
    static void testLoadOtherAccountsFromStaticResource(){
        List<Account> accts = [SELECT ID FROM Account];
        Assert.areEqual(
        				15,
        				accts.size(),
        				'Deveriam existir 15 contas carregadas do CSV');
    }
}