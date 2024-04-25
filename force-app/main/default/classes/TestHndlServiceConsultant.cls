@isTest
private class TestHndlServiceConsultant {
    @TestSetup
    static void prepareData(){
        Manager__c Manager = new Manager__c(Name='Manager 1',
         Email__c = 'teastManager1@test.com', 
         Phone__c= '23467566');
         insert Manager;

         Service__c service = new Service__c(Manager__c = manager.Id, 
         Name__c='GGGG', 
         Status__c= 'In Progress', 
         Start_Date_Time__c = Datetime.now().addDays(-14), 
         End_Date_Time__c = Datetime.now().addDays(14),
         Maximum_Departments__c = 10,
         Service_Type__c = 'Virtual',
         Live__c = true
         );
         insert service;

         Consultant__c consultant1 = new Consultant__c(Name = 'Test Consultant', 
         Email__c = 'Testemail@test.com', 
         Phone__c = '6565476474');

         Consultant__c consultant2 = new Consultant__c(Name = 'Test Consultant', 
         Email__c = 'Testemail@test.com', 
         Phone__c = '6565476474');


        insert new List<Consultant__c>{consultant1, consultant2};
     insert new Service_Consultant__c(Service__c = service.Id, Consultant__c = consultant1.Id);
    }

    @isTest
    static void testPositive(){
        Service_Consultant__c serviceConsultant = [select id, Service__c, Consultant__c from Service_Consultant__c limit 1];

        Service_Consultant__c newRecord = new Service_Consultant__c(Service__c = serviceConsultant.Service__c, Consultant__c = serviceConsultant.Consultant__c );
        try {
            insert newRecord;
        } catch(Exception exp) {
            System.debug(exp.getCause());
             System.debug(exp.getMessage());
            
            System.assertEquals(true, exp.getMessage().contains('Found a duplicate Service consultant record on the system with id:'));
        }
    }

}

/*
hata oluyorsa bunun clasina git ve bunlari yap
schedule apexlerde sorun cikinca burdan sil yeniden deploy et
setup> Scheduled Jobs > delete the  schadule class which you have problem >deploy again
Also
SETUP > Deployment Settings > click checkbox(Allow deployments of components when
 corresponding Apex jobs are pending or in progress.Caution: Enabling this option may cause Apex jobs to fail.)


*/