@isTest
private with sharing class DuplicateEventSpeakerHandlerTest {
   
    @testSetup
    static void setup(){

        List<Speaker__c> speakers = new List<Speaker__c>();

        for (Integer i = 0; i < 2; i++) {
            speakers.add(new Speaker__c(Name = 'Test ' + i, Phone__c = String.valueOf(9 * i), Email__c = 'test' + i + '@gmail.com'));
        }

        insert(speakers);

        List<Speaker__c> speakersNegativeCases = new List<Speaker__c>();

        for (Integer i = 0; i < 2; i++) {
            speakersNegativeCases.add(new Speaker__c(Name = 'TestNegative ' + i, Phone__c = String.valueOf(9 * i + 1), Email__c = 'testNegative' + i + '@gmail.com'));
        }

        insert(speakersNegativeCases);

        List<Event_Organizer__c> eventOrganizers = new List<Event_Organizer__c>();

        for (Integer i = 0; i < speakers.size(); i++) {
            eventOrganizers.add(new Event_Organizer__c(Name = 'OrganizerTest ' + i, Email__c = 'organizerTest' + i + '@gmail.com', Phone__c = String.valueOf(9 * i)));
        }

        insert(eventOrganizers);

        List<Event__c> events = new List<Event__c>();

        for (Integer i = 0; i < speakers.size(); i++) {
            events.add(new Event__c(Name__c = 'Event ' + i, 
                                    Max_Seats__c = i + 5, 
                                    Event_Organizer__c = eventOrganizers.get(i).Id, 
                                    Start_Date_Time__c = system.now(),
                                    Live__c = true));
        }

        insert(events);

        List<Event__c> newEvents = new List<Event__c>();

        for (Integer i = 0; i < speakers.size(); i++) {
            newEvents.add(new Event__c(Name__c = 'NewEvent ' + i, 
                                    Max_Seats__c = i + 6, 
                                    Event_Organizer__c = eventOrganizers.get(i).Id, 
                                    Start_Date_Time__c = system.now(),
                                    Live__c = true));
        }

        insert(newEvents);
        
        List<Event_Speaker__c> eventSpeakers = new List<Event_Speaker__c>();

        for (Integer  i = 0; i < speakers.size();  i++) {
            eventSpeakers.add(new Event_Speaker__c(Name = speakers.get(i).Name, Event__c = events.get(i).Id, Speaker__c = speakers.get(i).Id));
        }

        insert(eventSpeakers);

       
        List<Event_Speaker__c> eventNewSpeakers = new List<Event_Speaker__c>();

        for (Integer  i = 0; i < speakers.size();  i++) {
            eventNewSpeakers.add(new Event_Speaker__c(Name = speakersNegativeCases.get(i).Name, Event__c = newEvents.get(i).Id, Speaker__c = speakersNegativeCases.get(i).Id));
        }

        insert(eventNewSpeakers);
    
    }

    @isTest
    static void testPositiveCases() {

        List<Event_Speaker__c> eventSpeakers = [SELECT Name, Event__r.Name__c, Speaker__c FROM Event_Speaker__c];

        List<Event__c> newEvents = [SELECT Id, Name__c FROM Event__c WHERE Name__c = 'NewEvent 0' OR Name__c = 'NewEvent 1'];

        for (Integer i = 0; i < eventSpeakers.size(); i++) {
            eventSpeakers.get(i).Event__r.Name__c = newEvents.get(i).Name__c;
        }

        Test.startTest();
        try{
            update(eventSpeakers);
        }catch(DmlException ex) {
            Boolean expectedExceptionThrown =  (ex.getMessage().contains('This speaker is already assigned to the event.')) ? true : false;
            System.assertEquals(expectedExceptionThrown, true);
        }
        Test.stopTest();
    }

    @isTest
    static void testNegativeCases() {

        List<Event_Speaker__c> eventNewSpeakers = new List<Event_Speaker__c>();
        List<Speaker__c> speakersName = [SELECT Id, Name FROM Speaker__c WHERE Name = 'TestNegative 0' OR Name = 'TestNegative 1'];
        List<Event__c> eventsName = [SELECT Id FROM Event__c]; 

        for (Integer i = 0; i < 2; i++) {
            eventNewSpeakers.add(new Event_Speaker__c(Name = speakersName.get(i).Name, Event__c = eventsName.get(i).Id, Speaker__c = speakersName.get(i).Id));
        }

        Test.startTest();
        Database.SaveResult[] results = Database.insert(eventNewSpeakers);
        Test.stopTest();

        for (Database.SaveResult result: results) {
            System.assert(result.getErrors().isEmpty() == true);
            System.assertEquals(true, result.isSuccess());
        }

    }
}