public with sharing class WeatherController {
    @AuraEnabled(cacheable=true)
    public static string ApiCall(String City){ 
        if(City!=''){
        String api=[select Api_Key__c from Weather_Setting__c].Api_Key__c;
        Http http=new Http();
        HttpRequest request=new HttpRequest();
        request.setEndPoint('http://api.openweathermap.org/data/2.5/forecast?q='+City+'&appid='+api+'&units=metric');
        request.setMethod('GET');
        HttpResponse response=http.send(request);
        return response.getBody();
        }
        else{
            return 'False';
        }
    }

    @AuraEnabled
    public static void insertToCity(String City, String Country){
        List<City__c> cities=[select Name, Country__c from City__c];
        Boolean a=true;
        for(City__c c:cities){
            if(c.Name==City){
                a=false;
            }
        }
        if(a) {
            City__c myCity=new City__c(Name=City, Country__c=Country);
            try {
                insert myCity;
            }
            catch(DmlException  e) {
    
            }
        }
    }


    @AuraEnabled
    public static void insertToForecast(List<String> DateForName,String City, List<String> DateForDateField,List<String> TimeForTimeField,List<String> temperature){   
        List<Forecast__c> forecasts=new List<Forecast__c>();
        City__c myCity=[select Id from City__c where Name=:City];

        for(Integer i=0;i<DateForName.size();i++){
            date mydate=date.parse(DateForDateField[i]);

            List<String> values=TimeForTimeField[i].split('\\.');
            Integer hours=Integer.valueof(values[0]);
            Integer min=Integer.valueof(values[1]);
            Integer sec=Integer.valueof(values[2]);
            Time newTime=Time.newInstance(hours,min,sec,0);

            forecasts.add(new Forecast__c(Name=City+'-'+DateForName[i],
            Date__c=mydate,Time__c=newTime,City__c=myCity.Id,Temperature__c=Decimal.valueof(temperature[i])));
        }
        try{
            insert forecasts;
        }
        catch(DmlException  e){
            System.debug(e);
        }   
    }
}