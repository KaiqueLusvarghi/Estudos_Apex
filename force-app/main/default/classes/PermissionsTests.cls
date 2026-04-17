@IsTest
public class PermissionsTests {

        @IsTest
    static void testPositivePermissionSet() {
        // GIVEN - Cria um usuário e atribui o Permission Set
        User userNew = TestFactory.generateUser('Standard User');
        
        // Busca o Permission Set pelo nome
        PermissionSet permSet = [
            SELECT Id 
            FROM PermissionSet 
            WHERE Name = 'Private_Object_Access'
        ];
        
        // Atribui o Permission Set ao usuário
        insert new PermissionSetAssignment(
            AssigneeId = userNew.Id,
            PermissionSetId = permSet.Id
        );
        
        System.runAs(userNew) {
            // WHEN - Tenta buscar os registros
            Test.startTest();
                Private_Object__c[] privateObj = [
                    SELECT Id, Account__c, Notes__c 
                    FROM Private_Object__c
                ];
            Test.stopTest();
            
            // THEN - Com a permissão, deve ver os registros
            Assert.areEqual(
                1,
                privateObj.size(),
                'Usuário com Permission Set deveria ver os registros'
            );
        }
    }
}