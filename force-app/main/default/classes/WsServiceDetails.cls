@RestResource(urlMapping='/ServiceDetails/*')
global with sharing class WsServiceDetails {
    @HttpGet
    global static List<ServiceWrapper> getServiceDetails() {
        List<ServiceWrapper> services = new List<ServiceWrapper>();
        for(Service__c serv :[SELECT id, Name, Name__c, Start_Date_Time__c, End_Date_Time__c, Service_Type__c, Manager__r.Name FROM Service__c WHERE Live__c = true AND Start_Date_Time__c >= TODAY WITH SECURITY_ENFORCED])
        //SECURITY_ENFORCED demek code calistiran user sadece o bilgilere ulasir guvenlik icin
        
        {
            services.add (new ServiceWrapper(serv));
        }
     return services;
}
    global class ServiceWrapper {
        global string serviceId;
        global string stdName;
        global string name;
        global DateTime startDate;
        global DateTime endDate;
        global string serviceType;
        global string manager;

        global ServiceWrapper(Service__c service){
        this.serviceId = String.valueOf(service.Id);
        this.stdName = service.Name;
        this.name = service.Name__c;
        this.startDate = service.Start_Date_Time__c;
        this.endDate = service.End_Date_Time__c;
        this.serviceType = service.Service_Type__c;
        this.manager = service.Manager__r.Name;
       }

    }
}