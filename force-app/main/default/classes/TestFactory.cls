@IsTest
public class TestFactory {

    public static Account getAccount(String accountName, Boolean doInsert) {
        Account acct = new Account(Name = accountName);
        if (doInsert) {
            insert acct;
        }
        return acct;
    }

    public static List<Opportunity> generateOppsForAccount(
        Id accountId,
        Decimal amount,
        Integer numOpps
    ) {
        List<Opportunity> opps = new List<Opportunity>();
        for (Integer i = 0; i < numOpps; i++) {
            opps.add(new Opportunity(
                Name = 'Test Opp ' + i,
                AccountId = accountId,
                Amount = amount,
                StageName = 'Prospecting',
                CloseDate = Date.today().addDays(30)
            ));
        }
        return opps;
    }

    // Método que estava faltando!
    public static User generateUser(String profileName) {
        Profile prof = [
            SELECT Id 
            FROM Profile 
            WHERE Name = :profileName 
            LIMIT 1
        ];

        User u = new User(
            FirstName = 'Test',
            LastName = 'User',
            Email = 'testuser@example.com',
            Username = 'testuser' + DateTime.now().getTime() + '@example.com',
            Alias = 'tuser',
            TimeZoneSidKey = 'America/Sao_Paulo',
            LocaleSidKey = 'pt_BR',
            EmailEncodingKey = 'UTF-8',
            LanguageLocaleKey = 'pt_BR',
            ProfileId = prof.Id
        );
        insert u;
        return u;
    }
}