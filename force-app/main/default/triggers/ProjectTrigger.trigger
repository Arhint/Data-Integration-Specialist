trigger ProjectTrigger on Project__c (after update) {
    //Call the Billing Service callout logic here
    if (Trigger.isAfter) {
        if (Trigger.isUpdate) {
            for(Id key : trigger.newMap.keySet()) { 
                if (Trigger.newMap.get(key).Status__c == 'Billable' && Trigger.oldMap.get(key).Status__c != 'Billable') {
                    BillingCalloutService.callBillingService(Trigger.newMap.get(key).ProjectRef__c,
                                                             Trigger.newMap.get(key).Billable_Amount__c);
                }
                
            }
            
        }
    }
}