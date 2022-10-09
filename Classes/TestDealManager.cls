/**
 * Created by shake on 03.10.2022.
 */
@IsTest
public with sharing class TestDealManager {
    static final Id lease = Schema.SObjectType.Deal__c.getRecordTypeInfosByName().get('Lease').getRecordTypeId();
    static final Id sale = Schema.SObjectType.Deal__c.getRecordTypeInfosByName().get('Sale').getRecordTypeId();
    static final Id broker = Schema.SObjectType.Contact.getRecordTypeInfosByName().get('Broker').getRecordTypeId();
    static final Id propertyOwner = Schema.SObjectType.Contact.getRecordTypeInfosByName().get('Property Owner').getRecordTypeId();
    static final Integer COUNTER = 2;

    @testSetup
    static void setup() {
        List<Contact> someContact = new List<Contact>{
                new Contact(FirstName = 'L',
                        LastName = 'Lulu',
                        Phone = '+375296666666',
                        HomePhone = '666298',
                        Email = 'lulu@gmail.com',
                        RecordTypeId = broker),

                new Contact(FirstName = 'M',
                        LastName = 'MuMu',
                        Phone = '+375296766666',
                        HomePhone = '666798',
                        Email = 'mumu@gmail.com',
                        RecordTypeId = propertyOwner),

                new Contact(FirstName = 'R',
                        LastName = 'Ruru',
                        Phone = '+375296754321',
                        HomePhone = '666798',
                        Email = 'ruru@gmail.com',
                        RecordTypeId = propertyOwner)

        };
        insert someContact;

        Property__c property = new Property__c(
                Address__c = 'Link',
                Selling_Price__c = 13000,
                Rental_price_per_month__c = 130,
                Contact__c = someContact[1].Id
        );

        insert property;
        List<Deal__c> someDeals = new List<Deal__c>{
                new Deal__c(
                        Broker__c = someContact[0].Id,
                        Buyer__c = someContact[2].Id,
                        Seller__c = someContact[1].Id,
                        Property__c = property.Id,
                        RecordTypeId = lease,
                        Status__c = 'Open'

                ),
                new Deal__c(
                        Broker__c = someContact[0].Id,
                        Buyer__c = someContact[2].Id,
                        Seller__c = someContact[1].Id,
                        Property__c = property.Id,
                        RecordTypeId = sale,
                        Status__c = 'Closed'
                )

        };
        insert someDeals;

    }

    @isTest static void testInformationDeals() {

        List<Id> ids = new List<Id>();
        List<Deal__c> deals = [SELECT Property__c, Buyer__c, Seller__c, Broker__c FROM Deal__c];
        for (Deal__c dl :deals) {
            ids.add(dl.Id);
        }
        List<Deal__c> readDeals = DealManager.readDeals(ids);
        System.assertEquals(deals, readDeals);

    }
    @isTest static void  testDeleteDeal(){
        List<Id> ids = new List<Id>();
        List<Deal__c> deals = [SELECT Property__c, Buyer__c, Seller__c, Broker__c FROM Deal__c];
        for (Deal__c dl :deals) {
            ids.add(dl.Id);
        }
        DealManager.deleteDeal(ids);
        List<Deal__c> deals2 = [SELECT Property__c, Buyer__c, Seller__c, Broker__c FROM Deal__c];
        System.assertEquals(0,deals2.size());

    }
    @isTest static void testCreateDealsFalse(){
        Contact broker = [SELECT Id FROM Contact WHERE LastName = 'LuLu'];
        Contact seller = [SELECT Id FROM Contact WHERE LastName = 'MuMu'];
        Contact buyer = [SELECT Id FROM Contact WHERE LastName= 'RuRu'];
        Property__c property = [SELECT Id FROM Property__c WHERE  Address__c = 'Link'];
        List<Deal__c> createDeals = DealManager.createDeals(COUNTER, broker.Id, buyer.Id,
                property.Id, seller.Id, 'Awaiting Approval' , false);
        List<Deal__c> insertDeals = [SELECT Id FROM Deal__c WHERE Status__c = 'Awaiting Approval'];
        System.assertEquals(2,createDeals.size());
        System.assertEquals(0,insertDeals.size());
    }
    @isTest static void testCreateDealstrue(){
        Contact broker = [SELECT Id FROM Contact WHERE LastName = 'LuLu'];
        Contact seller = [SELECT Id FROM Contact WHERE LastName = 'MuMu'];
        Contact buyer = [SELECT Id FROM Contact WHERE LastName= 'RuRu'];
        Property__c property = [SELECT Id FROM Property__c WHERE  Address__c = 'Link'];
        List<Deal__c> createDeals = DealManager.createDeals(COUNTER, broker.Id, buyer.Id,
                property.Id, seller.Id,'Awaiting Approval' , true);
        List<Deal__c> insertDeals = [SELECT Id FROM Deal__c WHERE Status__c = 'Awaiting Approval' ];
        System.assertEquals(2,createDeals.size());
        System.assertEquals(2,insertDeals.size());
    }
    @isTest static void testUpdateDealsTrue(){
        List<Id> idsDeals = new List<Id>(new Map<Id,Deal__c>([SELECT Id FROM Deal__c]).keySet());
        Contact broker = [SELECT Id FROM Contact WHERE LastName = 'LuLu'];
        Contact buyer = [SELECT Id FROM Contact WHERE LastName= 'RuRu'];
        Property__c property = [SELECT Id FROM Property__c WHERE  Address__c = 'Link'];
        List<Deal__c> updateDeals = DealManager.updateDeals(idsDeals, broker.Id, buyer.Id,
                property.Id,'Awaiting Approval' , true);
        List<Deal__c> refreshDeals = [SELECT Id FROM Deal__c WHERE Status__c = 'Awaiting Approval'];
        System.assertEquals(2,updateDeals.size());
        System.assertEquals(2,refreshDeals.size());
    }
    @isTest static void testUpdateDealsFalse(){
        List<Id> idsDeals = new List<Id>(new Map<Id,Deal__c>([SELECT Id FROM Deal__c]).keySet());
        Contact broker = [SELECT Id FROM Contact WHERE LastName = 'LuLu'];
        Contact buyer = [SELECT Id FROM Contact WHERE LastName= 'RuRu'];
        Property__c property = [SELECT Id FROM Property__c WHERE  Address__c = 'Link'];
        List<Deal__c> updateDeals = DealManager.updateDeals(idsDeals, broker.Id, buyer.Id,
                property.Id,'Awaiting Approval' , false);
        List<Deal__c> refreshDeals = [SELECT Id FROM Deal__c WHERE Status__c = 'Awaiting Approval'];
        System.assertEquals(2,updateDeals.size());
        System.assertEquals(0,refreshDeals.size());
    }

}
