/**
 * Created by shake on 30.09.2022.
 */

public with sharing class DealTriggerHandler {
    public void afterUpdate(List<Deal__c> newDeals){

        makeAfterUpdate(newDeals);

    }
    public void makeAfterUpdate(List<Deal__c> newDeals){

        List<Deal__c> closedLost = new  List<Deal__c>();
        List<Property__c> dealsWonList = new List<Property__c>();

        for(Deal__c d: newDeals){
            dealsWonList.add(d.Property__r);
        }

        for (Property__c p: dealsWonList){
            for(Deal__c d : p.Deals__r){
                if(!d.Status__c.contains('Closed') && d.RecordTypeId == 'Sale'){
                    d.Status__c = 'Closed Lost';
                    closedLost.add(p.Deals__r);
                }
            }
        }
        update closedLost;
    }

}