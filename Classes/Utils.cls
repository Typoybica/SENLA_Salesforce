/**
 * Created by shake on 14.10.2022.
 */

public with sharing class Utils {
    public class Response {
        public Date startDate {get; set;}
        public Date endDate {get; set;}
        public String totalRevenue {get; set;}
        public List<DealWrapper> deals {get; set;}

        public Response (Date startDate, Date endDate, List<Deal__c> deals) {
            this.startDate = startDate;
            this.endDate = endDate;
            this.deals = new List<DealWrapper>();
            Decimal revenue = 0;
            for (Deal__c deal : deals) {
                this.deals.add(new DealWrapper(deal));
                revenue += deal.Rent_price__c;
            }

            this.totalRevenue = String.valueOf(revenue);
        }
    }
    public class DealWrapper {
        public String sfId {get; set;}
        public String dealType {get; set;}
        public SelectInfo.Client realtor {get; set;}
        public Decimal revenue {get; set;}
        public String clientId {get; set;}
        public String propertyId {get; set;}

        public DealWrapper (Deal__c deal) {
            this.sfId = deal.Id;
            this.dealType = deal.RecordType.Name;
            this.realtor = new SelectInfo.Client(deal.Seller__r.Id, deal.Seller__r.FirstName, deal.Seller__r.LastName,deal.Seller__r.Email);
            this.revenue = deal.Rent_price__c;
            this.clientId = deal.Buyer__r.Id;
            this.propertyId = deal.Property__c;
        }
    }
    public class UpdatePropertyOwner {
        public String propertyId {get; set;}
        public SelectInfo.Client owner {get; set;}
    }
}
