@isTest(SeeAllData=true)
private class TestInsertWeatherMessage {
    @isTest(SeeAllData=true) static void TestInsertForecastWeatherMessageWithOnForecast(){
        City__c city=new City__c(Name='testFoInsert',Country__c='TE');
        insert city;
        Time newTime=Time.newInstance(1,1,1,0);
        date mydate=date.today();

        List<Forecast__c> forecast=new List<Forecast__c>();
        forecast.add(new Forecast__c(Name='Test',
        Date__c=mydate,Time__c=newTime,City__c=city.Id,Temperature__c=1));
        forecast.add(new Forecast__c(Name='Test',
        Date__c=mydate,Time__c=newTime,City__c=city.Id,Temperature__c=50));
        forecast.add(new Forecast__c(Name='Test',
        Date__c=mydate,Time__c=newTime,City__c=city.Id,Temperature__c=-30));

        Test.startTest();
        List<Database.SaveResult> result=Database.insert(forecast,false);
        Test.stopTest();

        delete city;
        for(Database.SaveResult r:result){
        System.assert(!r.isSuccess());
        System.assert(r.getErrors().size() > 0);
        System.assertEquals('Cannot delete account with related opportunities.',
        r.getErrors()[0].getMessage());
        }
    }
}
