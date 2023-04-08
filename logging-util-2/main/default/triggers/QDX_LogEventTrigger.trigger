/*
* @author Qamar Islam (https://github.com/qislam)
*/
trigger QDX_LogEventTrigger on QDX_LogEvent__e (after insert) {
    QDX_LogEventTriggerHandler.handleAfterInsert(Trigger.new);
}