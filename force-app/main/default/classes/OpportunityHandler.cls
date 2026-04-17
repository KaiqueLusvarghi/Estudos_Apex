public with sharing class OpportunityHandler {
    public static void HandlerBeforeInsert(List<Opportunity> opplist) { // O método é static, então pode ser chamado diretamente sem instanciar a classe
        for(Opportunity opp : opplist){ //
            if(opp.Amount != null && opp.Discount_Percentage__c != null){
                try {
                    Decimal precoCalculado = OpportunityService.calculateDiscount(opp.Amount, opp.Discount_Percentage__c); // Chama o método para calcular o preço final com desconto
                    opp.Final_Price__c = precoCalculado; // Atualiza o valor da oportunidade com o preço final após o desconto
                } catch (IllegalArgumentException e) {
                    opp.addError(e.getMessage());
                }
            }
        }
        
    }
    
    // O primeiro é LIST, o segundo é MAP
    public static void HandlerAfterUpdate(List<Opportunity> oppList, Map<Id, Opportunity> oldMap) {
        List<Opportunity> oppsToCreateTasks = new List<Opportunity>();
        
        for(Opportunity opp : oppList) { // oppList já é uma lista, NÃO precisa de .values()
            Opportunity oldOpp = oldMap.get(opp.Id);
            
            if(opp.StageName == 'Closed Won' && oldOpp.StageName != 'Closed Won'){
                oppsToCreateTasks.add(opp);
            }
        }
        
        if(!oppsToCreateTasks.isEmpty()){
            OpportunityService.creatFollowUpTask(oppsToCreateTasks);
        }
    }
}