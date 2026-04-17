@IsTest
private class AccountWrapperTests {

    @TestSetup
    static void loadTestData() {
        Account acct = new Account(Name = 'ACME');
        insert acct;
        List<Opportunity> opps = TestFactory.generateOppsForAccount(
            acct.Id, 
            1000.00, 
            5
        );
        insert opps;
    }

    @IsTest
    static void testPositiveRoundedAveragePrice() {
        Account acct = [SELECT Id FROM Account LIMIT 1];
        AccountWrapper acctWrapper = new AccountWrapper(acct);
        Test.startTest();
            Assert.areEqual(
                1000.00,
                acctWrapper.getRoundedAvgPriceOfOpps(),
                'Expected to get 1000.00'
            );
        Test.stopTest();
    }

    @IsTest
    static void testIsHighPriority() {
        Account acct = [SELECT Id FROM Account LIMIT 1];
        List<Opportunity> opps = TestFactory.generateOppsForAccount(
            acct.Id,
            150000.00,
            5
        );
        insert opps;
        AccountWrapper wrapper = new AccountWrapper(acct);
        Test.startTest();
            Assert.isTrue(
                wrapper.isHighPriority(),
                'Deveria ser alta prioridade'
            );
        Test.stopTest();
    }
}