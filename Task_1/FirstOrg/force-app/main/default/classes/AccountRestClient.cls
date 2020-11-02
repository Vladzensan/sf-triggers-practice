public with sharing class AccountRestClient {

    public static void insertAccountsToRemote(List<Id> accsToInsert) {
        ID jobID = System.enqueueJob(new AccountsInsertJob(accsToInsert));
    }

    public static void updateAccountsInRemote(List<Id> accsToUpdate) {    
        ID jobID = System.enqueueJob(new AccountsUpdateJob(accsToUpdate));
    }

    public static void deleteAccountsFromRemote(List<Id> externalIds) {
        ID jobID = System.enqueueJob(new AccountsDeleteJob(externalIds));
    }
}