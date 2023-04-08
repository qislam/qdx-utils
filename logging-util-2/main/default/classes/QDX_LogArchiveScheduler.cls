/*
* @author Qamar Islam (https://github.com/qislam)
*/
global with sharing class QDX_LogArchiveScheduler implements Schedulable {
    global void execute(SchedulableContext sc) {
        QDX_LogArchiveBatch batchable = new QDX_LogArchiveBatch();
        Database.executeBatch(batchable);
    }
}