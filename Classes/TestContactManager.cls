/**
 * Created by shake on 01.10.2022.
 */
@IsTest
private class TestContactManager {
    static final Id broker = Schema.SObjectType.Contact.getRecordTypeInfosByName().get('Broker').getRecordTypeId();
    static final Id propertyOwner = Schema.SObjectType.Contact.getRecordTypeInfosByName().get('Property Owner').getRecordTypeId();
    static final Integer COUNTER = 2;

    @testSetup
    static void setup(){

        List<Contact> someContact = new List<Contact>{
            new Contact(FirstName = 'L',
                        LastName = 'Lulu',
                        Phone = '+375296666666',
                        HomePhone = '666298',
                        Email = 'r@gmail.com',
                        RecordTypeId = broker),

            new Contact(FirstName = 'M',
                        LastName = 'MuMu',
                        Phone = '+375296766666',
                        HomePhone = '666798',
                        Email = 'ru@gmail.com',
                        RecordTypeId = propertyOwner)

        };
        insert someContact;

    }
    @isTest static void testInformaitonContact(){
        List<Id> ids = new List<Id>();
        List<Contact> contacts = [SELECT Name, RecordTypeId, Phone, HomePhone, Email FROM Contact ];
        for(Contact c: contacts){
            ids.add(c.Id);
        }
        List<Contact> readContact = ContactManager.readContact(ids);
        System.assertEquals(contacts,readContact);
    }
    @isTest static void testCreateContactFalse(){
        List<Contact> createContact = ContactManager.createContact(COUNTER, 'M','Dudu',
                '+375296766666', 'ru@gmail.com', '666798', false);
        List<Contact> insertContact = [SELECT Id FROM Contact WHERE LastName = 'DuDu'];
        System.assertEquals(2,createContact.size());
        System.assertEquals(0,insertContact.size());
    }
    @isTest static void testCreateContactTrue(){
        List<Contact> createContact = ContactManager.createContact(COUNTER, 'M','Dudu',
                '+375296766666', 'ru@gmail.com', '666798', true);
        List<Contact> insertContact = [SELECT Id FROM Contact WHERE LastName = 'DuDu'];
        System.assertEquals(2,createContact.size());
        System.assertEquals(2,insertContact.size());
    }
    @isTest static void testUpdateConcactTrue(){
        List<Id> ids = new List<Id>();
        List<Contact> contacts = [SELECT Name, RecordTypeId, Phone, HomePhone, Email FROM Contact ];
        for(Contact c: contacts){
            ids.add(c.Id);
        }
        List<Contact> updateContact = ContactManager.updateContact(ids,'M','Dudu',
        '+375296766666', 'ru@gmail.com', '666798', true);
        List<Contact> refreshContact = [SELECT Id FROM Contact WHERE LastName = 'DuDu'];
        System.assertEquals(2,updateContact.size());
        System.assertEquals(2,refreshContact.size());
    }
    @isTest static void testUpdateConcactFalse(){
        List<Id> ids = new List<Id>();
        List<Contact> contacts = [SELECT Name, RecordTypeId, Phone, HomePhone, Email FROM Contact ];
        for(Contact c: contacts){
            ids.add(c.Id);
        }
        List<Contact> updateContact = ContactManager.updateContact(ids,'M','Dudu',
                '+375296766666', 'ru@gmail.com', '666798', false);
        List<Contact> refreshContact = [SELECT Id FROM Contact WHERE LastName = 'DuDu'];
        System.assertEquals(2,updateContact.size());
        System.assertEquals(0,refreshContact.size());
    }
    @isTest static void  testDeleteContact(){
        List<Id> ids = new List<Id>();
        List<Contact> contacts = [SELECT Name, RecordTypeId, Phone, HomePhone, Email FROM Contact ];
        for(Contact c: contacts){
            ids.add(c.Id);
        }
        ContactManager.deleteContact(ids);
        List<Contact> contacts2 = [SELECT Name, RecordTypeId, Phone, HomePhone, Email FROM Contact ];
        System.assertEquals(0,contacts2.size());

    }

}