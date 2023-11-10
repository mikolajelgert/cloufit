public with sharing class CommunityUserAccountsController {

    @AuraEnabled(cacheable = true)
    public static List<Account> getCommunityUserAllAccounts(Id userId) {
        User userContactId = [SELECT ContactId FROM User WHERE Id =: userId LIMIT 1];
        List<Account> result = new List<Account>();

        if (userContactId.ContactId != null) {
            result = [SELECT Name, AccountNumber, SLA__c, Phone 
            FROM Account 
            WHERE PrimaryContactId__c =: userContactId.ContactId
            ORDER BY Name ASC];
        }
        return result;
    }

    @AuraEnabled
    public static void deleteAccountByUserAccess(Id accountId) {
        Account accountToDelete = [SELECT Id, Name FROM Account WHERE Id =: accountId LIMIT 1];
        if (accountToDelete != null) {
            if (Schema.sObjectType.Account.isDeletable()) {
                try {
                    delete(accountToDelete);
                } catch(DMLException e) {
                    e.getMessage();
                }
            } else {
                accountToDelete.PrimaryContactId__c = null;
                update(accountToDelete);
            }
        }
    }
 }