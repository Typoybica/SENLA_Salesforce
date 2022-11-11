/**
 * Created by shake on 25.09.2022.
 */

public with sharing class DealManager {

    public static void deleteDeal (List<Id> ids){
        delete [SELECT Id FROM Deal__c WHERE Id IN :ids];
    }

    public static List<Deal__c> createDeals(Integer count,Id broker ,Id buyer,Id property,
            Id seller, String status, Boolean push ){
        List<Deal__c> newDeal = new List<Deal__c>();

        for(Integer i=0;i<count;i++){
            Deal__c addDeal = new Deal__c();
            addDeal.Broker__c = broker;
            addDeal.Buyer__c = buyer;
            addDeal.Property__c = property;
            addDeal.Seller__c = seller;
            addDeal.Status__c = status;
            newDeal.add(addDeal);
        }
        if(push) insert newDeal;
        return newDeal;
    }

    public static List<Deal__c> readDeals(List<Id> ids){
        List<Deal__c> infoDeals = [SELECT Buyer__c, Property__c, Broker__c, Seller__c FROM Deal__c WHERE Id IN :ids];
        return infoDeals;
    }

    public static List<Deal__c> updateDeals( List<Id> ids, Id broker ,Id buyer,Id property, String status, Boolean push ){
        List<Deal__c> updatingDeals = [SELECT Buyer__c, Property__c, Broker__c FROM Deal__c WHERE Id IN :ids];
        for(Deal__c deal: updatingDeals){
            deal.Buyer__c = buyer;
            deal.Property__c = property;
            deal.Broker__c = broker;
            deal.Status__c = status;  
        }
        if(push) update updatingDeals;
        return updatingDeals;
    }
    public static List<Deal__c> readDealsByOwnerId(List<Id> id , String fields){
        return Database.query('SELECT ' + fields + ' FROM Deal__c WHERE Seller__c  =:id ');
    }

}
