/*
* QDX_QueryCache
* @author Qamar Islam (https://github.com/qislam)
* @description This class is for standardizing exceptions.
*/
public with sharing class QDX_QueryCache {

    public static void add(SObject record)
    {
        if (cache == null) cache = new Map<String, SObject>();
        cache.put(record.Id, record);
    }

    public static void add(SObject[] records)
    {
        if (cache == null) cache = new Map<String, SObject>();
        for (SObject record : records)
        {
            cache.put(record.Id, record);
        }
    }

    public static SObject retrieve(String recordId)
    {
        if (cache == null) return null;
        if (cache.get(recordId) == null) return null;
        return cache.get(recordId);
    }

    public static SObject[] retrieve(Set<String> recordIds)
    {
        if (cache == null) return null;
        SObject[] result = new SObject[]{};

        for (String recordId : recordIds)
        {
            if (cache.get(recordId) == null) continue;
            result.add(cache.get(recordId));
        }
        return result;
    }

    private static Map<String, SObject> cache;
    private QDX_QueryCache() {}
}