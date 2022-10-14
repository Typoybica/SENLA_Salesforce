/**
 * Created by shake on 13.10.2022.
 */

public class RentNotifyBatch implements Database.Batchable<sObject> {

    public Database.QueryLocator start(Database.BatchableContext bc) {
        return Database.getQueryLocator(
                'SELECT ID, Buyer__c, End_rent__c FROM Deal__c WHERE End_rent__c = TOMORROW '
        );
    }
    public void execute(Database.BatchableContext bc, List<Deal__c> deals) {
        List <NotifyClientRentEnding__e> eventList = new List <NotifyClientRentEnding__e>();
        String[] sendEmail;
        for (Deal__c deal : deals) {
            NotifyClientRentEnding__e event = new NotifyClientRentEnding__e(DealId__c = deal.Id,
                    Info__c = JSON.serialize(new SelectInfo.Info(deal), true));
            eventList.add(event);
            sendEmail.add(deal.Buyer__r.Email);


        }
        sendEmail(sendEmail);
        List<Database.SaveResult> results = EventBus.publish(eventList);
        for (Database.SaveResult sr : results) {
            if (!sr.isSuccess()) {
                System.debug('Warning. Something wrong with your outcome.');
                break;
            }
        }



}
    public void finish(Database.BatchableContext bc){

    }
    public Static void sendEmail(String[] emailFromBuyer){
        Messaging.SingleEmailMessage mail = new Messaging.SingleEmailMessage();
        String[] addresses = emailFromBuyer;
        mail.setToAddresses(addresses);
        mail.setReplyTo('memoriseaboutwhat@gmail.com');
        mail.setSenderDisplayName('Vladic');
        mail.setBccSender(false);
        mail.setPlainTextBody('Your rent is end tomorrow, please leave.');
        Messaging.sendEmail(new Messaging.SingleEmailMessage[] { mail });
    }
}