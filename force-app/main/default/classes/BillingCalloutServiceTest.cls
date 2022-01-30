@isTest
private class BillingCalloutServiceTest {
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

    ServiceCredentials__c sc = new ServiceCredentials__c();
    sc.Name = 'BillingServiceCredential';
    sc.Username__c = 'testUser';
    sc.Password__c = 'testPass';
    insert sc;

    Project__c proj = new Project__c();
    proj.Billable_Amount__c = 100;
    proj.End_Date__c = Date.today().addDays(22);
    proj.Opportunity__c = opp.Id;
    proj.Name	= 'TestName';
    proj.ProjectRef__c = 'ProjectRef';
    proj.Start_Date__c = Date.today();
    proj.Status__c = 'Running';
    insert proj;
  }

  @isTest
  static void successBillingCalloutServiceTest() {

    Test.setMock(WebServiceMock.class, new BillingCalloutServiceMock());

    Project__c proj = [SELECT Status__c FROM Project__c];

    proj.Status__c = 'Billable';
    Test.startTest();
    update proj;
    Test.stopTest();

    Project__c projNew = [SELECT Status__c FROM Project__c];
    System.assertEquals('Billed', projNew.Status__c);
  }

  @isTest
  static void FailureBillingCalloutServiceTest() {

    Test.setMock(WebServiceMock.class, new BillingCalloutServiceMockFailure());

    Project__c proj = [SELECT Status__c FROM Project__c];

    proj.Status__c = 'Billable';
    proj.ProjectRef__c = '';
    Test.startTest();
    update proj;
    Test.stopTest();

    Project__c projNew = [SELECT Status__c FROM Project__c];
    System.assertNotEquals('Billed', projNew.Status__c);
  }
}