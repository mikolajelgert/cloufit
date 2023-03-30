public with sharing class EventLocationDetails {
    public EventLocationDetails() {

    }

    @AuraEnabled(cacheable = true)
    public static Id getLocationId(Id eventRecordId) {
        Event__c event = [SELECT Id, Location__c FROM Event__c WHERE Id =: eventRecordId];
        System.debug(event);
        return event.Location__c;
    }
}