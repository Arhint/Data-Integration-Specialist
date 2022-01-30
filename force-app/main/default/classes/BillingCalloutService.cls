public class BillingCalloutService {
    //Implement business and callout logic methods here
    @future(callout=true)
    public static void callBillingService(String ProjectRef, Decimal Amount) {

        ServiceCredentials__c sc = ServiceCredentials__c.getInstance('BillingServiceCredential');

        BillingServiceProxy.project proj = new BillingServiceProxy.project();
        proj.billAmount = Amount;
        proj.projectid = ProjectRef;
        proj.password = sc.Password__c;
        proj.username = sc.Username__c;

        BillingServiceProxy.InvoicesPortSoap11 InvoicesPortSoap = new BillingServiceProxy.InvoicesPortSoap11();
        String Status = InvoicesPortSoap.billProject(proj);

        if (Status == 'OK') {
            Project__c projectToUpdate = [SELECT ProjectRef__c FROM Project__c];

            projectToUpdate.Status__c = 'Billed';
            update projectToUpdate;
        }
    }
}