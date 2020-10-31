public with sharing class AccountRestClient {

    @future(callout=true)
    public static void insertAccountsToRemote(List<Id> accsToSync) {
        List<Account> accounts = getAccountsByIds(accsToSync);
        List<Account> cloned = cloneAccounts(accounts);

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

    @future(callout=true)
    public static void updateAccountsInRemote(List<Id> accsToUpdate) {    
        List<Account> accounts = getAccountsByIds(accsToUpdate);
        List<Account> cloned = cloneAccounts(accounts);
        
        SObjectsRequestWrapper wrapper = new SObjectsRequestWrapper(cloned, true);
    
        Http http = new Http();
        HttpRequest request = new HttpRequest();  
        request.setEndpoint('callout:Second_Credentials/services/data/v49.0/composite/sobjects');  
        request.setMethod('PATCH');    
        request.setHeader('Content-Type', 'application/json;charset=UTF-8');
        request.setBody(JSON.serialize(wrapper)); 

        HttpResponse response = http.send(request);
    }

    @future(callout=true)
    public static void deleteAccountsFromRemote(List<Id> externalIds) {
        String endPoint = 'callout:Second_Credentials/services/data/v49.0/composite/sobjects?ids=';

        for(String id: externalIds) {
            endPoint = endpoint + id + ',';
        }

        endPoint = endPoint.removeEnd(',');

        Http http = new Http();
        HttpRequest request = new HttpRequest();
        request.setEndpoint(endPoint);
        request.setMethod('DELETE');

        HTTPResponse response = http.send(request);
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

    private static List<Account> cloneAccounts(List<Account> accs) {
        List<Account> clonedList = new List<Account>();

        for(Account a: accs) {
            Account clonedAcc = a.clone(false, true, true, true);
            clonedAcc.Id = a.External_Id__c;
            clonedAcc.External_Id__c = a.Id;

            clonedList.add(clonedAcc);
        }

        return clonedList;
    }

    // private static void prepareAccounts(List<Account> accounts) {
    //     for (Account account : accounts) {
    //         Id localId = account.Id;

    //         account.Id = account.External_Id__c;
    //         account.External_Id__c = localId;
    //         account.Is_External__c = true;
    //     }
    // }
}