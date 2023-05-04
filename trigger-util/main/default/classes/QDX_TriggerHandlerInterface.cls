/*
* QDX_TriggerHandlerInterface
* @author Qamar Islam (https://github.com/qislam)
* @description This class is for managing trigger logic common to all triggers.
*/
public interface QDX_TriggerHandlerInterface {
    void handleBeforeInsert(sObject[] newRecords);
    void handleBeforeUpdate(sObject[] newRecords, Map<Id, sObject> oldMap);
    void handleAfterInsert(sObject[] newRecords);
    void handleAfterUpdate(sObject[] newRecords);
}