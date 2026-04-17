trigger OpportunityTrigger on Opportunity (before insert, before update, after update) {
    
    if (Trigger.isBefore) { // before insert and before update
        OpportunityHandler.HandlerBeforeInsert(Trigger.new); 
    }

    if(Trigger.isAfter && Trigger.isUpdate) { // after update 
        OpportunityHandler.HandlerAfterUpdate(Trigger.new, Trigger.oldMap);
    }
    
}