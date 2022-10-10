/**
 * Created by shake on 25.09.2022.
 */

public with sharing class ContactManager {

    public static void deleteContact (List<Id> ids){
        delete [SELECT Id FROM Contact WHERE Id IN :ids];
    }

    public static List<Contact> createContact(Integer count, String firstName, String lastName,
            String phone, String email, String homePhone, Boolean push ){
        List<Contact> newContact = new List<Contact>();

        for(Integer i=0;i<count;i++){
          Contact addContact = new Contact();
            addContact.FirstName = firstName;
            addContact.LastName = lastName;
            addContact.Phone = phone;
            addContact.Email = email;
            addContact.HomePhone = homePhone;
            newContact.add(addContact);
        }
       if(push) insert newContact;
        return newContact;
    }

    public static List<Contact> readContact(List<Id> ids){
        List<Contact> infoContact = [SELECT Name, RecordTypeId, Phone, HomePhone, Email FROM Contact WHERE Id IN :ids];
        return infoContact;
    }

    public static List<Contact> updateContact(Integer count, String firstName, String lastName,
            String phone, String email, String homePhone,Boolean push){
            List<Contact> updatingContact = new List<Contact>();
        for(Integer i=0;i<count;i++){
            Contact refreshContact = new Contact();
            refreshContact.FirstName = firstName;
            refreshContact.LastName = lastName;
            refreshContact.Phone = phone;
            refreshContact.Email = email;
            refreshContact.HomePhone = homePhone;
            updatingContact.add(refreshContact);
        }
        if(push) update updatingContact;
        return updatingContact;
    }

}