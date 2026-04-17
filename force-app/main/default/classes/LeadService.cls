public class LeadService {
    
    public static Decimal ValorTotalVenda(Decimal QtdVeiculo, Decimal PrecoVeiculo){
        if(QtdVeiculo == null || PrecoVeiculo == null){
            throw new IllegalArgumentException('Não pode ser nulo os valores');
        }
        else if (QtdVeiculo <= 0){
            throw new IllegalArgumentException('por favor informe um valor positivo');
        }
        else if(QtdVeiculo > 20){
            throw new IllegalArgumentException('vendas acima de 20 veículos é necessário falar com o Diretor Comercial ');
        }
        
        
        Decimal ValorFinal = QtdVeiculo * PrecoVeiculo;
        return ValorFinal;
        
    }
    
    public static void CreatTask(List<Lead> leadList){
        List<Task> TaskToInsert = new List<Task>();
        
        for(Lead ld : leadList){
            if(ld.Status =='Closed - Converted'){
                Task newTask = new Task();
                newTask.Subject= 'Obrigado por fechar a a Lead!' ;
                newTask.WhoId = ld.Id;
                newTask.Priority = 'High';
                newTask.Description = 'Entre em contato com o Lead para fechar mais negocios';
                newTask.Status = 'Not Started';
                newTask.ActivityDate = Date.Today();
                
                TaskToInsert.add(newTask);
            }
        }
        
        if(!TaskToInsert.isEmpty()){
            insert TaskToInsert;
        }
        
    }

}