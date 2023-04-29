/*
* @author Qamar Islam (https://github.com/qislam)
*/
global with sharing class QDX_LogArchiveBatch implements Database.Batchable<sObject> {

    global Database.QueryLocator start(Database.BatchableContext BC) {
        QDX_LogSetting__c settings = QDX_LogSetting__c.getOrgDefaults();
        Integer cutoffDays = (Integer)settings.Days_to_Expire__c;
        Datetime cutoffDate = System.today().addDays(0 - cutoffDays);
        String query = 'SELECT Id FROM QDX_Log__c WHERE CreatedDate < :cutoffDate';
        return Database.getQueryLocator(query);
    }

    global void execute(Database.BatchableContext BC, list<sObject> scope) {
        delete scope;
    }

    global void finish(Database.BatchableContext BC) {
        System.debug('Log Archive Batch Finished');
    }
}