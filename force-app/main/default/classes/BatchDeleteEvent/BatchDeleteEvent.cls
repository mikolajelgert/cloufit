global with sharing class BatchDeleteEvent implements Database.Batchable<SObject>{
    
    global Database.QueryLocator start(Database.BatchableContext BC) {
        return Database.getQueryLocator(BatchDeleteEventHandler.getQuery());
    }

    global void execute(Database.BatchableContext BC, List<Event__c> eventList) {
        BatchDeleteEventHandler.deleteEvents(eventList);
    }

    global void finish(Database.BatchableContext BC) {
        BatchDeleteEventHandler.sendConfirmationEmailTo('mikolajelgert@gmail.com');
    }


}