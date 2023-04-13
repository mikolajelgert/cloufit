public with sharing class UpcomingEventsListController {
    
    @AuraEnabled(cacheable=true)
    public static List<Event__c> getUpcomingEvents(String nameTextKey, String locationTextKey, Date startDateTextKey) {
        nameTextKey = '%' + nameTextKey + '%';
        locationTextKey = '%' + locationTextKey + '%';

        List<Event__c> events = [SELECT Id, Name, Name__c, Event_Organizer__r.Name, Location__r.Name, Start_Date_Time__c
        FROM Event__c WHERE Live__c = true];

        if (nameTextKey != '' || locationTextKey != '' || startDateTextKey != null) {
            events = [SELECT Id, Name, Name__c, Event_Organizer__r.Name, Location__r.Name, Start_Date_Time__c
            FROM Event__c WHERE Live__c = true AND Name__c LIKE: nameTextKey AND Location__r.Name LIKE: locationTextKey
            AND Start_Date_Time__c >=: startDateTextKey];
        }
        
        return events;
    }
}