/**
* QDX_QDX_Query
* 
* @incapsulate
*
* @description Base class for object queries.
* ===============================================================
* Date                Developer           Description
* -----------         ---------------     -----------------------
* 09-Apr-2021         Qamar Islam         Created
*/
public virtual with sharing class QDX_Query {
    public QDX_Query(){}

    private QDX_Query(String selectorClass)
    {
        this.selectorClass = selectorClass;
    }

    private QDX_Query(String selectorClass, String objectName)
    {
        this.selectorClass = selectorClass;
        this.objectName = objectName;
    }

    public static QDX_Query bySelector(String selectorClass)
    {
        return new QDX_Query(selectorClass);
    }

    public static QDX_Query bySelector(String selectorClass, String objectName)
    {
        return new QDX_Query(selectorClass, objectName);
    }

    public QDX_Query withSelect(String selectClause)
    {
        
        if (String.isBlank(this.selectClause))
        {
            this.selectClause = selectClause;
        }
        else 
        {
            this.selectClause += ', ' + selectClause;
        }

        return this;
    }

    public QDX_Query withDetails()
    {
        this.withDetails = true;
        return this;
    }

    public QDX_Query disableFls()
    {
        this.applyFls = false;
        return this;
    }

    public QDX_Query forId(Set<String> idSet)
    {
        this.idSet = idSet;

        if (String.isBlank(this.whereClause))
        {
            this.whereClause = ' Id IN :idSet';
        }
        else 
        {
            this.whereClause = ' AND Id IN :idSet';
        }

        return this;
    }

    public QDX_Query forWhere(String whereClause)
    {
        if (String.isBlank(this.whereClause))
        {
            this.whereClause = whereClause;
        }
        else 
        {
            this.whereClause += ' AND ' + whereClause;
        }

        return this;
    }

    public QDX_Query forRef(Set<String> reference)
    {
        if (this.ref1 == null) 
        {
            this.ref1 = reference;
            return this;
        }

        if (this.ref2 == null) 
        {
            this.ref2 = reference;
            return this;
        }

        if (this.ref3 == null) 
        {
            this.ref3 = reference;
            return this;
        }

        if (this.ref4 == null) 
        {
            this.ref4 = reference;
            return this;
        }

        if (this.ref5 == null) 
        {
            this.ref5 = reference;
            return this;
        }

        return this;
    }

    public QDX_Query orderBy(String orderByClause)
    {
        this.orderByClause = orderByClause;
        return this;
    }

    public QDX_Query limitBy(Integer limitClause)
    {
        this.limitClause = String.valueOf(limitClause);
        return this;
    }

    public SObject[] run()
    {
        return run(false);
    }

    public SObject[] run(Boolean doCache)
    {
        Type t = Type.forName(this.selectorClass);
        QDX_Query selector = (QDX_Query)t.newInstance();
        SObject[] result = new SObject[]{};

        Boolean isUsingCache = false;

        if (this.selectClause == null) { this.selectClause = selector.getFields(); }
        if (this.withDetails) { this.selectClause += selector.getSubSelects(); }
        if (this.objectName == null) { this.objectName = selector.getObjectName(); }
        if (this.whereClause == null) { this.whereClause = 'Id != null'; }
        if (this.orderByClause == null) { this.orderByClause = 'CreatedDate'; }
        if (this.limitClause == null) { this.limitClause = '50000'; }

        String queryString = String.format(
            'SELECT {0} FROM {1} WHERE {2} ORDER BY {3} LIMIT {4}',
            new Object[]
            {
                this.selectClause, 
                this.objectName,
                this.whereClause,
                this.orderByClause,
                this.limitClause
            }
        );
        String[] tempIdList = new List<String>(this.idSet);
        if (!tempIdList.isEmpty())
        {
            isUsingCache = true;
        }

        for (Integer i = 0; i < tempIdList.size(); i++)
        {
            SObject cachedRecord = QDX_QueryCache.retrieve(tempIdList[i]);
            if (cachedRecord == null) { continue; }
            result.add(cachedRecord);
            tempIdList.remove(i);
        }

        if (isUsingCache && tempIdList.isEmpty()) { return result; }

        Set<String> idSet = new Set<String>(tempIdList);
        Set<String> ref1 = this.ref1;
        Set<String> ref2 = this.ref2;
        Set<String> ref3 = this.ref3;
        Set<String> ref4 = this.ref4;
        Set<String> ref5 = this.ref5;

        for (SObject record : Database.query(queryString))
        {
            result.add(record);
        }

        if (result.isEmpty()) { return result; }

        if (doCache) { QDX_QueryCache.add(result); }

        if (this.applyFls)
        {
            SObjectAccessDecision decision = Security.stripInaccessible(
                AccessType.READABLE,
                result
            );
            return decision.getRecords();
        }
        
        return result;
    }

    private String selectorClass;
    private String objectName;
    private String selectClause;
    private String whereClause;
    private String orderByClause;
    private String limitClause;
    private Set<String> idSet;
    private Set<String> ref1;
    private Set<String> ref2;
    private Set<String> ref3;
    private Set<String> ref4;
    private Set<String> ref5;
    private Boolean withDetails = false;
    private Boolean applyFls = true;

    public virtual String getObjectName() 
    { 
        if (this.objectName != null) { return this.objectName; }
        return 'Account'; 
    }
    public virtual String getFields() { return 'Id'; }
    public virtual String getSubSelects() { return ''; }
}