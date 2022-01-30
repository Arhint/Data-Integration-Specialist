@isTest
private class ProjectRESTServiceTest {
  //Implement Apex REST service tests here
  @TestSetup
  static void makeData(){
      Account acc = new Account(Name='Account for tests');
      insert acc;

      Opportunity opp = new Opportunity();

      opp.Name = 'Opportunity for tests';
      opp.CloseDate = Date.today().addDays(48);
      opp.StageName = 'Qualification';
      opp.Accountid = acc.Id;
      opp.Amount = 8000;
      insert opp;
  }

  @isTest
  static void successTestForProjectRESTService(){

      Opportunity opp = [SELECT Id FROM Opportunity];
    
      Test.startTest();
      String res = ProjectRESTService.postProjectData('ProjectRef',
                                          'Super-Duper Big Deal',
                                          opp.Id,
                                          Date.today(),
                                          Date.today().addDays(22),
                                          80,
                                          'Running');
      Test.stopTest();

      Opportunity opp2 = [SELECT Id, DeliveryInstallationStatus__c FROM Opportunity];

      System.assertEquals('In progress', opp2.DeliveryInstallationStatus__c);

      System.assertEquals('OK', res);
  }

  @isTest
  static void failTestForProjectRESTService(){

      Opportunity opp = [SELECT Id FROM Opportunity];
    
      Test.startTest();
      String res = ProjectRESTService.postProjectData('',
                                          'Super-Duper Big Deal',
                                          opp.Id,
                                          Date.today(),
                                          Date.today().addDays(22),
                                          80,
                                          'Running');
      Test.stopTest();
      System.assertEquals(0, [SELECT Id FROM Project__c].size());
  }
}