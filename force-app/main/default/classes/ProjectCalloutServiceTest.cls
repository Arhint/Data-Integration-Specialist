@isTest
private class ProjectCalloutServiceTest {
    //Implement mock callout tests here
    @TestSetup
    static void makeData() {
        Account acc = new Account(Name='Account for tests');
        insert acc;

        Opportunity opp = new Opportunity();

        opp.Name = 'Opportunity for tests';
        opp.CloseDate = Date.today();
        opp.StageName = 'Qualification';
        opp.Accountid = acc.Id;
        opp.Amount = 8000;
        insert opp;

        ServiceTokens__c st = new ServiceTokens__c();
        st.Name = 'ProjectServiceToken';
        st.Token__c = 'qijncucqcnqiwcqjc';
        insert st;
    }
      @isTEst
      static void successTest() {
      
      Test.setMock(HttpCalloutMock.class, new ProjectCalloutServiceMock());

      Opportunity opp = [SELECT Id, StageName FROM Opportunity][0];
      opp.StageName = 'Closed Won';
      List<Id> idOpps = new List<Id>();
      idOpps.add(opp.id);
      Test.startTest();
      ProjectCalloutService.postOpportunityToPMS(idOpps);
      Test.stopTest();
      Opportunity oppUpdated = [SELECT Id, StageName FROM Opportunity][0];
      System.assertEquals('Submitted Project', oppUpdated.StageName);
    }
    @isTEst
    static void failTest() {
      
      Test.setMock(HttpCalloutMock.class, new ProjectCalloutServiceMockFailure());

      Opportunity opp = [SELECT Id, StageName FROM Opportunity];
      opp.StageName = 'Closed Won';
      List<Id> idOpps = new List<Id>();
      idOpps.add(opp.id);
      Test.startTest();
      ProjectCalloutService.postOpportunityToPMS(idOpps);
      Test.stopTest();
      Opportunity oppUpdated = [SELECT Id, StageName FROM Opportunity][0];
      System.assertEquals('Resubmit Project', oppUpdated.StageName);
    }

}