public with sharing class QDX_FormattedSummaryController {
    @AuraEnabled(cacheable=true)
    public static List<Map<String, String>> getData(String recordId, String queryString, String summaryFormat)
    {
        List<Map<String, String>> result = new List<Map<String, String>>();
        try {
            for (Sobject record : Database.query(queryString)) {
                QDX_CustomFormatter formatter = new QDX_CustomFormatter(record, 'record');
                Map<String, String> formattedStringMap = new Map<String, String>();
                formattedStringMap.put('Id', record.Id);
                formattedStringMap.put('value', formatter.format(summaryFormat).escapeHtml4());
                result.add(formattedStringMap);
            }
        } catch (Exception e) {
            throw new AuraHandledException(e.getMessage());
        }
        return result;
    }
}
