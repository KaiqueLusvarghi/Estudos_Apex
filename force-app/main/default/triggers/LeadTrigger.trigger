trigger LeadTrigger on Lead (before insert, before update, after update) {
    if(Trigger.isBefore){
        LeadHandler.HandlerCalculations(Trigger.new);
    }
    
    if(Trigger.isAfter && Trigger.isUpdate){
        LeadHandler.HandlerNewTask(Trigger.new, Trigger.oldMap);
    }

}