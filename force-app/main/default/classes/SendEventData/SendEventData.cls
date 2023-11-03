@RestResource(urlMapping='/Event__c/')
global with sharing class SendEventData {
    
    @HttpGet
    global static List<Event__c> doGet() {
        List<Event__c> events = [SELECT Name__c, Event_Type__c, Frequency__c, Event_Organizer__r.Name, Max_Seats__c, 
        Location__r.Name, People_Attending__c, Event_Detail__c, Start_Date_Time__c, End_Date_Time__c, Live__c 
        FROM Event__c WHERE Live__c = true AND Start_Date_Time__c > TODAY ORDER BY Id ASC];
        return events;
    }
}