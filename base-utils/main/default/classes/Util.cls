/**
* Util
* 
* @incapsulate
*
* @description Utility methods.
* ===============================================================
* Date                Developer           Description
* -----------         ---------------     -----------------------
* 10-Mar-2021         Qamar Islam         Created
*/
public with sharing class Util 
{
    public static String userProfileName
    {
        get 
        {
            if (UserProfileName == null)
            {
                UserProfileName = [SELECT Name FROM Profile WHERE Id = :UserInfo.getProfileId()].Name;
            }
            return UserProfileName;
        }
        set;
    }
    public static String userLicenseName
    {
        get 
        {
            if (UserLicenseName == null)
            {
                UserLicenseName = [SELECT Name,UserLicense.Name FROM Profile WHERE Id = :UserInfo.getProfileId()].UserLicense.Name;
            }
            return UserLicenseName;
        }
        set;
    }

    public static Map<String, Schema.SObjectType> globalDescribe 
    {
        get 
        {
            if (globalDescribe == null) { globalDescribe = Schema.getGlobalDescribe(); }
            return globalDescribe;
        }
        set;
    }

    public static ConnectApi.Community getCommunity(String name)
    {
        Network[] communityNetworks = [
            SELECT Id
            FROM Network
            WHERE Name = :name
        ];
        if (communityNetworks.isEmpty()) { throw new NoRecordFoundException('No community for name ' + name); }
        ConnectApi.Community result = ConnectApi.Communities.getCommunity(communityNetworks[0].Id);

        return result;
    }

    public static String getCommunityBaseUrl(String communityName)
    {
        ConnectApi.Community community = getCommunity(communityName);
        if (community == null) { return ''; }
        return community.siteUrl;
    }

    public static Map<String, Schema.SObjectType> getGlobalDescribe()
    {
        return globalDescribe;
    }

    public static Schema.DescribeSObjectResult getObjectDescribe(String objectName) 
    {
        return globalDescribe.get(objectName).getDescribe();
    }

    public static Schema.SObjectField getFieldDescribe(String objectName, String fieldName) 
    {
        return globalDescribe.get(objectName)
            .getDescribe()
            .fields
            .getMap()
            .get(fieldName);
    }

    public static Id getRecordTypeId(String objectName, String recordTypeName) 
    {
        return globalDescribe.get(objectName)
            .getDescribe()
            .getRecordTypeInfosByDeveloperName()
            .get(recordTypeName)
            .getRecordTypeId();
    }

    public static String getLoggedInUserLanguage()
    {
        if (UserInfo.getLanguage().startsWith('en')) { return 'en'; }
        return 'es';      
    }

    public static String getUUID() 
    {
        return '00Q' + Datetime.now().getTime() + EncodingUtil.convertToHex(Crypto.generateAesKey(128));
    }

    // To reverse any list in place
    public static void reverse(Object[] objList)
    {
        for (Integer i = 0; i < objList.size()-1; i++)
        {
            Object current = objList.remove(objList.size()-1);
            objList.add(i, current);
        }
    }

    // To randomize any list in-place
    public static void randomize(Object[] objList) {
        Integer randomIndex;
        Integer currentIndex = objList.size();
        while (currentIndex != 0) {
            randomIndex = integer.valueOf(Math.floor(Math.random() * currentIndex));
            currentIndex -= 1;
            Object o = objList[currentIndex];
            objList[currentIndex] = objList[randomIndex];
            objList[randomIndex] = o;
        }
    }

    // Custom Exceptions
    public class NullPointerException extends Exception {}
    public class NoRecordFoundException extends Exception {}

}