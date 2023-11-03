public with sharing class CommunityUserAccountsController {
    private static Account userInfo = [SELECT Id, Name FROM Account 
    WHERE Name = 'Marcin' LIMIT 1];

    @AuraEnabled
    public static void deleteAccountByUserAccess(Id accountId) {
        Account accountToDelete = [SELECT Id, Name FROM Account 
        WHERE Id =: accountId AND ParentId =: userInfo.Id LIMIT 1];

        if (Schema.sObjectType.Account.isDeletable()) {
            try {
                delete(accountToDelete);
            } catch(Exception e) {
                System.debug(e.getMessage());
            }
        } else {
            accountToDelete.ParentId = null;
            update(accountToDelete);
        }
    }

    @AuraEnabled(cacheable = true)
    public static List<Account> getCommunityUserAllAccounts() {
        return [SELECT Id, Name, AccountNumber, SLASerialNumber__c, Phone
        FROM Account WHERE ParentId =: userInfo.Id ORDER BY Name ASC];
    } 

    @AuraEnabled(cacheable = true)
    public static List<WrapperClass> getCommunityUserAccountsByLimit(Integer recordsLimit, Integer offset) {
        List<Account> userAccounts = [SELECT Id, Name, AccountNumber, SLASerialNumber__c, Phone
        FROM Account WHERE ParentId =: userInfo.Id ORDER BY Name ASC LIMIT :recordsLimit OFFSET :offset ];

        List<WrapperClass> wrapAccounts = new List<WrapperClass>();

        for (Account account: userAccounts) {
            WrapperClass wrapAccount = new WrapperClass();

            wrapAccount.id = account.Id;
            wrapAccount.accountName = account.Name;
            wrapAccount.accountNumber = account.AccountNumber;
            wrapAccount.accountSLA = account.SLASerialNumber__c;
            wrapAccount.accountPhone = account.Phone;

            wrapAccounts.add(wrapAccount);
        }

        return wrapAccounts;
    }

    private class WrapperClass {

        @AuraEnabled
        public Id id;

        @AuraEnabled
        public String accountName;

        @AuraEnabled
        public String accountNumber;

        @AuraEnabled
        public String accountSLA;

        @AuraEnabled
        public String accountPhone;

    }
}