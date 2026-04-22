public with sharing class LeadSchedulable  implements Schedulable {
    public void execute(SchedulableContext sc) {

        LeadUpdateBatch batch = new LeadUpdateBatch(); // Criando uma instância do Batch
        Database.executeBatch(batch); // Executando o Batch


    }
}
//Executar esse codigo no Anonymous Apex para agendar a execução do LeadSchedulable, que por sua vez executará o LeadUpdateBatch diariamente.

// 1. Nome do agendamento

//String jobName = 'Atualização Diária de Leads ';

// 2. Expressão Cron (Segundos Minutos Horas Dia_do_Mês Mês Dia_da_Semana)
// '0 0 0 * * ?' significa: 0 segundos, 0 minutos, 0 horas (meia-noite), todos os dias

//String cronExp = '0 0 0 * * ?';

// 3. Instância da sua classe Schedulable

//LeadSchedulable scheduler = new LeadSchedulable();

// 4. O comando que liga tudo no Salesforce

//System.schedule(jobName, cronExp, scheduler);