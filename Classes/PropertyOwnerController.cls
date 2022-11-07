/**
 * Created by shake on 07.11.2022.
 */

global with sharing class PropertyOwnerController {
    private final Contact con;

    public PropertyOwnerController(ApexPages.StandardController stdController) {
        this.con = (Contact)stdController.getRecord();
    }

    public DealWrapper getSpace(){
        List<Deal__c> deals = [SELECT Id, Status__c, Closing_amount__c, Sale_price_Broker__c
        FROM Deal__c
        WHERE Seller__c =: con.Id
        AND Property__r.RecordType.Name = 'Space'];

        DealWrapper wrappers = new DealWrapper(deals);
        return wrappers;
    }
    public DealWrapper getIndustrial(){
        List<Deal__c> deals = [SELECT Id, Status__c, Closing_amount__c, Sale_price_Broker__c
        FROM Deal__c
        WHERE Seller__c =: con.Id
        AND Property__r.RecordType.Name = 'Industrial'];

        DealWrapper wrappers = new DealWrapper(deals);
        return wrappers;
    }
    public DealWrapper getOffice(){
        List<Deal__c> deals = [SELECT Id, Status__c, Closing_amount__c, Sale_price_Broker__c
        FROM Deal__c
        WHERE Seller__c =: con.Id
        AND Property__r.RecordType.Name = 'Office'];

        DealWrapper wrappers = new DealWrapper(deals);
        return wrappers;
    }

    public class DealWrapper {
        public Integer dealsAmount {get;set;}
        public Decimal sumOfType {get;set;}
        public Decimal sumWithPercent {get;set;}

        public DealWrapper(List<Deal__c> deals) {
            this.dealsAmount = 0;
            this.sumOfType  = 0;
            this.sumWithPercent = 0;

            for (Deal__c deal : deals) {
                this.sumOfType  += deal.Closing_amount__c;
                this.sumWithPercent += deal.Sale_price_Broker__c;
                if (deal.Status__c == 'Closed Won') {
                    this.dealsAmount+= 1;
                }
            }
        }
    }
}