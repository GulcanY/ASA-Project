
@IsTest
public class TestServiceConsultantTriggerHandler {
    @isTest
    public static void TestcheckDuplicateRecords() {
        Consultant__c Con = new Consultant__c();
        Con.Name= 'Yesim';
        Con.Email__c='bcdjcbd@tgmail.com';
        Con.Phone__c='57586';
        insert Con;
        Manager__c Meng= new Manager__c();
        Meng.Email__c='zdgdtz@tgmail.com';
        Meng.Phone__c='56377';
        Meng.Name='Sam';
        insert Meng;
        Service__c Ser= new Service__c();
        Ser.Manager__c=Meng.Id;
        Ser.Name__c='Booking';
        Ser.Maximum_Departments__c=500;
        Ser.End_Date_Time__c=Datetime.now().addDays(10);
        Ser.Start_Date_Time__c=Datetime.now().addDays(5);
        Ser.Live__c=True;
        insert Ser;

        Service_Consultant__c SC=new Service_Consultant__c();
        SC.Service__c=Ser.Id;
        SC.Consultant__c=Con.Id;
        Insert SC;
        Test.startTest(); 
        try {
        Service_Consultant__c SC2=new Service_Consultant__c();
        SC2.Service__c=Ser.Id;
        SC2.Consultant__c=Con.Id;
        Insert SC2;
        } catch (Exception ex) {
            System.debug(ex);
        }
        
        Test.stopTest();
        List<Service_Consultant__c> numberOfSC = [SELECT Id FROM Service_Consultant__c];
        system.assertEquals(1, numberOfSC.size());
    }
    
   
}