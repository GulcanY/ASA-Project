public without sharing class ErrorLogHelper {
    public static void createErrorLog(String className, String processName, String details) {
        insert new Error_Log__c(ApexClass__c = className, 
                                Log_Details__c = details, 
                                Log_Date_Time__c = Datetime.now());
        
    }
}

//https://salesforcecodex.com/salesforce/exception-logging-in-custom-object-salesforce-apex/

//https://intercom.help/whistic/en/articles/5125653-using-salesforce-error-logs