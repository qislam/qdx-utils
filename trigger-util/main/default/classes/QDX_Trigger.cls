/*
* QDX_Trigger
* @author Qamar Islam (https://github.com/qislam)
* @description This class is for managing trigger logic common to all triggers.
*/
public with sharing class QDX_Trigger {
    public static void run(String sobjectName) {
        String propertyLabel = sobjectName + 'TriggerHandler';

        QDX_Property triggerProperty = QDX_Property.forLabel(propertyLabel);
        String handlerSettingsJson = triggerProperty.value;

        if (triggerProperty.isFound && !triggerProperty.isActive) { return; }

        Map<String, Object> settingsMap;
        String handlerClassName = propertyLabel;
        QDX_TriggerHandlerInterface handler;

        if (String.isNotBlank(handlerSettingsJson)) {
            settingsMap = (Map<String, Object>)JSON.deserializeUntyped(handlerSettingsJson);
            QDX_Log.fine('SettingsMap:\n' + settingsMap);

            String classNameProperty = (String)settingsMap.get('className');
            if (String.isNotBlank(classNameProperty)) {
                handlerClassName = classNameProperty;
            }
        }

        try {
            handler = (QDX_TriggerHandlerInterface)Type.forName(handlerClassName)?.newInstance();
        } catch(Exception ex) {
            QDX_Log.error(ex);
        }

        if (handler == null) { return; }

        switch on Trigger.operationType {
            when BEFORE_INSERT {
                Boolean skipBeforeInsert = false;
                if (settingsMap?.get('skipBeforeInsert') != null) {
                    skipBeforeInsert = (Boolean)settingsMap.get('skipBeforeInsert');
                }
                
                if (!skipBeforeInsert) {
                    handler.handleBeforeInsert(Trigger.new);
                }
            }
            when BEFORE_UPDATE {
                Boolean skipBeforeUpdate = false;
                if (settingsMap?.get('skipBeforeUpdate') != null) {
                    skipBeforeUpdate = (Boolean)settingsMap.get('skipBeforeUpdate');
                }
                
                if (!skipBeforeUpdate) {
                    handler.handleBeforeUpdate(Trigger.new, Trigger.oldMap);
                }
            }
            when BEFORE_DELETE {
                Boolean skipBeforeDelete = false;
                if (settingsMap?.get('skipBeforeDelete') != null) {
                    skipBeforeDelete = (Boolean)settingsMap.get('skipBeforeDelete');
                }

                if (!skipBeforeDelete) {
                    handler.handleBeforeDelete(Trigger.old);
                }
            }
            when AFTER_INSERT {
                Boolean skipAfterInsert = false;
                if (settingsMap?.get('skipAfterInsert') != null) {
                    skipAfterInsert = (Boolean)settingsMap.get('skipAfterInsert');
                }
                
                if (!skipAfterInsert) {
                    handler.handleAfterInsert(Trigger.new);
                }
            }
            when AFTER_UPDATE {
                Boolean skipAfterUpdate = false;
                if (settingsMap?.get('skipAfterUpdate') != null) {
                    skipAfterUpdate = (Boolean)settingsMap.get('skipAfterUpdate');
                }
                
                if (!skipAfterUpdate) {
                    handler.handleAfterUpdate(Trigger.new);
                }
            }
            when AFTER_DELETE {
                Boolean skipAfterDelete = false;
                if (settingsMap?.get('skipAfterDelete') != null) {
                    skipAfterDelete = (Boolean)settingsMap.get('skipAfterDelete');
                }

                if (!skipAfterDelete) {
                    handler.handleAfterDelete(Trigger.old);
                }
            }
            when AFTER_UNDELETE {
                //prevent undeletion of sensitive data
                Boolean skipAfterUndelete = false;
                if (settingsMap?.get('skipAfterUndelete') != null) {
                    skipAfterUndelete = (Boolean)settingsMap.get('skipAfterUndelete');
                }

                if (!skipAfterUndelete) {
                    handler.handleAfterUndelete(Trigger.new);
                }
            }
        }

        QDX_Log.publish();
    }
}