trigger VerifyAddress on Location__c (before insert, before update) {
    if (Trigger.isBefore) {
        for (Location__c location: Trigger.new) {
            if (!System.isFuture() && !System.isBatch())
                VerifyAddressHandler.doFuture(JSON.serialize(location));
        }
    }
}