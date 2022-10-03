/**
 * Created by shake on 25.09.2022.
 */

public with sharing class DealManager {

    public static void deleteDeal (List<Id> ids){
        delete [SELECT Id FROM Deal__c WHERE Id IN :ids];
    }

    public static List<Deal__c> createDeals(Integer count,Id broker ,Id buyer,Id property,Id seller, Boolean push ){
        List<Deal__c> newDeal = new List<Deal__c>();

        for(Integer i=0;i<count;i++){
            Deal__c addDeal = new Deal__c();
            addDeal.Broker__c = broker;
            addDeal.Buyer__c = buyer;
            addDeal.Property__c = property;
            addDeal.Seller__c = seller;
            newDeal.add(addDeal);
        }
        if(push) insert newDeal;
        return newDeal;
    }

    public static List<Deal__c> readDeals(List<Id> ids){
        List<Deal__c> infoDeals = [SELECT Buyer__c, Property__c, Broker__c, Seller__c FROM Deal__c WHERE Id IN :ids];
        return infoDeals;
    }

    public static List<Deal__c> updateDeals(Integer count,Id broker ,Id buyer,Id property,Id seller, Boolean push ){
        List<Deal__c> updatingDeal = new List<Deal__c>();

        for(Integer i=0;i<count;i++){
            Deal__c refreshDeal = new Deal__c();
            refreshDeal.Broker__c = broker;
            refreshDeal.Buyer__c = buyer;
            refreshDeal.Property__c = property;
            refreshDeal.Seller__c = seller;
            updatingDeal.add(refreshDeal);
        }
        if(push) update updatingDeal;
        return updatingDeal;
    }

}