/*
* QDX_CustomException
* @author Qamar Islam (https://github.com/qislam)
* @description This class is for standardizing exceptions.
*/
public with sharing class QDX_CustomException extends Exception{

    public enum ErrorCode {
        ERROR_PROCESSING,
        PROPERTY_NOT_FOUND,
        MISSING_PARAMETER,
        UNEXPECTED_VALUE
    }
    
    public QDX_CustomException(ErrorCode errorCodeParam) {
        this(errorCodeParam, '');
    }

    public QDX_CustomException(ErrorCode errorCodeParam, String message) {
        this.currentError = errorCodeParam;

        if (message == null) { message = '';}
        switch on errorCodeParam {
            when ERROR_PROCESSING {
                message = 'Could not process the request. ' + message;
            } when PROPERTY_NOT_FOUND {
                message = 'No Property record found matching provided label. ' + message;
            } when MISSING_PARAMETER {
                message = 'One or more of required parameters are missing. ' + message;
            } when UNEXPECTED_VALUE {
                message = 'Value provided is not as expected. ' + message;
            }
        }
        this.setMessage(getErrorCode() + ': ' + message);
    }

    public String getErrorCode() {
        return this.currentError.name();
    }

    private ErrorCode currentError;
}