/*
* @author Qamar Islam (https://github.com/qislam)
*/
public with sharing class QDX_LogEventTriggerHandler {
    public static void handleAfterInsert(List<QDX_LogEvent__e> logEvents) {
        QDX_Log__c[] logs = new QDX_Log__c[] {};
        String[] qdxLevels = new String[]{'ERROR', 'INFO', 'DEBUG', 'FINE'};
        QDX_LogSetting__c settings = QDX_LogSetting__c.getInstance(logEvents[0].QDX_User__c);
        Integer storageLevelIndex = qdxLevels.indexOf(settings.Storage_Level__c);

        for (QDX_LogEvent__e logEvent : logEvents) {
            Integer eventLevelIndex = qdxLevels.indexOf(logEvent.QDX_Level__c);
            if (eventLevelIndex > storageLevelIndex) { continue; }

            QDX_Log__c log = new QDX_Log__c();

            log.QDX_Context__c = logEvent.QDX_Context__c;
            log.QDX_Level__c = logEvent.QDX_Level__c;
            log.QDX_Message__c = logEvent.QDX_Message__c;
            log.QDX_Class__c = logEvent.QDX_Class__c;
            log.QDX_Method__c = logEvent.QDX_Method__c;
            log.QDX_Line__c = logEvent.QDX_Line__c;
            log.QDX_UserId__c = logEvent.QDX_User__c;
            log.QDX_UserName__c = logEvent.QDX_UserName__c;

            logs.add(log);
        }
        if (logs.isEmpty()) { return; } 
        insert logs;
    }
}