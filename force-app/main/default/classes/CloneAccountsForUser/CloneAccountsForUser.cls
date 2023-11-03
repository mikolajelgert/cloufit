public with sharing class CloneAccountsForUser {
    private static Account marcinInfo = [SELECT Id, Name FROM Account WHERE Name = 'Marcin' LIMIT 1];

    public static void cloneAccountsForUser() {
        if (marcinInfo != null) {
            cloneAccounts();
        }
    }

    private static void cloneAccounts() {
        List<Account> accounts = [SELECT Id, Name, ParentId FROM Account 
        WHERE ParentId != :marcinInfo.Id AND Name !=: marcinInfo.Name];

        List<Account> toUpdate = new List<Account>();
        for (Account acc: accounts) {
            acc.ParentId = marcinInfo.Id;
            toUpdate.add(acc);
        }
        update(toUpdate);

        accounts = [SELECT Id, Name, AccountNumber, SLASerialNumber__c, Phone, ParentId 
        FROM Account WHERE Name !=: marcinInfo.Name];

        List<Account> newAccounts = new List<Account>();
        for (Account acc: accounts) {
            for (Integer i = 0; i < 3; i++) {
                Account newAccount = new Account(
                    Name = acc.Name,
                    AccountNumber = acc.AccountNumber,
                    SLASerialNumber__c = acc.SLASerialNumber__c,
                    Phone = acc.Phone,
                    ParentId = acc.ParentId);

                    newAccounts.add(newAccount);
            }
        }
        insert newAccounts;
    }
}