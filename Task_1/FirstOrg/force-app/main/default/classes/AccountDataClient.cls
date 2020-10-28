public with sharing class AccountDataClient {
    public static HttpResponse sendAccountsData(List<Account> accs) {
        Http http = new Http();
        HttpRequest request = new HttpRequest();  
        request.setEndpoint('callout:First_Credentials/services/data/v50.0/sobjects/Account');  
        request.setMethod('POST');    
        request.setHeader('Content-Type', 'application/json;charset=UTF-8');

        request.setBody(JSON.serialize(accs[0])); 
        
        HttpResponse res = http.send(request);
    
        while (res.getStatusCode() == 302) {
            request.setEndpoint(res.getHeader('Location'));
            res = new Http().send(request);
        }
        return res;
    }
}