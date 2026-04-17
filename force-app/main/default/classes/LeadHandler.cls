public class LeadHandler {
    
    public static void HandlerCalculations(List<Lead> leadList){
        for(Lead ld : leadList){
            if(ld.Preco_do_Veiculo__c != null && ld.Quantidade_de_Veiculos__c != null){
                try{
                    Decimal precoFinal = LeadService.ValorTotalVenda(ld.Quantidade_de_Veiculos__c, ld.Preco_do_Veiculo__c);
                    ld.Valor_Total__c = precoFinal;
                    
                }catch(IllegalArgumentException e){
                 ld.addError(e.getMessage());   
                }
            }
        }
    }
    
    public static void HandlerNewTask(List<Lead> leadList, Map<Id, Lead> oldMap){
        List<Lead> LeadCreatTask = new List<Lead>(); 
        for(Lead ld : leadList){
            Lead oldLead = oldMap.get(ld.Id);
            
            if(ld.Status == 'Closed - Converted' && oldLead.Status != 'Closed - Converted'){
                LeadCreatTask.add(ld);
            }
            
        }
        
        if(!LeadCreatTask.isEmpty()){
            LeadService.CreatTask(LeadCreatTask);
        }
    }

}