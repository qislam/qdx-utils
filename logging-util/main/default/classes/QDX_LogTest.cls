@isTest
public with sharing class QDX_LogTest {
    @TestSetup
    static void makeData(){
        QDX_LogSetting__c settings = new QDX_LogSetting__c();
        settings.Name = 'TestSettings';
        settings.Logging_Level__c = 'FINE';

        insert settings;
    }

    @IsTest
	private static void debug() {
		String contextId = 'a2R1T0000034dUTUAY';
		String message = '{0}=={1}:{2}';
		List<Object> values = new List<Object>{ 1, '2', false };

		// Execute
		QDX_Log.debug(message, values, contextId);
        QDX_LogEvent__e log = QDX_Log.currentEvent;
        
        QDX_Log.publish();

		System.assertEquals('1==2:false', log.QDX_Message__c);
		System.assertEquals(LoggingLevel.DEBUG.name(), log.QDX_Level__c);
		System.assertEquals(contextId, log.QDX_Context__c);
		System.assertEquals(thisClassName(), log.QDX_Class__c);
		System.assertEquals('debug', log.QDX_Method__c);
	}

    @IsTest
	private static void debugNoConfig() {
		String contextId = 'a2R1T0000034dUTUAY';
		String message = '{0}=={1}:{2}';
		List<Object> values = new List<Object>{ 1, '2', false };

		// Execute
		QDX_Log.debug(message, values, contextId);
        QDX_LogEvent__e log = QDX_Log.currentEvent;
        
        QDX_Log.publish();

		System.assertEquals('1==2:false', log.QDX_Message__c);
	}

    @isTest
    private static void testDebugOverloading() {
        String contextId = 'a2R1T0000034dUTUAY';
        String message = '{0}=={1}:{2}';
		List<Object> values = new List<Object>{ 1, '2', false };

        QDX_Log.debug(message);
        System.assertEquals(message, QDX_Log.currentEvent.QDX_Message__c);

        QDX_Log.debug(7);
        System.assertEquals('7', QDX_Log.currentEvent.QDX_Message__c);

        QDX_Log.debug(new Integer[]{1, 2, 3});
        System.assertEquals('(1, 2, 3)', QDX_Log.currentEvent.QDX_Message__c);

        QDX_Log.debug(message, values);
        System.assertEquals('1==2:false', QDX_Log.currentEvent.QDX_Message__c);
    }

    @isTest
    private static void testErrorOverloading() {
        String contextId = 'a2R1T0000034dUTUAY';
        String message = '{0}=={1}:{2}';
		List<Object> values = new List<Object>{ 1, '2', false };

        QDX_Log.error(message);
        System.assertEquals(message, QDX_Log.currentEvent.QDX_Message__c);

        QDX_Log.error(7);
        System.assertEquals('7', QDX_Log.currentEvent.QDX_Message__c);

        QDX_Log.error(new Integer[]{1, 2, 3});
        System.assertEquals('(1, 2, 3)', QDX_Log.currentEvent.QDX_Message__c);

        QDX_Log.error(message, values);
        System.assertEquals('1==2:false', QDX_Log.currentEvent.QDX_Message__c);
    }

    @isTest
    private static void errorExceptionTest() {
        try {
            Integer i = 2 / 0;
        } catch(Exception ex) {
            QDX_Log.error(ex);
            System.assertNotEquals(null, QDX_Log.currentEvent.QDX_Message__c);
        }
    }

    @isTest
    private static void limitsTest() {
        String contextId = 'a2R1T0000034dUTUAY';

        QDX_Log.limits();
        System.assertEquals(true, QDX_Log.currentEvent.QDX_Message__c.contains('SOQL statements out of'));

        QDX_Log.limits(contextId);
        System.assertEquals(true, QDX_Log.currentEvent.QDX_Message__c.contains('SOQL statements out of'));
        System.assertEquals(contextId, QDX_Log.currentEvent.QDX_Context__c);
    }

	@IsTest
	private static void timestampWhenNoContextId() {
		// Execute
		QDX_Log.debug('');

		// Verify
		System.assertNotEquals(null, QDX_Log.currentEvent.QDX_Context__c);
	}

	// HELPER
	private static String thisClassName() {
		String ns = [SELECT NamespacePrefix FROM Organization].NamespacePrefix + '.';
		return QDX_LogTest.class.getName().removeStart(ns);
	}
}