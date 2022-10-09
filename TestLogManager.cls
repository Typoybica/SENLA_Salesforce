/**
 * Created by shake on 03.10.2022.
 */
@IsTest
public with sharing class TestLogManager {
    @testSetup
    static void setup() {
        List<Log__c> someLogs = new List<Log__c>{
                new Log__c (
                        Message__c = 'Holla',
                        Type__c = 'DEFAULT',
                        Name = 'Lu'
                ),
                new Log__c (
                        Message__c = 'Idi',
                        Type__c = 'DEFAULT',
                        Name = 'Mu'
                ),
                new Log__c (
                        Message__c = 'Anon',
                        Type__c = 'DEFAULT',
                        Name = 'Ru'
                )
        };
        insert someLogs;

    }
    @isTest static void testInformationLogs() {

        List<Id> ids = new List<Id>();
        List<Log__c> logs = [SELECT Message__c, Type__c, Name FROM Log__c];
        for (Log__c lg : logs) {
            ids.add(lg.Id);
        }
        List<Log__c> readlLogs = LogManager.readLogs(ids);
        System.assertEquals(logs, readlLogs);
    }
    @isTest static void  testDeleteLogs(){
        List<Id> ids = new List<Id>();
        List<Log__c> logs = [SELECT Message__c, Type__c, Name FROM Log__c];
        for (Log__c lg : logs) {
            ids.add(lg.Id);
        }
        LogManager.deleteLogs(ids);
        List<Log__c> logs2 = [SELECT Message__c, Type__c, Name FROM Log__c];
        System.assertEquals(0,logs2.size());

    }
    @isTest static void testCreateLogsFalse(){
        List<Log__c> createLogs = LogManager.createLogs(2, 'L', 'DEFAULT', 'pivo', false);
        List<Log__c> insertLogs = [SELECT Id FROM Log__c WHERE Name = 'L'];
        System.assertEquals(2,createLogs.size());
        System.assertEquals(0,insertLogs.size());
    }
    @isTest static void testCreateLogsTrue(){
        List<Log__c> createLogs = LogManager.createLogs(2, 'L', 'DEFAULT', 'pivo', true);
        List<Log__c> insertLogs = [SELECT Id FROM Log__c WHERE Name = 'L'];
        System.assertEquals(2,createLogs.size());
        System.assertEquals(2,insertLogs.size());
    }
    @isTest static void testUpdateLogsTrue(){
        List<Id> idsLogs = new List<Id>(new Map<Id, Log__c>([SELECT Id FROM Log__c]).keySet());

        List<Log__c> updateLogs = LogManager.updateLogs(idsLogs, 'Colum', 'Re4ka', 'We were here', true);
        List<Log__c> refreshLogs = [SELECT Id FROM Log__c WHERE Name = 'Colum'];
        System.assertEquals(3,updateLogs.size());
        System.assertEquals(3,refreshLogs.size());
    }
    @isTest static void testUpdateLogsFalse(){
        List<Id> idsLogs = new List<Id>(new Map<Id, Log__c>([SELECT Id FROM Log__c]).keySet());

        List<Log__c> updateLogs = LogManager.updateLogs(idsLogs, 'Colum', 'Re4ka', 'We were here', false);
        List<Log__c> refreshLogs = [SELECT Id FROM Log__c WHERE Name = 'Colum'];
        System.assertEquals(3,updateLogs.size());
        System.assertEquals(0,refreshLogs.size());
    }

}
