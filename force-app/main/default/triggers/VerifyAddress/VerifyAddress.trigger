trigger VerifyAddress on Location__c (before insert, before update) {
    if (Trigger.isBefore) {
        for (Location__c location: Trigger.new) {
            if (!System.isFuture() && !System.isBatch())
                VerifyAddressHandler.doFuture(JSON.serialize(location));
        }
        // try {
        // VerifyAddressHandler.verifyAddress(Trigger.new);
        // }catch (Exception ex) {
        //     ErrorLog.insertErrorLog(system.now(), 'Address verification fail.', 'Verifying the address on Location object failed due to callout to SmartyStreets.');
        // }
    }
}