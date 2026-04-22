public with sharing class LeadUpdateBatch  implements Database.Batchable<SObject> {
    public Database.QueryLocator start(Database.BatchableContext bc) {
        return Database.getQueryLocator([SELECT Id, Name, Status, CreatedDate, LastModifiedDate // Selecionando os Campos
                                        FROM Lead // Buscando os Leads
                                        WHERE IsConverted = false // Filtrando apenas os Leads que não foram convertidos
                                        AND LastModifiedDate <= :System.now().addDays(-5)]); // Filtrando os Leads que foram modificados pela última vez há mais de 5 dias
    }
    public void execute(Database.BatchableContext bc, List<Lead> scope) {
        List<Lead> leadsToUpDate = new List<Lead>();       
                
            for (Lead lead : (List<Lead>) scope) {
                lead.Description = '"Atenção: Registro pendente de follow-up há mais de 5 dias."'; // Atualizando a Descrição para "Follow-up Pendente"
                lead.Rating = 'Cold'; // Atualizando a Classificação para "Cold"
                leadsToUpDate.add(lead); // Adicionando o Lead atualizado à lista de Leads a serem atualizados
            }
            update leadsToUpDate; // Atualizando os Leads no banco de dados
        
    }

    public void finish(Database.BatchableContext bc) {
        System.debug('Batch Executada com Sucesso, Os Leads foram atualizados !.'); // Log para indicar que o batch foi concluído
    }
    
}