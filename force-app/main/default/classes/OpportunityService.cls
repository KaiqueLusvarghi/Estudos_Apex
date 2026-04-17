public class OpportunityService {
    public static Decimal calculateDiscount(Decimal totalAmount, Decimal discountPercent){
        if(totalAmount == null || discountPercent == null){
            throw new IllegalArgumentException('Não pode haver valores nulos para totalAmount ou discountPercent.  ');
        }
        else if(discountPercent > 50){
            throw new IllegalArgumentException('Desconto acima de 50% não é permitido.');
        } else if(discountPercent < 0){
            throw new IllegalArgumentException('Desconto não pode ser negativo.');
        } 

        Decimal valorDesconto = totalAmount * (discountPercent / 100);
        return totalAmount - valorDesconto;
    }

    public static void creatFollowUpTask(List<Opportunity> opplist){ // Método para criar tarefas de follow-up para oportunidades que foram fechadas como 'Closed Won'
        List<Task> tasksToInsert = new List<Task>(); // Lista para armazenar as tarefas de follow-up a serem inseridas

        for(Opportunity opp : opplist){ // Loop para iterar sobre cada oportunidade na lista de oportunidades
            if(opp.StageName == 'Closed Won'){ // Verifica se a oportunidade está no estágio 'Closed Won'
                Task followUpTask = new Task(); // Cria uma nova tarefa de follow-up
                followUpTask.Subject = 'Obrigado por fechar a oportunidade!'; // Define o assunto da tarefa
                followUpTask.WhatId = opp.Id; // Associa a tarefa à oportunidade usando o campo WhatId
                followUpTask.Status = 'Not Started';
                followUpTask.Description = 'Entre em contato com o cliente para agradecer e discutir os próximos passos.'; // Define a descrição da tarefa
                followUpTask.Priority = 'Normal';

                tasksToInsert.add(followUpTask); // Adiciona a tarefa à lista de tarefas a serem inseridas
            }
        }

        if(!tasksToInsert.isEmpty()){ // Verifica se há tarefas para inserir antes de realizar a operação DML
            insert tasksToInsert; // Insere as tarefas de follow-up no banco de dados
        }
    }

}