public class AccountTriggerHandler implements TriggerInterface {

    public void afterUpdate(List<SObject> newRecordsList, List<SObject> oldRecordsList){
        List<Id> accIds = new List<Id>();

        for(Account newAcc: (List<Account>)newRecordsList) {
            if(newAcc.Generate_Pdf__c) {
                accIds.add(newAcc.Id);
            }
        } 

        if(!accIds.isEmpty()) {
            AccountPdfGenerator.generatePdfs(accIds);
        }
    }

    public void afterInsert(List<SObject> newRecordsList){}
    
    public void beforeUpdate(List<SObject> newRecordsList, List<SObject> oldRecordsList){}

    public void beforeInsert(List<SObject> newRecordsList){}

    public void beforeDelete(List<SObject> oldRecordsList){}

    public void afterDelete(List<SObject> oldRecordsList){}

    public void afterUnDelete(List<SObject> newRecordsList){}
    
}