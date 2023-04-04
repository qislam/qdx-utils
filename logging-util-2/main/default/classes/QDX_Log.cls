/*
* QDX_Log
* @author Qamar Islam (https://github.com/qislam)
* @description This class is for replacing need to place QDX_Log.debug statements.
* To create persistent error log records implement the QDX_Log.IError interface and create a 
* metadata type record with the name of that class.
* @credit This is inspired by https://github.com/rsoesemann/apex-unified-logging
*/
public with sharing class QDX_Log {
	private static final String ORG_NAMESPACE = null; //[SELECT NamespacePrefix FROM Organization].NamespacePrefix;
    private static final String CLASSNAME = QDX_Log.class.getName();
	private static final Pattern STACK_LINE = Pattern.compile('^(?:Class\\.)?([^.]+)\\.?([^\\.\\:]+)?[\\.\\:]?([^\\.\\:]*): line (\\d+), column (\\d+)$');
	private static final String THIS_CONTEXT = timestamp();
    private static List<QDX_LogEvent__e> eventsToPublish;

    @TestVisible
    private static Boolean setupClassConfig = true;

	// PUBLIC
    //ERROR level
	public static void error(String message) {
		error(message, new List<Object>(), getContextId());
	}

	public static void error(String message, List<Object> values) {
		error(message, values, getContextId());
	}

    public static void error(Exception ex) {
        error(
            '{1}:{0}\n{2}',
            new List<Object>{ex.getMessage(), ex.getTypeName(), ex.getStackTraceString()},
            getContextId()
        );
    }

    public static void error(Object obj) {
        error('' + obj, new List<Object>(), getContextId());
    }

    public static void error(Object[] objList) {
        error('' + objList, new List<Object>(), getContextId());
    }

	public static void error(String message, List<Object> values, String contextId) {
		emit(message, values, contextId, LoggingLevel.ERROR);
	}

    // INFO level
    public static void info(String message) {
		info(message, new List<Object>(), getContextId());
	}

	public static void info(String message, List<Object> values) {
		info(message, values, getContextId());
	}

    public static void info(Object obj) {
        info('' + obj, new List<Object>(), getContextId());
    }

    public static void info(Object[] objList) {
        info('' + objList, new List<Object>(), getContextId());
    }

    public static void info(String message, List<Object> values, String contextId) {
		emit(message, values, contextId, LoggingLevel.INFO);
	}

    // DEBUG level
    public static void debug(String message) {
		debug(message, new List<Object>(), getContextId());
	}

	public static void debug(String message, List<Object> values) {
		debug(message, values, getContextId());
	}

    public static void debug(Object obj) {
        debug('' + obj, new List<Object>(), getContextId());
    }

    public static void debug(Object[] objList) {
        debug('' + objList, new List<Object>(), getContextId());
    }

    public static void debug(String message, List<Object> values, String contextId) {
		emit(message, values, contextId, LoggingLevel.DEBUG);
	}

    // Fine level
    public static void fine(String message) {
		fine(message, new List<Object>(), getContextId());
	}

	public static void fine(String message, List<Object> values) {
		fine(message, values, getContextId());
	}

    public static void fine(Object obj) {
        fine('' + obj, new List<Object>(), getContextId());
    }

    public static void fine(Object[] objList) {
        fine('' + objList, new List<Object>(), getContextId());
    }

    public static void fine(String message, List<Object> values, String contextId) {
		emit(message, values, contextId, LoggingLevel.FINE);
	}

    public static void limits() {
        emitLimits(getContextId());
    }

    public static void publish() {
        if (eventsToPublish == null) { eventsToPublish = new List<QDX_LogEvent__e>(); }
        limits();

        if (!eventsToPublish.isEmpty()) { EventBus.publish(eventsToPublish); }
        eventsToPublish.clear();
    }

    // PRIVATE
    private static String getContextId() {
        return Request.getCurrent().getRequestId();
    }

    private static void emitLimits(String contextId) {
        String message = '';
        message += String.format(
            '{0} SOQL statements out of {1}.\n', 
            new List<Object>{Limits.getQueries(), Limits.getLimitQueries()}
        );
        message += String.format(
            '{0} SOQL rows out of {1}.\n', 
            new List<Object>{Limits.getQueryRows(), Limits.getLimitQueryRows()}
        );
        message += String.format(
            '{0} DML statements out of {1}.\n', 
            new List<Object>{Limits.getDmlStatements(), Limits.getLimitDmlStatements()}
        );
        message += String.format(
            '{0} DML rows out of {1}.\n', 
            new List<Object>{Limits.getDmlRows(), Limits.getLimitDmlRows()}
        );
        message += String.format(
            '{0} Publish Immediately DML statements out of {1}.\n', 
            new List<Object>{Limits.getPublishImmediateDML(), Limits.getLimitPublishImmediateDML()}
        );
        message += String.format(
            '{0}ms CPU time out of {1}ms.\n', 
            new List<Object>{Limits.getCpuTime(), Limits.getLimitCpuTime()}
        );
        message += String.format(
            '{0} bytes Heap size out of {1} bytes.\n', 
            new List<Object>{Limits.getHeapSize(), Limits.getLimitHeapSize()}
        );
        message += String.format(
            'Timestamp: {0}\n', 
            new List<Object>{System.now()}
        );

        emit(message, new List<Object>(), contextId, LoggingLevel.INFO);
    }

    @TestVisible
	private static void emit(String message, List<Object> values, String contextId, LoggingLevel level) {
        String[] qdxLevels = new String[]{'ERROR', 'INFO', 'DEBUG', 'FINE'};

        String currentLoggingLevel = QDX_LogSetting__c.getInstance().Logging_Level__c;
        if (qdxLevels.indexOf(currentLoggingLevel) < qdxLevels.indexOf(level.name())) { return; }
        
		if (!values.isEmpty()) { message = String.format(message, cast(values)); }
        
        currentEvent = new QDX_LogEvent__e();
        currentEvent.QDX_User__c = UserInfo.getUserId();
        currentEvent.QDX_UserName__c = UserInfo.getUserName();
        currentEvent.QDX_Message__c = message;
        currentEvent.QDX_Level__c = level.name();
        currentEvent.QDX_Context__c = (contextId == null) ? THIS_CONTEXT : ''+ contextId;

        populateLocation(currentEvent);

        if (eventsToPublish == null) { eventsToPublish = new List<QDX_LogEvent__e>(); }
        eventsToPublish.add(currentEvent);

        if (currentEvent.QDX_Level__c == LoggingLevel.ERROR.name()) {
            publish();
        } 
	}

	private static List<String> cast(List<Object> values) {
		List<String> result = new List<String>();

		for(Object value : values) {
			result.add('' + value);
		}

		return result;
	}

	private static String timestamp() {
		return System.now().formatGmt('HH:mm:ss.SSS');
	}

	private static void populateLocation(QDX_LogEvent__e logEvent) {
		// Note: Idea taken from https://salesforce.stackexchange.com/questions/153835
		List<String> stacktrace = new DmlException().getStackTraceString().split('\n');

		for(String line : stacktrace) {
			Matcher matcher = STACK_LINE.matcher(line);

			if(matcher.find() && !line.startsWith('Class.' + CLASSNAME + '.')) {
				Boolean hasNamespace = String.isNotBlank(matcher.group(3));

				if(hasNamespace) {
					logEvent.QDX_Class__c = (matcher.group(1).equals(ORG_NAMESPACE)) ? matcher.group(2) : matcher.group(1) + '.' + matcher.group(2);
					logEvent.QDX_Method__c = prettyMethod(matcher.group(3));
				}
				else {
					logEvent.QDX_Class__c = matcher.group(1);
					logEvent.QDX_Method__c = prettyMethod(matcher.group(2));
				}

				logEvent.QDX_Line__c = Integer.valueOf(matcher.group(4));

				return;
			}
		}
	}

	private static String prettyMethod(String method) {
		String result = (method == null) ? 'anonymous' : method;
		return (result.contains('init')) ? 'ctor' : result;
	}

    @TestVisible
	private static QDX_LogEvent__e currentEvent = null;
}