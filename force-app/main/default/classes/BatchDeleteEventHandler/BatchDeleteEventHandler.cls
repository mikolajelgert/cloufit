public with sharing class BatchDeleteEventHandler {
    private static final String QUERY = 'SELECT Id, Name, End_Date_Time__c, Live__c FROM Event__c';

    /*
    execute in executeBatchDeleteEvent.apex script
    */
    public static String getQuery() {
        return QUERY;
    }

    public static void deleteEvents(List<Event__c> eventList) {
        Datetime twoMonthsOld = System.now().addMonths(-2);

        for (Event__c event: eventList) {
            if (event.End_Date_Time__c <= twoMonthsOld && event.Live__c == false) {
                try {
                    delete(event);
                }catch(DmlException ex) {
                    ex.getStackTraceString();
                    ErrorLog.insertErrorLog(System.now(), 'Apex Batch Fail', 'Apex Batch failure during old events deletion.');
                }
            }
        }
    }

    public static void sendConfirmationEmailTo(String sendTo) {
        List<Messaging.Email> allMails = new List<Messaging.Email>();
        Messaging.SingleEmailMessage message = new Messaging.SingleEmailMessage();
        String[] toAddress = new String[] {sendTo};

        message.setToAddresses(toAddress);

        message.setReplyTo('mikolaj.elgert@cloobees.com');
        message.setSenderDisplayName('Mikołaj Elgert');

        message.setSubject('Batch execution');
        String body = 'Execution of the batch has been processed.';
        message.setHtmlBody(body);

        allMails.add(message);

        Messaging.sendEmail(allMails);
    }
}