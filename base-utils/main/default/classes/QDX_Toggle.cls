/*
* @author Qamar Islam (https://github.com/qislam)
* @description This class is for setting up toggle based on property.
*/

public with sharing class QDX_Toggle {
    @AuraEnabled
    public static Boolean isActive(String featureLabel) {

        Boolean result = false;
        if (QDX_Property.forLabel(featureLabel)?.value.toUpperCase() == 'TRUE') {
            result = true;
        }

        return result;
    }

    @InvocableMethod(label='getFeatureToggle')
    public static Boolean[] isActive(String[] options) {
        if (options.isEmpty()) { return new Boolean[]{ false }; }
        return new Boolean[]{ isActive(options[0]) };
    }
}