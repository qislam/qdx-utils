public with sharing class QDX_FormattedSummaryController {
    @AuraEnabled(cacheable=true)
    public static List<Map<String, String>> getData(String recordId, String propertyLabel) {
        List<Map<String, String>> result = new List<Map<String, String>>();
        if (String.isBlank(recordId)) { return result; }
        if (String.isBlank(propertyLabel)) { return result; }

        String cardPropertyValue = QDX_Property.forLabel(propertyLabel).value;
        String queryString;
        String summaryFormat;

        if (String.isNotBlank(cardPropertyValue)) {
            Map<String, Object> parsedSetting = (Map<String, Object>)JSON.deserializeUntyped(cardPropertyValue);
            queryString = (String)parsedSetting.get('queryString');
            summaryFormat = (String)parsedSetting.get('summaryFormat');
        }

        if (String.isBlank(queryString)) { return result; }
        if (String.isBlank(summaryFormat)) { return result; }

        try {
            for (Sobject record : Database.query(queryString)) {
                QDX_CustomFormatter formatter = new QDX_CustomFormatter(record, 'record');
                Map<String, String> formattedStringMap = new Map<String, String>();
                formattedStringMap.put('Id', record.Id);
                formattedStringMap.put('value', formatter.format(summaryFormat));
                result.add(formattedStringMap);
            }
        } catch (Exception e) {
            throw new AuraHandledException(e.getMessage());
        }
        return result;
    }
}
