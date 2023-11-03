public with sharing class ErrorLog {
    public static void insertErrorLog(String logProcessName) {
        Error_Log__c errorLog = new Error_Log__c();
        errorLog.Log_Date_Time__c = System.now();
        
        errorLog.Log_Details__c = ex.getStackTraceString() +
        '<br/> <strong> Mesage is </strong> ' + ex.getMessage() + 
        '<br/> ' + ex.getCause() +' <br/> '+ ex.getTypeName()+' <br/> '+ex.getLineNumber();

        errorLog.Process_Name__c = logProcessName;
        Database.insert(errorLog, false);
    }
}