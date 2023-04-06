public with sharing class EventSpeakerListController {
    public EventSpeakerListController() {

    }

    @AuraEnabled(cacheable = true)
    public static List<Event_Speaker__c> getEventSpeakers(Id eventRecordId) {
        List<Event_Speaker__c> organizersList = 
        [SELECT Id, Speaker__r.Id, Speaker__r.Name, Speaker__r.Phone__c, Speaker__r.Email__c, Event__r.Id 
        FROM Event_Speaker__c WHERE Event__r.Id =: eventRecordId];

        return organizersList;
    }
}