public with sharing class AccountsInsertJob implements Queueable, Database.AllowsCallouts {
    List<Id> accsToInsert;

    public AccountsInsertJob(List<Id> accsToInsert) {
        this.accsToInsert = accsToInsert;
    }

    public void execute(QueueableContext context){
        List<Account> accounts = AccountRestHelper.getAccountsByIds(accsToInsert);
        List<Account> cloned = AccountRestHelper.cloneAccounts(accounts);

        SObjectsRequestWrapper wrapper = new SObjectsRequestWrapper(cloned, true);

        Http http = new Http();
        HttpRequest request = new HttpRequest();  
        request.setEndpoint('callout:Second_Credentials/services/data/v49.0/composite/sobjects');  
        request.setMethod('POST');    
        request.setHeader('Content-Type', 'application/json;charset=UTF-8');

        request.setBody(JSON.serialize(wrapper)); 
        
        HttpResponse response = http.send(request);

        List<SObjectInsertResponse> resultItems = (List<SObjectInsertResponse>) JSON.deserialize(
            response.getBody(), List<SObjectInsertResponse>.class);

        
        for(Integer i = 0; i < resultItems.size(); i++) {
            accounts[i].External_Id__c = (String)resultItems[i].id;
        }
        
        upsert accounts;
    }
}
