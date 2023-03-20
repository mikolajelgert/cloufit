public with sharing class VerifyAddressHandler {

    @Future(callout = true)
    public static void doFuture(String sObjectData) {
        Location__c location = (Location__c) JSON.deserializeStrict(sObjectData, Location__c.class);
        System.debug(' #### Location data: ' + location);
        verifyAddress(location);
    }

    public static void verifyAddress(Location__c location) {

        //setting up request
        Http http = new Http();
        HttpRequest request = new HttpRequest();
        
        String street = location.Street__c.replace(' ', '%20');
        String endPoint = 'https://international-street.api.smartystreets.com/verify?auth-id=7155de83-62d4-b009-294b-2511f5f9410c&auth-token=6911xhUmHCmzCIZbPr8i&country=' 
        + location.Country__c + '&address1=' + street + '&locality=' + location.City__c + '&postal_code=' + location.Postal_Code__c;

        request.setHeader('Accept', 'application/json');
        request.setHeader('Content-Type', 'application/json');
        request.setHeader('Host', 'international-street.api.smartystreets.com');
        request.setMethod('GET');
        request.setEndpoint(endPoint);

        try {
            HttpResponse response = http.send(request);
            
            List<Object> fieldList = (List<Object>) JSON.deserializeUntyped(response.getBody());
            Boolean verified = false;
            for(Object fld : fieldList){    

                //getting specific values from JSON
                Map<String,Object> data = (Map<String,Object>) fld;
                Map<String,Object> analysisMap = (Map<String,Object>) data.get('analysis');
                Map<String,Object> changesMap = (Map<String,Object>) analysisMap.get('changes');
                Map<String,Object> componentsMap = (Map<String,Object>) changesMap.get('components');
                
                String noChanged = 'Verified-NoChange';
                if (analysisMap.get('verification_status') == 'Verified' || 
                (componentsMap.get('locality') == noChanged && componentsMap.get('postal_code') == noChanged))
                    verified = true;

                system.debug('locality: ' + componentsMap.get('locality'));
            }
            system.debug('Verified: ' + verified);
            
            //checking values to verify the address and sign a checkbox
            if (response.getStatusCode() == 200 && response.getBody() != null && verified == true) {
                location.Verified__c = true;
            } else {
                location.Verified__c = false;
            }

            //inserting proper location verification
            try {
                upsert(location);
            }catch(DmlException ex) {
                System.debug(' #### ' + ex);
                ErrorLog.insertErrorLog(System.now(), 'Cause: ' + ex.getCause(),
                'Type: ' + ex.getTypeName() + '. Message: ' + ex.getMessage() + '. StackTrace: ' + ex.getStackTraceString());
            }

        } catch(System.CalloutException ex) {
            System.debug(' #### ' + ex);
            ErrorLog.insertErrorLog(System.now(), 'Cause: ' + ex.getCause(),
            'Type: ' + ex.getTypeName() + '. Message: ' + ex.getMessage() + '. StackTrace: ' + ex.getStackTraceString());
        }
    }
}