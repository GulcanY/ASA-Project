public class ServiceConsultantTriggerHandler {
    public static void checkDuplicateRecords(List<Service_Consultant__c> TriggerNew ) {
        Map<String, Service_Consultant__c> oldMapSC=new Map<String, Service_Consultant__c>();
        List<Service_Consultant__c> oldSerCons =[SELECT Id, Consultant__c, Service__c FROM Service_Consultant__c];
        for (Service_Consultant__c oldSC : oldSerCons) {
            String sumOfIds = String.valueOf(oldSC.Consultant__c)+ String.valueOf(oldSC.Service__c);
            oldMapSC.put(sumOfIds, oldSC );// birinci key tarafi eski SC recordlarin parenti olan
            //Cunsoltant ve service rekationship fieldlarinin toplamindan olusuyor, sag taraf 2 taraf value tarafi  eski SC recordlarindan olusuyor

        }
        for (Service_Consultant__c newSC : TriggerNew) {
            String sumOfIds = String.valueOf(newSC.Consultant__c)+ String.valueOf(newSC.Service__c);
            if (oldMapSC.containsKey(sumOfIds)) {
                newSC.addError('There is duplicade records');
                
            }
        }
    }
}
