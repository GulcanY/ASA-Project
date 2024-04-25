public class HandlerServiceConsultant {

    public static void checkDuplicateClientOnService(List<Service_Consultant__c> ServiceConsultants) {
        Map<String, Service_Consultant__c > ServiceConsultantMap = new Map<String, Service_Consultant__c >();


        Set<String> ConsultantIds = new Set<String>();
        Set<String> ServiceIds = new Set<String>();

        for (Service_Consultant__c sc : ServiceConsultants) {
            String uniqueKeys = String.valueOf(sc.Service__c) + String.valueOf(sc.Consultant__c);
            ServiceConsultantMap.put(uniqueKeys, sc);
            ServiceIds.add(sc.Service__c);
            ConsultantIds.add(sc.Consultant__c);
            
        }

        List<Service_Consultant__c> onSystemRecords = [Select id, Service__c, Consultant__c 
        from Service_Consultant__c
         where Service__c in: ServiceIds 
         and Consultant__c in: ConsultantIds];
         for (Service_Consultant__c sys : onSystemRecords) {
            String uniqueKeys = String.valueOf(sys.Service__c) + String.valueOf(sys.Consultant__c);

            Service_Consultant__c checkingObject = ServiceConsultantMap.get(uniqueKeys);
            if (checkingObject == null) continue;
            checkingObject.addError('Found a duplicate Service consultant record on the system with id: ' + String.valueOf(sys.id));
         }
        
    }








    /*  
    public static void ValidateServiceConsultant(List<Service_Consultant__c> servConslt) {
        set<id> serviceIds = new Set<Id>();
        set<id> consultantIds = new Set<Id>();
        Map<String, Service_Consultant__c> servConsltMap = new  Map<String, Service_Consultant__c>();


        for (Service_Consultant__c sc : servConslt) {
            serviceIds.add(sc.Service__c);
            consultantIds.add(sc.Consultant__c);

            String myKey = String.valueof(sc.Service__c) + String.valueof(sc.Consultant__c);
            servConsltMap.put(myKey, sc);
        }

        System.debug('serviceIds: ' + serviceIds);
        System.debug('consultantIds: ' + consultantIds);

        for (Service_Consultant__c sc : [select id, Service__c, Consultant__c 
        from Service_Consultant__c 
        where Service__c in: serviceIds 
        and Consultant__c in: consultantIds]) {
            
        }
        String systemKey = String.valueof(sc.Service__c) + String.valueof(sc.Consultant__c);
        Service_Consultant__c toBeFailed = servConsltMap.get(systemKey);
        if (toBeFailed != null) {
            toBeFailed.addError('This is duplicated record. ');
            
        }
    }

    */


}