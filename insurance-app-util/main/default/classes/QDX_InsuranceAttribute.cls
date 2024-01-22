public with sharing class QDX_InsuranceAttribute {
    public Id attributeId {get; set;}
    public String attributeName {get; set;}
    public String attributeType {get; set;}
    public String attributeValue {get; set;}
    public String attributeValueLabel {get; set;}
    public String attributeValueDataType {get; set;}
    public String[] attributeValueOptions {get; set;}

    public QDX_InsuranceAttribute[] dependentAttributes {get; set;}

    public QDX_InsuranceAttribute(Id attributeId) {
        this.attributeId = attributeId;
    }
}