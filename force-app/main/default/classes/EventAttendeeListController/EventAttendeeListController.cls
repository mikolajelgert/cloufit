public with sharing class EventAttendeeListController {

    @AuraEnabled(cacheable=true)
    public static List<WrapperClass> getEventAttendees(Id eventRecordId) {

        List<Event_Attendee__c> eventAttendees = 
        [SELECT Id, Attendee__r.Id, Name, Attendee__r.Phone__c, Attendee__r.Email__c, 
        Attendee__r.Company_Name__c, Attendee__r.Location__r.Name, Event__r.Id 
        FROM Event_Attendee__c WHERE Event__r.Id =: eventRecordId];

        List<WrapperClass> wrapList = new List<WrapperClass>();

        for (Event_Attendee__c eventAttendee: eventAttendees) {
            WrapperClass wrapItemfld = new WrapperClass();
            wrapItemfld.Name = eventAttendee.Name;
            wrapItemfld.Phone = eventAttendee.Attendee__r.Phone__c;
            wrapItemfld.Email = eventAttendee.Attendee__r.Email__c;
            wrapItemfld.Company = eventAttendee.Attendee__r.Company_Name__c;
            wrapItemfld.Location = eventAttendee.Attendee__r.Location__r.Name;

            wrapList.add(wrapItemfld);
        }

        return wrapList;
    }

    private class WrapperClass {
        @AuraEnabled
        public String Name;

        @AuraEnabled
        public String Phone;

        @AuraEnabled
        public String Email;

        @AuraEnabled
        public String Company;

        @AuraEnabled
        public String Location;
    } 
}
