@isTest
private with sharing class CommunityUserAccountsControllerTest {

    @TestSetup
    static void setup() {
        Id userId = UserInfo.getUserId();
        User admin = [SELECT Id, Username FROM User WHERE Profile.Name = 'System Administrator' AND isActive = true AND Id =: userId LIMIT 1];

        System.runAs(admin) {
            Account testAccount = new Account(Name = 'test');
            insert testAccount;
            Id accountId = testAccount.Id;

            Contact testContact = new Contact(LastName = 'Test', AccountId = accountId);
            insert testContact;

            Id contactId = testContact.Id;
            Id profileId = [SELECT Id FROM Profile WHERE Name = 'Customer Community User' LIMIT 1].Id;

            User testUser = new User(LastName = 'test',
            FirstName='test',
            Alias = 'testT',
            Email = 'test@test.com',
            Username = 'testtestg@test.com',
            ProfileId = profileId,
            ContactId = contactId,
            TimeZoneSidKey = 'GMT',
            LanguageLocaleKey = 'en_US',
            EmailEncodingKey = 'UTF-8',
            isActive = true,
            LocaleSidKey = 'en_US'
            );
            insert testUser;
        
            List<Account> accs = new List<Account>();
            for (Integer i = 0; i < 100; i++) {
                Account acc = new Account(
                    Name = 'Test ' + i,
                    PrimaryContactId__c = contactId
                );
                accs.add(acc);
            }
            insert accs;
        }
    }

    @isTest
    static void getCommunityUserAllAccountsTest() {
        User testUser = [SELECT Id FROM User WHERE Email = 'test@test.com' LIMIT 1];
        System.runAs(testUser) {
            Id userId = UserInfo.getUserId();
            Id contactId = [SELECT ContactId FROM User WHERE Id =: userId LIMIT 1].ContactId;
            List<Account> allAccounts = [SELECT Name, Id FROM Account WHERE PrimaryContactId__c =: contactId];

            Test.startTest();
            System.assertEquals(allAccounts, CommunityUserAccountsController.getCommunityUserAllAccounts(userId));
            System.assertEquals(allAccounts.size(), CommunityUserAccountsController.getCommunityUserAllAccounts(userId).size());
            Test.stopTest();
        }
    }



    @isTest
    static void deleteAccountByCommunityUserTest() {
        User testUser = [SELECT Id FROM User WHERE Email = 'test@test.com' LIMIT 1];
        System.runAs(testUser) {
            Id userId = UserInfo.getUserId();
            Id contactId = [SELECT ContactId FROM User WHERE Id =: userId LIMIT 1].ContactId;

            Integer random = Integer.valueof(Math.random() * 100);
            String accountName = 'Test ' + random;
            Account accountToDelete = [SELECT Id FROM Account WHERE PrimaryContactId__c =: contactId AND Name =: accountName];

            Test.startTest();
            CommunityUserAccountsController.deleteAccountByUserAccess(accountToDelete.Id);
            if (Schema.sObjectType.Account.isDeletable()) {
            System.assertEquals(false, [SELECT Id, isDeleted FROM Account WHERE Id =: accountToDelete.Id].isDeleted);
            } else {
            System.assertEquals(true, [SELECT Id FROM Account WHERE Id =: accountToDelete.Id AND PrimaryContactId__c =: contactId].isEmpty());
            }
            Test.stopTest();
        }
    }
}