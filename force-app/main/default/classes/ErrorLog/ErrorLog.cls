public with sharing class ErrorLog {
    public static void insertErrorLog(Datetime logDateTime, String logProcessName, String logDetails) {
        Error_Log__c errorLog = new Error_Log__c();
        errorLog.Log_Date_Time__c = logDateTime;
        errorLog.Log_Details__c = logDetails;
        errorLog.Process_Name__c = logProcessName;
        Database.insert(errorLog, false);
    }
}