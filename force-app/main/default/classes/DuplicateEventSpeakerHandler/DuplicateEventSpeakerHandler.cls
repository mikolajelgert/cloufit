public with sharing class DuplicateEventSpeakerHandler {
    public static void duplicateEventSpeaker(List<Event_Speaker__c> eventSpeakerList) {

            Set<String> speakerSet = new Set<String>();
            for (Event_Speaker__c eventSpeaker: eventSpeakerList) {
                speakerSet.add(eventSpeaker.Speaker__c);
            }

            List<Event_Speaker__c> duplicateEventSpeakers = [SELECT Speaker__c FROM Event_Speaker__c WHERE Speaker__c IN: speakerSet];

            for (Event_Speaker__c eventSpeaker: eventSpeakerList) {
                if (duplicateEventSpeakers.size() != 0) {
                    eventSpeaker.Speaker__c.addError('This speaker is already assigned to the event.');
                } 
            }
            //ErrorLog.insertErrorLog(system.now(), 'Duplicate event speaker', 'Speaker can only be assigned to one event.')
            //gdziekolwiek bym to dał, nie wyswietla rekordow
    }
}