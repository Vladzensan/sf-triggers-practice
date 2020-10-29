public with sharing class SObjectsRequestWrapper {
    public boolean allOrNone;
    public List<SObject> records;

    public SObjectsRequestWrapper(List<SObject> records, boolean allOrNone) {
        this.allOrNone = allOrNone;
        this.records = records;
    }
}
