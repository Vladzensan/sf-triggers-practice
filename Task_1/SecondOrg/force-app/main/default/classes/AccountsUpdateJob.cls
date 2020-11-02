public with sharing class AccountsUpdateJob implements Queueable, Database.AllowsCallouts {
    List<Id> accsToUpdate;

    public AccountsUpdateJob(List<Id> accsToUpdate) {
        this.accsToUpdate = accsToUpdate;
    }

    public void execute(QueueableContext context){
        List<Account> accounts = AccountRestHelper.getAccountsByIds(accsToUpdate);
        List<Account> cloned = AccountRestHelper.cloneAccounts(accounts);
        
        SObjectsRequestWrapper wrapper = new SObjectsRequestWrapper(cloned, true);
    
        Http http = new Http();
        HttpRequest request = new HttpRequest();  
        request.setEndpoint('callout:Second_Credentials/services/data/v49.0/composite/sobjects');  
        request.setMethod('PATCH');    
        request.setHeader('Content-Type', 'application/json;charset=UTF-8');
        request.setBody(JSON.serialize(wrapper)); 

        HttpResponse response = http.send(request);
    }
}
