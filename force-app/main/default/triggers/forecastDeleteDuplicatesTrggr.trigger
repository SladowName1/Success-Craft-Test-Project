trigger forecastDeleteDuplicatesTrggr on Forecast__c (before insert,before update) {
    List<Forecast__c> forecastSelectAllFields=[select Date__c, City__c, Time__c from Forecast__c];
    List<Forecast__c> forecastDeleteDuplicates=new List<Forecast__c>();

    if(Trigger.isInsert) {

        if(Trigger.isBefore) {

            for(Forecast__c f : Trigger.New) {

                for(Forecast__c f2 : forecastSelectAllFields){

                if(f.City__c == f2.City__c && f.Date__c == f2.Date__c && f.Time__c == f2.Time__c){
                    forecastDeleteDuplicates.add(f2);
                }
            }
            }
        }
    }

    try {
        delete forecastDeleteDuplicates;
    }
    catch(DmlException e) {
        System.debug(e);
    }

}