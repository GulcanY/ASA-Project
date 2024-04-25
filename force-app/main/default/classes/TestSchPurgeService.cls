@isTest 
private class TestSchPurgeService {
    @isTest 
    static void tester(){
        Manager__c Manager = new Manager__c(Name='Manager 1',
         Email__c = 'teastManager1@test.com', 
         Phone__c= '23467566');
         insert Manager;

         Service__c service1 = new Service__c(Manager__c = manager.Id, 
         Name__c='Test Service 2', 
         Status__c= 'In Progress', 
         Start_Date_Time__c = Datetime.now().addDays(-14), 
         End_Date_Time__c = Datetime.now().addDays(14),
         Maximum_Departments__c = 10,
         Service_Type__c = 'Virtual',
         Live__c = true
         );
         

         Service__c service2 = new Service__c(Manager__c = manager.Id, 
         Name__c='Test Service 2', 
         Status__c= 'Completed', 
         Start_Date_Time__c = Datetime.now().addMonths(-3), 
         End_Date_Time__c = Datetime.now().addMonths(-3).addDays(14),
         Maximum_Departments__c = 10,
         Service_Type__c = 'Virtual',
         Live__c = false
         );
        insert new List<Service__c>{service1, service2};


         Test.startTest();

         SchPurgeService obj = new SchPurgeService();
         obj.execute(null);//batch class test edilirken 
         

         Test.stopTest();

         Integer serviceCount = [Select Count() FROM Service__c];
         System.assertEquals(1, serviceCount);//testin saglamasi icin



    }



}