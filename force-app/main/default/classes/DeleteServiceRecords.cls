
/*
Develop Schedulable Apex Batch - Write a Schedulable  Apex Batch which should purge(delete) all the Service records which are more than 2 months old & have not been live.Hint - Use End Date of the Service & live? checkbox of Service Record. In the finish method of the batch apex sends an email to the “Public Group“ email address saying that execution of the batch has been processed.  (Run every 3.00AM automatically)
1. A handler class must be used for the batch. 
2. Send Email from the finish method as outlined in the requirement .
Create a Public Group named  “Daily Job”.
Add two active users into the Public Group.
Email those users.

Answers
1)class creation = Schedulable Apex Batch
2) handler class creation = A handler class must be used for the batch
Public group for email
Email 

*/



//copy paste from website for batch
//https://developer.salesforce.com/docs/atlas.en-us.apexcode.meta/apexcode/apex_batch_interface.htm

//search for datetime now (field format) salesforce
//https://developer.salesforce.com/docs/atlas.en-us.apexref.meta/apexref/apex_methods_system_datetime.htm
//search for datetime monts(field format) salesforce
//https://developer.salesforce.com/docs/atlas.en-us.apexref.meta/apexref/apex_methods_system_datetime.htm#apex_System_Datetime_addMonths


public class DeleteServiceRecords implements Database.batchable<sObject>{ 
    public Database.QueryLocator start (Database.BatchableContext bc){ 
        //Develop Schedulable Apex Batch - Write a Schedulable  Apex Batch which should purge(delete) all the Service records which are more than 2 months old & have not been live.

        string query = 'SELECT id, Live__c, Name__c, End_Date_Time__c FROM Service__c WHERE Live__c = false AND End_Date_Time__c < datetime.now().addMonths(-2)';
        //End_Date_Time__c < datetime.now().addMonths(-2) anlami
        //datetime.now 17 ocak sa addMonths(-2) 17 Kasim dir
        //soruda 2 ay oncekiler silinsin dedigi icin
        //End_Date_Time__c < 17 kasim ve 17 kasimdan oncekiler silinecek saatine gore degisir
        //today kullanmamamizin sebebi datetime time var null var
        //Date classlarda Today() kullanilir

        return Database.getQueryLocator(query); 
    }     


    //execute
    public void execute(Database.BatchableContext bc, List<Service__c> scope){
        delete scope;
    }    
    
    //create a Public group named "Daily Job"setup dan public group new adi daily job
    //in the finish method of the batch apex sends an email to the "Public Group" email adress saying that execution of the batch has been processed. (Run every 3:00AM automatically)
    //send email from the finish method as outlined in the requirement
    
    //add two active users into rhe Public Group
    //email to these group

    //finish
   
    public void finish(Database.BatchableContext bc){
         
        System.debug('islem bitti');
        AsyncApexJob a = [select id, Status, NumberOfErrors, JobItemsProcessed, TotalJobItems, CreatedBy.Email from AsyncApexJob where id =:bc.getJobId()];

        Messaging.SingleEmailMessage mail = new Messaging.SingleEmailMessage();
        String[] toAdresses = new String[]{'gulcanusa111@gmail.com', 'gulcan.yildirim@gmail.com'};
        mail.setToAddresses(toAdresses);
        mail.setSubject(a.status);
        mail.setPlainTextBody( '\n' + ' Execution of the batch has been processed ' + a.TotalJobItems + '\n' + ' batches with ' + a.NumberOfErrors + ' failures.');
        Messaging.sendEmail(new Messaging.SingleEmailMessage[]{mail});
        
    }
    
} 
 //  \n satir atlamayi sagliyor