public class AccountTriggerHandler implements TriggerInterface{

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

    }

    public void beforeDelete(List<SObject> oldRecordsList){

    }

    public void beforeInsert(List<SObject> newRecordsList){}

    public void afterUpdate(List<SObject> newRecordsList, List<SObject> oldRecordsList){}

    public void afterDelete(List<SObject> oldRecordsList){}

    public void afterUnDelete(List<SObject> newRecordsList){}
    
}