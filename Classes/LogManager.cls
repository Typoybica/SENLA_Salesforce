/**
 * Created by shake on 25.09.2022.
 */

public with sharing class LogManager {

    public static void deleteLogs (List<Id> ids){
        delete [SELECT Id FROM Log__c WHERE Id IN :ids];
    }

    public static List<Log__c> createLogs(Integer count, String name, String type, String message , Boolean push ){
        List<Log__c> newLogs = new List<Log__c>();

        for(Integer i=0;i<count;i++){
            Log__c addLog = new Log__c();
            addLog.Name = name;
            addLog.Type__c = type;
            addLog.Message__c = message;
            newLogs.add(addLog);
        }
        if(push) insert newLogs;
        return newLogs;
    }

    public static List<Log__c> readContact(List<Id> ids){
        List<Log__c> infoLogs = [SELECT Name,Type__c,Message__c FROM Log__c WHERE Id IN :ids];
        return infoLogs;
    }

    public static List<Log__c> updateContact(Integer count, String name, String type, String message , Boolean push){
         List<Log__c> updateLogs = new List<Log__c>();

        for(Integer i=0;i<count;i++){
            Log__c refreshLogs = new Log__c();
            refreshLogs.Name = name;
            refreshLogs.Type__c = type;
            refreshLogs.Message__c = message;
            updateLogs.add(refreshLogs);
        }
        if(push) update updateLogs;
        return updateLogs;
    }
}