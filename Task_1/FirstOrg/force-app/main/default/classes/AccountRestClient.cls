public with sharing class AccountRestClient {

    @future(callout=true)
    public static void insertAccountsToRemote(List<Id> accsToSync) {
        List<Account> accounts = getAccountsByIds(accsToSync);
        prepareAccounts(accounts);

        SObjectsRequestWrapper wrapper = new SObjectsRequestWrapper(accounts, true);

        Http http = new Http();
        HttpRequest request = new HttpRequest();  
        request.setEndpoint('callout:First_Credentials/services/data/v49.0/composite/sobjects');  
        request.setMethod('POST');    
        request.setHeader('Content-Type', 'application/json;charset=UTF-8');

        request.setBody(JSON.serialize(wrapper)); 
        
        HttpResponse response = http.send(request);
    
        List<SObjectInsertResponse> resultItems = (List<SObjectInsertResponse>) JSON.deserialize(
            response.getBody(), List<SObjectInsertResponse>.class);

        
        for(Integer i = 0; i < resultItems.size(); i++) {
            accounts[i].External_Id__c = (String)resultItems[i].id;
        }
        
        update accounts;
    }

    @future(callout=true)
    public static void updateAccountsInRemote(List<Id> accsToUpdate) {    
        List<Account> accounts = getAccountsByIds(accsToUpdate);
        prepareAccounts(accounts);
        
        SObjectsRequestWrapper wrapper = new SObjectsRequestWrapper(accounts, true);
    
        Http http = new Http();
        HttpRequest request = new HttpRequest();  
        request.setEndpoint('callout:First_Credentials/services/data/v49.0/composite/sobjects');  
        request.setMethod('PATCH');    
        request.setHeader('Content-Type', 'application/json;charset=UTF-8');
        request.setBody(JSON.serialize(wrapper)); 

        HttpResponse response = http.send(request);
    }

    private static List<Account> getAccountsByIds(List<Id> accIds) {
        return [SELECT Name, AccountNumber, Phone, BillingStreet, 
            BillingCity, BillingCountry, BillingState, 
            BillingPostalCode, BillingLatitude, BillingLongitude, 
            ShippingStreet, ShippingCity, ShippingCountry, 
            ShippingState, ShippingPostalCode, ShippingLatitude, 
            ShippingLongitude, External_Id__c
            FROM Account WHERE Id = :accIds];
    }

    // private static List<Account> cloneAccounts(List<Account> accs) {
    //     List<Account> clonedList = new List<Account>();

    //     for(Account a: accs) {
    //         Account clonedAcc = a.clone(false, true, true, true);
    //         clonedAcc.Id = a.External_Id__c;
    //         clonedAcc.External_Id__c = a.Id;

    //         clonedList.add(clonedAcc);
    //     }

    //     return clonedList;
    // }

    private static void prepareAccounts(List<Account> accounts) {
        for (Account account : accounts) {
            Id localId = account.Id;

            account.Id = account.External_Id__c;
            account.External_Id__c = localId;
            account.Is_External__c = true;
        }
    }
}