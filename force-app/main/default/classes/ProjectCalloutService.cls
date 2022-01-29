public class ProjectCalloutService {
    //Complete the implementation for business and callout logic
    @InvocableMethod
	public static void postOpportunityToPMS(List<Id> idOpps) {
        
        if (idOpps.isEmpty()) {
            System.debug('No Opportunities to send');
            return;
        }
        System.enqueueJob(new QueueablePMSCall(idOpps[0]));        
    }



    public with sharing class QueueablePMSCall implements System.Queueable, Database.AllowsCallouts {

        private Id idOpp;

        public QueueablePMSCall(Id idOpp) {
            this.idOpp = idOpp;
        }
        
        public void execute(QueueableContext context) {

            String token = ServiceTokens__c.getInstance('ProjectServiceToken').Token__c;

            List<Opportunity> oppList = [SELECT Account.Name,Amount,CloseDate,Id,Name FROM Opportunity WHERE Id = :idOpp];
            Opportunity opp = oppList[0];
            
            Http http = new Http();
            HttpRequest request = new HttpRequest();
            request.setEndpoint('callout:ProjectService');
            request.setHeader('Content-Type', 'application/json;charset=UTF-8');
            request.setHeader('token', token);
            request.setBody(makeJSONBody(opp));
        }

        private String makeJSONBody (Opportunity opp) {

            JSONGenerator gen = JSON.createGenerator(true);
    
                gen.writeStartObject();
    
                gen.writeStringField('opportunityId', opp.Name);
                gen.writeStringField('opportunityName', opp.Id);
                gen.writeStringField('accountName', opp.Account.Name);
                gen.writeDateField('closeDate', opp.CloseDate);
                gen.writeNumberField('amount', opp.Amount);
                    
                gen.writeEndObject();
    
                return gen.getAsString();
        }
    }
}