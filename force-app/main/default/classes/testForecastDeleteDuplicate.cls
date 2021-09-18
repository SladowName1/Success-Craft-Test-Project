@isTest(SeeAllData=true)
private class testForecastDeleteDuplicate {
    @isTest(SeeAllData=true) static void TestForecastDeleteDuplicate(){
        List<Forecast__c> forecast=[select City__c, Date__c, Time__c from Forecast__c limit :3];

        Test.startTest();
        List<Database.SaveResult> result=Database.insert(forecast,false);
        Test.stopTest();

        for(Database.SaveResult r:result){
            System.assert(!r.isSuccess());
            System.assert(r.getErrors().size() > 0);
            System.assertEquals('Cannot delete account with related opportunities.',
            r.getErrors()[0].getMessage());
            }
    }
}
