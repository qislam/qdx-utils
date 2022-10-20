/*
* QDX_CustomFormatter
* @author Qamar Islam (https://github.com/qislam)
* @description This class is for formatting strings using attribute names.
*/

public virtual class QDX_CustomFormatter {
    public Map<String, String> replacementsMap;

    public QDX_CustomFormatter() {
        this.replacementsMap = new Map<String, String>();
    }

    public QDX_CustomFormatter(String jsonString) {
        setReplacements(jsonString, 'json');
    }

    public QDX_CustomFormatter(String jsonString, String prefix) {
        setReplacements(jsonString, prefix);
    }

    public QDX_CustomFormatter(Map<String, Object> replacements) {
        setReplacements(replacements, 'json');
    }

    public QDX_CustomFormatter(Map<String, Object> replacements, String prefix) {
        setReplacements(replacements, prefix);
    }

    public QDX_CustomFormatter(sObject sobjectParam) {
        setReplacements(sobjectParam, null);
    }

    public QDX_CustomFormatter(sObject sobjectParam, String objectNameParam) {
        setReplacements(sobjectParam, objectNameParam);
    }

    public QDX_CustomFormatter addReplacements(String jsonString) {
        setReplacements(jsonString, 'json');
        return this;
    }

    public QDX_CustomFormatter addReplacements(String jsonString, String prefix) {
        setReplacements(jsonString, prefix);
        return this;
    }

    public QDX_CustomFormatter addReplacements(Map<String, String> replacements) {
        setReplacements(replacements, 'json');
        return this;
    }

    public QDX_CustomFormatter addReplacements(Map<String, String> replacements, String prefix) {
        setReplacements(replacements, prefix);
        return this;
    }

    public QDX_CustomFormatter addReplacements(sObject sobjectParam) {
        setReplacements(sobjectParam, null);
        return this;
    }

    public QDX_CustomFormatter addReplacements(sObject sobjectParam, String objectNameParam) {
        setReplacements(sobjectParam, objectNameParam);
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

    private void setReplacements(String jsonString, String prefix) {
        try {
            Map<String, Object> replacements = (Map<String, Object>)JSON.deserializeUntyped(jsonString);
            setReplacements(replacements, prefix);
        } catch(Exception ex) {
            if (this.replacementsMap == null) { this.replacementsMap = new Map<String, String>(); }
        }
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