trigger DuplicateEventSpeaker on Event_Speaker__c (before insert, before update) {
        if (Trigger.isBefore) {
            DuplicateEventSpeakerHandler.duplicateEventSpeaker(Trigger.new);
        }
}