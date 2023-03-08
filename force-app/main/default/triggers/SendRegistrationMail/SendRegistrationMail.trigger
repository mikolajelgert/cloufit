trigger SendRegistrationMail on Event_Attendee__c (after insert) {
    if (Trigger.isAfter) {
        try {
        SendRegistrationMailHandler.sendMailToEventAttendee(Trigger.new);
        }catch (EmailException ex) {
            ErrorLog.insertErrorLog(system.now(), 'Email sending failed', 'Sending email to Event Attendee failed.');
        }
    }
}