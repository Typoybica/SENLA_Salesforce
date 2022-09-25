/**
 * Created by shake on 25.09.2022.
 */

public with sharing class PropertyManager {

    public static void deleteProperties (List<Id> ids){
        delete [SELECT Id FROM Property__c WHERE Id IN :ids];
    }

    public static List<Property__c> createProperties(Integer count, String address, Decimal sellingPrice,Decimal rentalPrice,
            Id owner, Boolean push ){
        List<Property__c> newProperties = new List<Property__c>();

        for(Integer i=0;i<count;i++){
            Property__c addProperty = new Property__c();
            addProperty.Address__c = address;
            addProperty.Selling_price__c = sellingPrice;
            addProperty.Rental_price_per_month__c = rentalPrice;
            addProperty.Contact__c = owner;
            newProperties.add(addProperty);
        }
        if(push) insert newProperties;
        return newProperties;
    }

    public static List<Property__c> readProperties(List<Id> ids){
        List<Property__c> infoProperties = [SELECT Address__c, Selling_price__c,Rental_price_per_month__c,Contact__c FROM Property__c WHERE Id IN :ids];
        return infoProperties;
    }

    public static List<Property__c> updateProperties(Integer count, String address, Decimal sellingPrice,Decimal rentalPrice,
            Id owner, Boolean push){
        List<Property__c> updatingProperties = new List<Property__c>();

        for(Integer i=0;i<count;i++){
            Property__c refreshProperty = new Property__c();
            refreshProperty.Address__c = address;
            refreshProperty.Selling_price__c = sellingPrice;
            refreshProperty.Rental_price_per_month__c = rentalPrice;
            refreshProperty.Contact__c = owner;
            updatingProperties.add(refreshProperty);
        }
        if(push) update updatingProperties;
        return updatingProperties;
    }
}