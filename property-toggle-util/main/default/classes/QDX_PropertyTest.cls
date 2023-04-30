@isTest
public with sharing class QDX_PropertyTest {
    @isTest static void itShouldReturnPropertyValue() {
        QDX_Property__mdt testProperty = new QDX_Property__mdt();
        testProperty.Label = 'TestProperty';
        testProperty.DeveloperName = 'TestProperty';
        testProperty.LongTextValue__c = 'Test value';
        testProperty.isDefault__c = true;

        QDX_Property.testProperty = testProperty;

        String myValue = QDX_Property.forLabel('TestProperty').value;
        Boolean isActive = QDX_Property.forLabel('TestProperty').isActive;
        Decimal myNumber = QDX_Property.forLabel('TestProperty').numberValue;

        System.assert(myValue == 'Test Value', 'No value found');
        System.assert(isActive == false, 'No boolean found');
        System.assert(myNumber == 0, 'No number found');
    }
}