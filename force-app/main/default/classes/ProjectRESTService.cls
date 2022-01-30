@RestResource(urlMapping='/project/*')
global class ProjectRESTService {
    //   /services/apexrest/project/
    @HttpPost
    global static String postProjectData() {

        String requestBody = RestContext.request.requestBody.ToString().replace('\r\n', '');
        // return requestBody;
        Map<String, Object> jsonMap = (Map<String, Object>) JSON.deserializeUntyped(requestBody);

        Savepoint sp = Database.setSavepoint();

        Project__c project = new Project__c();
        project.Name = (String) jsonMap.get('ProjectName');
        project.ProjectRef__c = (String) jsonMap.get('ProjectRef');
        project.Opportunity__c = (String) jsonMap.get('OpportunityId');
        project.Start_Date__c = Date.valueOf(jsonMap.get('StartDate'));
        project.End_Date__c = Date.valueOf(jsonMap.get('EndDate'));
        project.Billable_Amount__c = (Double) Double.valueOf(jsonMap.get('Amount'));
        project.Status__c = (String) jsonMap.get('Status');

        try {
            upsert project ProjectRef__c;
        } catch (Exception e) {
            System.debug(e.getMessage());
            Database.rollback(sp);
            return e.getMessage();
        }

        Opportunity opp = [SELECT Id, DeliveryInstallationStatus__c FROM Opportunity WHERE Id =: project.Opportunity__c][0];
        // if (opp == null) {
        //     return 'No opportunity';
        // }

        opp.DeliveryInstallationStatus__c = 'In progress';

        try {
            update opp;
        } catch (Exception e) {
            System.debug(e.getMessage());
            Database.rollback(sp);
            return e.getMessage();
        }

        return 'OK';
    }
}