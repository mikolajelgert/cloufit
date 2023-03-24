public with sharing class EventOrganizerSearchController {
    public EventOrganizerSearchController() {

    }

    @AuraEnabled(cacheable = true)
    public static List<Event_Organizer__c> getEventOrganizers(String organizerName) {
        List<Event_Organizer__c> organizersList = new List<Event_Organizer__c>();

        if (organizerName != null) {
            String orgName = '%' + organizerName + '%';
            organizersList = [SELECT Id, Name FROM Event_Organizer__c WHERE Name LIKE: orgName];
            return organizersList;
        }

        return organizersList;
    }
}