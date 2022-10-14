/**
 * Created by shake on 13.10.2022.
 */

public class SelectInfo {
    public class Info{
        public Datetime createDate {get; set;}
        public Date rentStartDate {get; set;}
        public Date rentEndDate {get; set;}
        public Client client {get; set;}
        public Property property {get; set;}

        public Info(Deal__c deal) {
            this.createDate = deal.CreatedDate;
            this.rentStartDate = deal.Start_rent__c;
            this.rentEndDate = deal.End_rent__c;
            this.client = new Client(deal.Buyer__r);
            this.property = new Property(deal.Property__r);
        }
    }

    public class Client {
        public String sfId {get; set;}
        public String firstName {get; set;}
        public String lastName {get; set;}
        public String email {get; set;}

        public Client(Contact buyer) {
            this.sfId = buyer.Id;
            this.firstName = buyer.FirstName;
            this.lastName = buyer.LastName;
            this.email = buyer.Email;
        }
    }

    public class Property {
        public String sfId {get; set;}
        public Client owner {get; set;}
        public LocationWrapper location {get; set;}

        public Property(Property__c property) {
            this.sfId = property.Id;
            this.owner = new Client(property.Contact__r);
            this.location = new LocationWrapper(property);
        }
    }

    public class LocationWrapper {
        public String country {get; set;}
        public String city {get; set;}
        public String address {get; set;}
        public String latitude   {get; set;}
        public String longitude {get; set;}

        public LocationWrapper(Property__c property) {
            this.country = property.Country__c;
            this.city = property.City__c;
            this.address = property.Address__c;
            this.latitude = String.valueOf(property.Latitude__c);
            this.longitude = String.valueOf(property.Longitude__c);
        }
    }
}