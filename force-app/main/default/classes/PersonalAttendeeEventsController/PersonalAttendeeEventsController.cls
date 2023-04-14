public with sharing class PersonalAttendeeEventsController {

    @AuraEnabled(cacheable=true)
    public static List<Event_Attendee__c> getUpcomingEvents(Id attendeeRecordId) {

        List<Event_Attendee__c> attendeeEvents = [SELECT Id, Event__r.Name__c, Event__r.Event_Organizer__r.Name, 
        Event__r.Start_Date_Time__c, Event__r.Location__r.Name, Event__r.Id
        FROM Event_Attendee__c WHERE Attendee__r.Id =: attendeeRecordId AND Event__r.Start_Date_Time__c >= TODAY];

        return attendeeEvents;
    }

    @AuraEnabled(cacheable=true)
    public static List<Event_Attendee__c> getPastEvents(Id attendeeRecordId) {

        List<Event_Attendee__c> attendeeEvents = [SELECT Id, Event__r.Name__c, Event__r.Event_Organizer__r.Name, 
        Event__r.Start_Date_Time__c, Event__r.Location__r.Name, Event__r.Id
        FROM Event_Attendee__c WHERE Attendee__r.Id =: attendeeRecordId AND Event__r.Start_Date_Time__c < TODAY];

        return attendeeEvents;
    }
}