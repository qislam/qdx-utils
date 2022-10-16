/*****************************************************************
Name:  CustomFormatter
Copyright © 2016  Incapsulate
============================================================
Purpose: To replace indices in String with values using pattern matching                                                              
============================================================
History                                                            
-------                                                            
VERSION  AUTHOR         DATE            DETAIL      Description
   1.0   Qamar Islam    March 29, 2022  Created     Replace indices in String with values
*****************************************************************/
public virtual class CustomFormatter {
    public Map<String, String> replacementsMap;

    public CustomFormatter() {
        this.replacementsMap = new Map<String, String>();
    }

    public CustomFormatter(Map<String, Object> replacements) {
        setReplacements(replacements, 'json');
    }

    public CustomFormatter(Map<String, Object> replacements, String prefix) {
        setReplacements(replacements, prefix);
    }

    public CustomFormatter(sObject sobjectParam) {
        setReplacements(sobjectParam, null);
    }

    public CustomFormatter(sObject sobjectParam, String objectNameParam) {
        setReplacements(sobjectParam, objectNameParam);
    }

    public CustomFormatter addReplacements(Map<String, String> replacements) {
        if (this.replacementsMap == null) { this.replacementsMap = new Map<String, String>(); }
        this.replacementsMap.putAll(replacements);
        return this;
    }

    public CustomFormatter addReplacements(sObject sobjectParam) {
        if (this.replacementsMap == null) { this.replacementsMap = new Map<String, String>(); }

        String objectName = String.valueOf(sobjectParam.getSObjectType());
        Map<String, Object> objectFieldsMap = sobjectParam.getPopulatedFieldsAsMap();

        for (String key : objectFieldsMap.keySet()) {
            this.replacementsMap.put(objectName + '.' + key, String.valueOf(objectFieldsMap.get(key)));
        }

        return this;
    }

    public String format(String template) {
        return format(template, true);
    }

    public String format(String template, Boolean normalizeSpace) {
        Pattern p = Pattern.compile('\\{[a-zA-Z0-9\\.]+\\}');
        Matcher m = p.matcher(template);
        
        while (m.find()) {
            template = template.replace(m.group(), getReplacementValue(m.group()));
        }

        if (normalizeSpace) {
            template = template.normalizeSpace();
        }

        template = template.replaceAll('(,\\s,)|(\\s,)', ',').replace(',,', ',');
        if (String.isBlank(template)) { return template; }
        while(template.charAt(template.length() - 1) == 44) 
        {
            template = template.removeEnd(',');
        }
        return template;
    }

    private void setReplacements(Map<String, Object> replacements, String prefix) {
        if (this.replacementsMap == null) { this.replacementsMap = new Map<String, String>(); }
        
        for (String key : replacements.keySet()) {
            if (replacements.get(key) instanceof Map<String, Object>) {
                setReplacements((Map<String, Object>)replacements.get(key), prefix + '.' + key);
            } else if (replacements.get(key) instanceof Object[]) {
                continue;
            } else {
                this.replacementsMap.put(prefix + '.' + key, String.valueOf(replacements.get(key)));
            }
        }
    }

    private void setReplacements(SObject sobjectParam, String objectNameParam) {
        if (this.replacementsMap == null) { this.replacementsMap = new Map<String, String>(); }

        String objectName = objectNameParam;
        if (String.isBlank(objectName)) {
            objectName = String.valueOf(sobjectParam.getSObjectType());
        }
       
        Map<String, Object> objectFieldsMap = sobjectParam.getPopulatedFieldsAsMap();
        this.replacementsMap = new Map<String, String>();

        for (String key : objectFieldsMap.keySet()) {
            this.replacementsMap.put(objectName + '.' + key, String.valueOf(objectFieldsMap.get(key)));
        }
    }

    private String getReplacementValue(String key) {
        key = key.replaceAll('\\{|\\}', '');
        if (this.replacementsMap.get(key) != null) {
            return this.replacementsMap.get(key);
        } else {
            return '';
        }
    }
}