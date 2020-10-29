public class AccountTriggerHandler implements TriggerInterface {
    private static final List<String> fieldsToCompare = new String[]{
        'Name', 'AccountNumber', 'Phone', 'BillingStreet',
        'BillingCity', 'BillingCountry', 'BillingState', 'BillingPostalCode',
        'BillingLatitude', 'BillingLongitude'
    };

    public void afterInsert(List<SObject> newRecordsList){
        List<Id> accsToSync = new List<Id>();

        for(Account a: (List<Account>) newRecordsList) {
            if(a.External_Id__c == null) {
                accsToSync.add(a.Id);
            }
        }

        if(!accsToSync.isEmpty()) {
            AccountRestClient.insertAccountsToRemote(accsToSync);
        }
    }
    
    public void beforeUpdate(List<SObject> newRecordsList, List<SObject> oldRecordsList){
        Map<Id, Account> newMap = new Map<Id, Account>((List<Account>) newRecordsList);
        Map<Id, Account> oldMap = new Map<Id, Account>((List<Account>) oldRecordsList);
        List<Id> accsForRemoteUpdate = new List<Id>();

        for(Account newAcc: (List<Account>)newRecordsList) {
            Account oldAcc = oldMap.get(newAcc.Id);
            Boolean isToUpdate = false;

            if(!newAcc.Is_External__c) {
                for(String field : fieldsToCompare) {
                    if((String) newAcc.get(field) != (String) oldAcc.get(field)) {
                        accsForRemoteUpdate.add(newAcc.Id);
                        break;
                    }
                }
            } else {
                newAcc.Is_External__c = false; // since accounts are provided from Trigger.new in before action -> it will be committed to DB
            }
        }

        if(!accsForRemoteUpdate.isEmpty()) {
            AccountRestClient.updateAccountsInRemote(accsForRemoteUpdate);
        }
    }

    public void beforeDelete(List<SObject> oldRecordsList){
        
    }

    public void beforeInsert(List<SObject> newRecordsList){}

    public void afterUpdate(List<SObject> newRecordsList, List<SObject> oldRecordsList){}

    public void afterDelete(List<SObject> oldRecordsList){}

    public void afterUnDelete(List<SObject> newRecordsList){}
    
}