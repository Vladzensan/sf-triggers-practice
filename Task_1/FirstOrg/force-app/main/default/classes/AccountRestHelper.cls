public with sharing class AccountRestHelper {
    public static List<Account> getAccountsByIds(List<Id> accIds) {
        return [SELECT Name, AccountNumber, Phone, BillingStreet, 
            BillingCity, BillingCountry, BillingState, 
            BillingPostalCode, BillingLatitude, BillingLongitude, 
            ShippingStreet, ShippingCity, ShippingCountry, 
            ShippingState, ShippingPostalCode, ShippingLatitude, 
            ShippingLongitude, External_Id__c
            FROM Account WHERE Id = :accIds];
    }

    public static List<Account> cloneAccounts(List<Account> accs) {
        List<Account> clonedList = new List<Account>();

        for(Account a: accs) {
            Account clonedAcc = a.clone(false, true, true, true);
            clonedAcc.Id = a.External_Id__c;
            clonedAcc.External_Id__c = a.Id;

            clonedList.add(clonedAcc);
        }

        return clonedList;
    }
}
