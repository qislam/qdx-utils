/*
* @author Qamar Islam (https://github.com/qislam)
* @description This class is for standard property.
*/
public with sharing class QDX_Property {
    public String value {
        get {
            if (this.value == null) {
                this.value = this.textValue;
            }
            return this.value;
        }
        private set;
    }

    public String textValue {
        get {
            if (this.textValue == null) {
                this.textValue = this.selectedProperty?.TextValue__c;
                if (String.isNotBlank(this.selectedProperty?.LongTextValue__c)) {
                    this.textValue = this.selectedProperty?.LongTextValue__c;
                }
                if (this.textValue == null) {
                    this.textValue = '';
                }
            }
            return this.textValue;
        }
        private set;
    }

    public Decimal numberValue {
        get {
            if (this.numberValue == null) {
                this.numberValue = this.selectedProperty?.NumberValue__c;
                if (this.numberValue == null) {
                    this.numberValue = 0;
                }
            }
            return this.numberValue;
        }
        private set;
    }

    public Boolean isActive {
        get {
            if (this.isActive == null) {
                this.isActive = this.selectedProperty?.isActive__c;
                if (this.isActive == null) {
                    this.isActive = false;
                }
            }
            return this.isActive;
        }
        private set;
    }

    public static QDX_Property forLabel(String propertyLabel) {
        return new QDX_Property(propertyLabel);
    }

    private QDX_Property__mdt selectedProperty;

    private QDX_Property(String propertyLabel) {
        System.Domain domainObj = DomainParser.parse(URL.getSalesforceBaseUrl().toExternalForm());
        String sandboxName = domainObj.getSandboxName();
        String instanceName = sandboxName == null ? 'PRODUCTION' : sandboxName.toUpperCase();

        QDX_Property__mdt[] properties = [
            SELECT DeveloperName
            , Label
            , TextValue__c
            , LongTextValue__c
            , NumberValue__c
            , isActive__c
            , isDefault__c
            , QDX_SF_Instance__c
            , QDX_SF_Instance__r.DeveloperName
            FROM QDX_Property__mdt
            WHERE Label = :propertyLabel
        ];

        for (QDX_Property__mdt current : properties) {
            if (current.QDX_SF_Instance__r.DeveloperName == instanceName) {
                selectedProperty = current;
                break;
            }
            if (current.isDefault__c) {
                selectedProperty = current;
            }
        }
    }
}