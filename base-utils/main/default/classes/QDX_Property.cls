public with sharing class QDX_Property {
    public String value {
        get {
            if (this.value == null) {
                if (this.selectedProperty == null) {
                    this.value = '';
                } else {
                    this.value = this.selectedProperty.Value__c;
                }
            }
            return this.value;
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
            , Value__c
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
