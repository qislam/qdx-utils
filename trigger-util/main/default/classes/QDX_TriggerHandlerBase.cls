public with sharing virtual class QDX_TriggerHandlerBase implements QDX_TriggerHandlerInterface{
    public virtual void handleBeforeInsert(sObject[] newRecords) {}
    public virtual void handleBeforeUpdate(sObject[] newRecords, Map<Id, sObject> oldMap) {}
    public virtual void handleAfterInsert(sObject[] newRecords) {}
    public virtual void handleAfterUpdate(sObject[] newRecords) {}
    public virtual void handleBeforeDelete(sObject[] oldRecords) {}
    public virtual void handleAfterDelete(sObject[] oldRecords) {}
    public virtual void handleAfterUndelete(sObject[] newRecords) {}
}