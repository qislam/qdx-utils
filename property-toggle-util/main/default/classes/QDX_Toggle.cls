/*
* @author Qamar Islam (https://github.com/qislam)
* @description This class is for setting up toggle based on property.
*/

public with sharing class QDX_Toggle {
    @AuraEnabled
    public static Boolean isActive(String featureLabel) {
        return QDX_Property.forLabel(featureLabel).isActive;
    }

    @InvocableMethod(label='getFeatureToggle')
    public static Boolean[] isActive(String[] options) {
        if (options.isEmpty()) { return new Boolean[]{ false }; }
        return new Boolean[]{ isActive(options[0]) };
    }
}