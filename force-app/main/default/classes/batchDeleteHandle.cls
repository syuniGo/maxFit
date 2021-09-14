public with sharing class batchDeleteHandle implements Database.Batchable<sObject>, Database.Stateful {
    public Integer recordsProcessed = 0;

    public Database.QueryLocator start(Database.BatchableContext bc) {
        // collect the batches of records or objects to be passed to execute
        return Database.getQueryLocator(
            'select id from Event__c where End_Date_Time__c < LAST_N_MONTHS:2 and live__c = true'
        );
    }
    public void execute(Database.BatchableContext bc, List<Event__c> records) {
        // process each batch of records
        System.debug(records.size());
        if (!records.isEmpty()) {
            recordsProcessed = records.size();
            List<Database.DeleteResult> deleteResult = Database.delete(records);
            for (Database.DeleteResult dr : deleteResult) {
                if (!dr.isSuccess()) {
                    List<Database.Error> errors = dr.getErrors();
                    String errorInString = String.join(errors, ',');
                    ErrorHandle.doHandleExceptionWithError(
                        errorInString,
                        'DeleteEventBatch'
                    );
                }
            }
        }
    }
    public void finish(Database.BatchableContext bc) {
        // execute any post-processing operations
        System.debug(recordsProcessed + '个event过期并被删除');
        Messaging.SingleEmailMessage mail = new Messaging.SingleEmailMessage();
        String[] toAddresses = new List<String>{ 'diamondjsf@gmail.com' };
        mail.setToAddresses(toAddresses);
        mail.setSenderDisplayName('deleted batch auto response');
        mail.setSubject('batch delete event successful');
        mail.setHtmlBody(recordsProcessed + '个event过期并被删除');
        Messaging.sendEmail(new List<Messaging.Email>{ mail });
    }
}
