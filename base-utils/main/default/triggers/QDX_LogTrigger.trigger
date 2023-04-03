trigger QDX_LogTrigger on QDX_Log__e (after insert) {
    List<QDX_Log2__c> logRecords = new List<QDX_Log2__c>(); 
    for (QDX_Log__e log : Trigger.new) {
        logRecords.add(new QDX_Log2__c(
            QDX_Class__c = log.QDX_Class__c,
            QDX_Method__c = log.QDX_Method__c,
            QDX_Message__c = log.QDX_Message__c,
            QDX_Level__c = log.QDX_Level__c,
            QDX_Line__c = log.QDX_Line__c,
            QDX_User__c = log.QDX_User__c,
            QDX_UserName__c = log.QDX_UserName__c,
            QDX_Context__c = log.QDX_Context__c
        ));
    }
    insert logRecords;
}