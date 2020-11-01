trigger AccountTrigger on Account (after update) {
    TriggerDispatcher.execute(new AccounttriggerHandler());
}