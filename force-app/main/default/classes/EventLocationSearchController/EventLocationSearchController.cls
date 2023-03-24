public with sharing class EventLocationSearchController {
    public EventLocationSearchController() {

    }

    @AuraEnabled(cacheable = true)
    public static List<Location__c> getLocations(String locationName) {
        List<Location__c> locationsList = new List<Location__c>();

        if (locationName != null) {
            String locName = '%' + locationName + '%';
            locationsList = [SELECT Id, Name FROM Location__c WHERE Name LIKE: locName];
            return locationsList;
        }

        return locationsList;
    }
}