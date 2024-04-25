/*

public with sharing class InvacSmartyStreetCaller {

    
        @InvocableMethod(label='SmartyStreetAPI' description='Makes an HTTP GET Smarty.com' category='Location__c')
            public static void getAccountNames(List<Id> locationIds) {
          makeCallout(locationIds[0]);
          
        
    }
    @future(callout=true)
    private static void makeCallout(Id locId){
        try{
            Location__c location = [SELECT City__c, Postal_Code__c, State__c, Street__c FROM Location__c where Id=:locId];
            String endpoint = 'https://us-street.api.smartystreets.com/street-address'
            +'?auth-id=12fef767-87ad-6fd0-05aa-51e35ea7a673'
            + '&auth-token=UZnz55kxHkmhJRjteVZb&'
            + '&street=' + EncodingUtil.urlEncode(location.Street__c, 'UTF-8')
            //yukarida bosluklarin hata yapmamasi icin ayarladik
            //UTF-8 bilgisayarda bir dil turkce O harfi noktali ing o cevirir.Burada bosluk ve ozel karakterleri ceviriyoruz. 
            + '&city=' + EncodingUtil.urlEncode(location.City__c, 'UTF-8')
            + '&state=' + EncodingUtil.urlEncode(location.State__c, 'UTF-8') 
            + '&zipcode=' + EncodingUtil.urlEncode(location.Postal_Code__c, 'UTF-8')
            + '&match=enhanced';

        System.debug('endpoint;' + endpoint);
    Http http = new Http();
    HttpRequest request = new HttpRequest();
    request.setEndpoint(endpoint);
    request.setMethod('GET');
    HttpResponse response = http.send(request);

Integer statusCode = response.getStatusCode();
System.debug('StatusCode;' + statusCode);

String respBody = response.getBody();
System.debug('respBody;' + respBody);




}catch(Exception exc){
    string msg = exc.getMessage() + 'Line:' + exc.getLineNumber();
    System.debug('EXC:'+ msg);
   
    ErrorLogHelper.createErrorLog('InvacSmartyStreetCaller', 'makeCallout', msg);

}

}
}

*/

public with sharing class InvacSmartyStreetCaller {
    
    @InvocableMethod(label='SmartyStreetAPI' description='Makes an HTTP GET to Smarty.com' category='Location__c')
    public static void getAccountNames(List<Id> locationIds){
        makeCallout(locationIds[0]);
    }

    @future(callout=true)
    private static void makeCallout(Id locId){
        try {
            /*
            Location__c location = [SELECT City__c, PostalCode__c, State__c, Street__c FROM Location__c WHERE Id =: locId];

            SmartyStreetCreds__c setting = SmartyStreetCreds__c.getOrgDefaults();

            String path = '/street-address'
                + '?auth-id=' + setting.AuthId__c
                + '&auth-token=' + setting.AuthToken__c
                + '&street=' + EncodingUtil.urlEncode(location.Street__c, 'UTF-8')
                + '&city=' + EncodingUtil.urlEncode(location.City__c, 'UTF-8')
                + '&state=' + EncodingUtil.urlEncode(location.State__c, 'UTF-8')
                + '&zipcode=' + location.PostalCode__c
                + '&match=enhanced';
*/
Location__c location = [SELECT City__c, Postal_Code__c, State__c, Street__c FROM Location__c where Id=:locId];
            String endpoint = 'https://us-street.api.smartystreets.com/street-address'
            +'?auth-id=12fef767-87ad-6fd0-05aa-51e35ea7a673'
            + '&auth-token=UZnz55kxHkmhJRjteVZb&'
            + '&street=' + EncodingUtil.urlEncode(location.Street__c, 'UTF-8')
            //yukarida bosluklarin hata yapmamasi icin ayarladik
            //UTF-8 bilgisayarda bir dil turkce O harfi noktali ing o cevirir.Burada bosluk ve ozel karakterleri ceviriyoruz. 
            + '&city=' + EncodingUtil.urlEncode(location.City__c, 'UTF-8')
            + '&state=' + EncodingUtil.urlEncode(location.State__c, 'UTF-8') 
            + '&zipcode=' + EncodingUtil.urlEncode(location.Postal_Code__c, 'UTF-8')
            + '&match=enhanced';

            //System.debug('path:' + path);
            System.debug('endpoint;' + endpoint);
            
            Http http = new Http();
            HttpRequest request = new HttpRequest();
            request.setEndpoint('callout:SmartStreetAPI' + endpoint);
            request.setMethod('GET');
            HttpResponse response = http.send(request);

            Integer statusCode = response.getStatusCode();
            System.debug('statusCode:' + statusCode);

            String respBody = response.getBody();
            System.debug('respBody:' + respBody);

            update new Location__c(Id = locId,
                                   Verified__c = statusCode == 200
                                  );
        }catch(Exception exc){
            String msg = exc.getMessage() + ' (line:' + exc.getLineNumber();
            System.debug('EXC:' + msg);
            ErrorLogHelper.createErrorLog('InvSmartyStreetCaller', 'makeCallout', msg);
        }
    }

}

//

