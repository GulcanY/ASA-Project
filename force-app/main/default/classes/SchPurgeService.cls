public with sharing class SchPurgeService implements Database.Batchable<SObject>, Schedulable{

    // public void execute(SchedulableContext sc){
    //     integer pageSize = Test.isRunningTest()? 200:1;
    //     Database.executeBatch(new SchPurgeEvents(), pageSize() )
    // }

    
    public Database.QueryLocator  start(Database.BatchableContext bc) {
        // collect the batches of records or objects to be passed to execute
        return Database.getQueryLocator([SELECT Id FROM Service__c WHERE End_Date_Time__c <=: Datetime.now().addMonths(-2) AND Live__c = false]);


    }
    public void execute(Database.BatchableContext bc, List<Service__c> records){
        // process each batch of records
        try {
            delete records;
        } catch (Exception exc) {
            ErrorLogHelper.createErrorLog('SchPurgeService', 'execute', exc.getMessage());
        }


    }
    public void finish(Database.BatchableContext bc){
        // execute any post-processing operations

        List<GroupMember> members = [SELECT userOrGroupId FROM GroupMember WHERE Group.DeveloperName = 'Daily_Job'];

        Set<Id> userIds = new Set<Id>();
        for (GroupMember gm : members) {
            userIds.add(gm.userOrGroupId);
        }



        Set<String> toAddresses = new Set<String>();
        for (User  us : [SELECT Email FROM User WHERE Id IN: userIds AND IsActive = true]) {
            toAddresses.add(us.Email);
            
        }
        if (toAddresses.size() == 0) return; 
        

        Messaging.SingleEmailMessage email = new  Messaging.SingleEmailMessage();
        email.setSubject('Dayly Purge Event Job Has Run');
        email.setHtmlBody('Hello, <b/> <b/> Daily email job has finished.<b/>');
        email.settoAddresses(new List<String>(toAddresses));


  try {
    Messaging.sendEmail(new List<Messaging.SingleEmailMessage>{email});
    
  } catch (Exception e) {
    ErrorLogHelper.createErrorLog('SchPurgeService', 'finish', e.getMessage());

  }
    

}
public void execute(SchedulableContext sc){

    Database.executeBatch(new SchPurgeService(), 1);
}


}

/*
setup>apex job dan bak
setup>Scheduled Jobs job dan bak


schedule apexlerde sorun cikinca burdan sil yeniden deploy et
setup> Scheduled Jobs > delete the  schadule class which you have problem >deploy again
Also
SETUP > Deployment Settings > click checkbox(Allow deployments of components when
 corresponding Apex jobs are pending or in progress.Caution: Enabling this option may cause Apex jobs to fail.)


*/












//video for batch apex
//https://www.youtube.com/watch?v=FAfOTLOp3FY&list=PLV3ll8m0ZlprzM-qGJ5nQfo35_HWaNsTu&index=7

//https://www.youtube.com/watch?v=bz0F8mTcf30&list=PLV3ll8m0ZlprzM-qGJ5nQfo35_HWaNsTu&index=8





/*

https://trailhead.salesforce.com/content/learn/modules/asynchronous_apex/async_apex_batch


https://www.brcline.com/blog/everything-you-need-to-know-about-schedulable-batch-apex

https://www.sfdcpoint.com/salesforce/batch-apex-example-in-salesforce/

https://www.xgeek.net/salesforce/writing-a-schedulable-batch-apex-in-salesforce/


Batch Apex has some incredible advantages over regular apex. The execution time of batch apex can be much longer and a lot more records can be processed. As you might remember from my blog article How to Process Thousands Of Records on Salesforce batch apex implements the Database.batchable interface and allows you to do large amounts of querying and processing.

Scheduling Batch Apex has even more benefits than batch apex: it can do large jobs regularly.

Schedulable Batch Apex Use Cases
One of my favourite uses of Scheduleable batch apex is using it to run daily or weekly data cleanup. For example, you might want to verify the billing state or country based on the postal code or zipcode OR maybe you need to create a renewal opportunity for your SaaS business.

How to Create a Schedulable Batch Apex Class
There are three fairly large steps in creating a Schedulable Batch Apex Class.

Write a Batch Class.
Write a Scheduled Apex class which then executes the Batch Class.
Schedule the Scheduled Apex class from the Developer Console or from the User Interface.
Writing a Batch Class
As described above, a batch class is any class that implements Database.Batchable . A batch class includes a start method that returns a Database.QueryLocator, an execute method that returns void, and a finish method that returns void as well.

global class BatchClassExample implements Database.Batchable<SObject>{
    // used to build the query and get the records. For every 200 execute is called.
    // It's possible to have the execute run for smaller batches too. :)
    global Database.QueryLocator start(Database.BatchableContext BC) { 
        String soqlquery = 'SELECT Id, name, phone FROM Account';
        return database.getquerylocator(soqlquery);
    }
    
    // The batch job executes and operates on records of a max size of 200
    global void execute(Database.BatchableContext BC, List<SObject> scope) { 
        // your logic on the list of records goes in here...
    }

    // Finish runs at the end
    global void finish(Database.BatchableContext BC) { 
        System.debug('BatchApexClassExample Batch job completed successfully.');
    }
}
The finish method executes at the end and is a good way of doing any cleanup.

Writing Schedule Apex Class that Executes the batch Class
Scheduling Apex makes a lot of sense for routine operations – data cleanup, enrichment, closing off old opportunities, etc. All the class has to do is implement Schedulable and have an execute method which takes in the SchedulableContext.

global with sharing class ScheduleBatchExample implements Schedulable {
    global void execute(SchedulableContext sc) {
        //Database.executeBatch takes in the class, and then the size of batches.
        ID BatchId = Database.executeBatch(new BatchClassExample(), 200);
    }
}
Next, we need to schedule the class.

Scheduling the Schedulable Apex Class
A class can be scheduled through the user interface (Setup -> Apex Classes -> Click on Schedule Apex Button), through the developer console, or even through code.

 System.schedule('ScheduleBatchExample', '0 0 * * * ?', new ScheduleBatchApexClassExample());
I’ve used apex to schedule jobs during a package installation process. In particular, Spinify’s package actually uses quite a bit of scheduled apex.

Wrapping It Up
Scheduling Batch Apex is a great way of processing a lot of records. Salesforce reduces a lot of the governor limits if you used asynchronous apex.
*/