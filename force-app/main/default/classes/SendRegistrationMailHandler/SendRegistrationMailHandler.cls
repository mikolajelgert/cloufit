public with sharing class SendRegistrationMailHandler {

    public static void sendMailToEventAttendee(List<Event_Attendee__c> event_AttendeeList) {

        List<Messaging.Email> allMails = new List<Messaging.Email>();
        Set<Id> attendeesId = new Set<Id>();
        Set<Id> eventsId = new Set<Id>();
        for (Event_Attendee__c eventAttendee: event_AttendeeList) {
            attendeesId.add(eventAttendee.Attendee__c);
            eventsId.add(eventAttendee.Event__c);
        }

        Attendee__c attendeesToAddress = [SELECT Id, Name, Email__c FROM Attendee__c WHERE Id IN: attendeesId];

        Messaging.SingleEmailMessage mail = new Messaging.SingleEmailMessage();

        String[] toAddress = new String[] {attendeesToAddress.Email__c};

        mail.setToAddresses(toAddress);

        //email sent from
        mail.setReplyTo('mikolaj.elgert@cloobees.com');
        mail.setSenderDisplayName('Mikołaj Elgert');

        Event__c eventDetails = [SELECT Id, Name, Start_Date_time__c, Location__r.Name, Event_Organizer__r.Name FROM Event__c WHERE Id IN: eventsId];

        String locationOption;
        if (eventDetails.Location__r.Name != null) {
            locationOption = '" & will be </br>held in "' + eventDetails.Location__r.Name + '"';
        } else {
            locationOption = '" & will take </br>place virtually';
        }

        Datetime properDateTime = eventDetails.Start_Date_Time__c.addHours(1);
        //email content
        mail.setSubject('Pass for the "' + attendeesToAddress.Name + '"');
        String body = 'Dear ' +  attendeesToAddress.Name + ',</br></br>Thank you for registering for "' + eventDetails.Name +
        '" which will be organized on "' + properDateTime + locationOption +
        '. We are excited to have you, see you in the event.' + '</br></br>Find the Google Map Location for the Event here. (https://www.google.com/maps/place/)' +
        ' + Add your Location Here.</br></br>Thanks,</br></br>"' + eventDetails.Event_Organizer__r.Name + '"'; 
        mail.setHtmlBody(body);

        //add emails to list and send them
        allMails.add(mail);
        Messaging.sendEmail(allMails);

    }
}