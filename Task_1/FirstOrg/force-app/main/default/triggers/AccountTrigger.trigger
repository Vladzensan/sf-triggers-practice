trigger AccountTrigger on Account (after insert, after update, before delete) {
    TriggerDispatcher.execute(new AccountTriggerHandler());
}