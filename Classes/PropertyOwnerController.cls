/**
 * Created by shake on 07.11.2022.
 */

global with sharing class PropertyOwnerController {
    private final Contact contact; //change name value and class

    public PropertyOwnerController(ApexPages.StandardController stdController) {
        this.contact = (Contact)stdController.getRecord();
    }

    public List<DealWrapper> getDataForTable(){
        String dataForTable = 'Id, Status__c, Closing_amount__c, Sale_price_Broker__c, Property__r.RecordType.Name ';
        List<Deal__c>  wonDealList = DealManager.readDealsByOwnerId(new List<Id>{contact.Id}, dataForTable);
        Map<String, List<Deal__c>> propertyRecordType = new Map<String, List<Deal__c>>();

        for(Deal__c deal : wonDealList) {

            List<Deal__c> dealWithPropertyType = propertyRecordType.get(deal.Property__r.RecordType.Name);

            if (dealWithPropertyType == null) {
                propertyRecordType.put(deal.Property__r.RecordType.Name, new List<Deal__c>());
            }

            propertyRecordType.get(deal.Property__r.RecordType.Name).add(deal);
        }

        List<DealWrapper> wrappers = new List<DealWrapper>();
        for (List<Deal__c> groupedDeals : propertyRecordType.values()) {
            wrappers.add(new DealWrapper(groupedDeals));
        }

        return wrappers;
    }

    public class DealWrapper {
        public String propertyType {get;set;}
        public Integer dealsAmount {get;set;}
        public Decimal sumOfType {get;set;}
        public Decimal sumWithPercent {get;set;}

        public DealWrapper(List<Deal__c> deals) {
            this.propertyType = '';
            this.dealsAmount = 0;
            this.sumOfType  = 0;
            this.sumWithPercent = 0;

            for (Deal__c deal : deals) {
                this.sumOfType  += deal.Closing_amount__c;
                this.sumWithPercent += deal.Sale_price_Broker__c;
                this.propertyType += deal.Property__r.RecordType.Name;
                if (deal.Status__c == 'Closed Won') {
                    this.dealsAmount+= 1;
                }
            }
        }
    }
}