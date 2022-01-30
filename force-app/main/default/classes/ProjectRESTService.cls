@RestResource(urlMapping='/project/*')
global class ProjectRESTService {
    //   /services/apexrest/project/
    @HttpPost
    global static String postProjectData(String ProjectRef,
                                        String ProjectName,
                                        String OpportunityId,
                                        Date StartDate,
                                        Date EndDate,
                                        Double Amount,
                                        String Status) {

        Savepoint sp = Database.setSavepoint();

        Project__c project = new Project__c();
        project.Name = ProjectName;
        project.ProjectRef__c = ProjectRef;
        project.Opportunity__c = OpportunityId;
        project.Start_Date__c = StartDate;
        project.End_Date__c = EndDate;
        project.Billable_Amount__c = Amount;
        project.Status__c = Status;

        try {
            upsert project ProjectRef__c;
            Opportunity opp = [SELECT Id, DeliveryInstallationStatus__c FROM Opportunity WHERE Id =: OpportunityId];

            opp.DeliveryInstallationStatus__c = 'In progress';

            update opp;
            return 'OK';

        } catch (Exception e) {
            Database.rollback(sp);
            return e.getMessage();
        }
    }
}