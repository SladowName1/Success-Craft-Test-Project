trigger forecastInsertWeatherMessageTrggr on Forecast__c (before insert, after insert) {
   Weather_Setting__c weatherSetting=[select Lower_Limit__c, Lower_Limit_Message__c, Upper_Limit__c, Upper_Limit_Message__c, Normal_Limit_Message__c from Weather_Setting__c];

    if(Trigger.isBefore){
        if(Trigger.isInsert){
            for(Forecast__c f : Trigger.new){
                if(f.Temperature__c>weatherSetting.Upper_Limit__c){
                    f.Weather_Message__c=weatherSetting.Upper_Limit_Message__c;
                }
                else if(f.Temperature__c<weatherSetting.Lower_Limit__c){
                    f.Weather_Message__c=weatherSetting.Lower_Limit_Message__c;
                }
                else{
                    f.Weather_Message__c=weatherSetting.Normal_Limit_Message__c;
                }
            }
        }
    }

}