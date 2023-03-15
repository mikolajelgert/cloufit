@isTest
private with sharing class ErrorLogTest {
    @TestSetup
    static void setup(){
        List<Error_Log__c> errorLogs = new List<Error_Log__c>();

        for(Integer i = 0; i < 3; i++) {
            errorLogs.add(new Error_Log__c(Log_Date_Time__c = system.now(), 
                                           Process_Name__c = 'Process Name ' + i, 
                                           Log_Details__c = 'LogDetails ' + i));
        }

        insert(errorLogs);
    }

    @isTest
    static void insertErrorLogTest() {
        List<Error_Log__c> errorLogs = [SELECT Id FROM Error_Log__c];

        Test.startTest();
        Database.SaveResult[] results = Database.update(errorLogs);
        Test.stopTest();

        System.assertEquals(3, errorLogs.size());
        for (Database.SaveResult result: results) {
            System.assert(result.getErrors().isEmpty() == true);
            System.assertEquals(true, result.isSuccess());
        }
    }
}