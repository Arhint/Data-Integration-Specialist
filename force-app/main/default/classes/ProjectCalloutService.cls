public class ProjectCalloutService {
    //Complete the implementation for business and callout logic
    @InvocableMethod
	public static void postOpportunityToPMS(List<Id> idOpps) {
        
        Http http = new Http();
        HttpRequest request = new HttpRequest();
        request.setEndpoint('callout:ProjectService');
        request.setHeader('Content-Type', 'application/json;charset=UTF-8');
    }

    public with sharing class QueueablePMSCall implements System.Queueable, Database.AllowsCallouts {
        
        public void execute(QueueableContext context) {

        }
    }

}