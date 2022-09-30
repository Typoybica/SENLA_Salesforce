trigger DealTrigger on Deal__c (before insert) {

    DealTriggerHandler updateTrigger = new DealTriggerHandler();

    if(Trigger.isUpdate && Trigger.isAfter){
        updateTrigger.afterUpdate(Trigger.new);
    }

}