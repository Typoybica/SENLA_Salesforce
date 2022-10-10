/**
 * Created by shake on 03.10.2022.
 */
@IsTest
public with sharing class TestPropertyManager {
    static final Id propertyOwner = Schema.SObjectType.Contact.getRecordTypeInfosByName().get('Property Owner').getRecordTypeId();
    static final Integer COUNTER = 3;

    @testSetup
    static void setup() {
        List<Contact> someContact = new List<Contact>{
                new Contact (LastName = 'A',
                        RecordTypeId = propertyOwner,
                        Phone = '+375338888888'),
                new Contact (LastName = 'B',
                        RecordTypeId = propertyOwner,
                        Phone = '+375295822053'),
                new Contact (LastName = 'test',
                        RecordTypeId = propertyOwner,
                        Phone = '+375332222222')
        };
        insert someContact;
        List<Property__c> someProperties = new List<Property__c>{
                new Property__c(
                        Address__c = 'Link',
                        Selling_Price__c = 13000,
                        Rental_price_per_month__c = 130,
                        Contact__c = someContact[0].Id
                ),
                new Property__c(
                        Address__c = 'Lenin',
                        Selling_Price__c = 15000,
                        Rental_price_per_month__c = 180,
                        Contact__c = someContact[1].Id
                ),
                new Property__c(
                        Address__c = 'Ali',
                        Selling_Price__c = 15000,
                        Rental_price_per_month__c = 190,
                        Contact__c = someContact[2].Id
                )
        };
        insert someProperties;

    }
    @isTest static void testInformationProperty() {

        List<Id> ids = new List<Id>();
        List<Property__c> properties = [SELECT Address__c,Selling_price__c,Rental_price_per_month__c,Contact__c FROM Property__c];
        for (Property__c pr : properties) {
            ids.add(pr.Id);
        }
        List<Property__c> readProperty = PropertyManager.readProperties(ids);
        System.assertEquals(properties, readProperty);

    }
    @isTest static void  testDeleteProperty(){
        List<Id> ids = new List<Id>();
        List<Property__c> properties = [SELECT Address__c,Selling_price__c,Rental_price_per_month__c,Contact__c FROM Property__c];
        for (Property__c pr : properties) {
            ids.add(pr.Id);
        }
        PropertyManager.deleteProperties(ids);
        List<Property__c> properties2 = [SELECT Address__c,Selling_price__c,Rental_price_per_month__c,Contact__c FROM Property__c];
        System.assertEquals(0,properties2.size());

    }
    @isTest static void testUpdatePropertyTrue(){
        List<Id> idsProperties = new List<Id>(new Map<Id, Property__c>([SELECT Id FROM Property__c]).keySet());

        List<Property__c> updateProperty = PropertyManager.updateProperties(idsProperties, 'Potato',
                600 , 800, true);
        List<Property__c> refreshProperty = [SELECT Id FROM Property__c WHERE Address__c = 'Potato'];
        System.assertEquals(3,updateProperty.size());
        System.assertEquals(3,refreshProperty.size());
    }
    @isTest static void testUpdatePropertyFalse(){
        List<Id> idsProperties = new List<Id>(new Map<Id, Property__c>([SELECT Id FROM Property__c]).keySet());

        List<Property__c> updateProperty = PropertyManager.updateProperties(idsProperties, 'Potato',
                600 , 800, false);
        List<Property__c> refreshProperty = [SELECT Id FROM Property__c WHERE Address__c = 'Potato'];
        System.assertEquals(3,updateProperty.size());
        System.assertEquals(0,refreshProperty.size());
    }
    @isTest static void testCreatePropertyFalse(){
        Contact owner = [SELECT Id FROM Contact LIMIT 1];
        List<Property__c> createProperty = PropertyManager.createProperties(COUNTER, 'Potato',
                600 , 800, owner.Id,false);
        List<Property__c> insertProperty = [SELECT Id FROM Property__c WHERE Address__c = 'Potato'];
        System.assertEquals(3,createProperty.size());
        System.assertEquals(0,insertProperty.size());
    }

    @isTest static void testCreatePropertyTrue(){
        Contact owner = [SELECT Id FROM Contact LIMIT 1];
        List<Property__c> createProperty = PropertyManager.createProperties(COUNTER, 'Potato',
                600 , 800, owner.Id, true);
        List<Property__c> insertProperty = [SELECT Id FROM Property__c WHERE Address__c = 'Potato'];
        System.assertEquals(3,createProperty.size());
        System.assertEquals(3,insertProperty.size());
    }
}
