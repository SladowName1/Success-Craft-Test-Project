@isTest(SeeAllData=true)
private class TestToWeatherController {
    @isTest(SeeAllData=true) static void TestApiCallWithCityName(){
        String check=WeatherController.ApiCall('Minsk');
        String api=[select Api_Key__c from Weather_Setting__c].Api_Key__c;
        Http http=new Http();
        HttpRequest request=new HttpRequest();
        request.setEndPoint('http://api.openweathermap.org/data/2.5/forecast?q=Minsk&appid='+api+'&units=metric');
        request.setMethod('GET');
        HttpResponse response=http.send(request);
        System.assertEquals(response.getBody(), check);
    }

    @isTest(SeeAllData=true) static void TestApiCallWithOutCityName(){
        String check=WeatherController.ApiCall('');
        System.assertEquals('False', check);
    }

    @isTest(SeeAllData=true) static void TestInsertCityWitAvailableCity(){
        WeatherController.insertToCity('Minsk','BY');
    }

    @isTest(SeeAllData=true) static void TestInsertCityWitNoAvailableCity(){
        WeatherController.insertToCity('Chack','BY');
    }

    @isTest(SeeAllData=true) static void TestInsertForeacst(){
        List<String> dateForName=new List<String>();
        DateForName.add('11/12/2020');
        DateForName.add('13/12/2020');
        DateForName.add('14/12/2020');

        List<String> dateForField=new List<String>();
        dateForField.add('11/11/2020');
        dateForField.add('8/11/2020');
        dateForField.add('10/3/2020');

        List<String> timeForField=new List<String>();
        timeForField.add('11.12.23');
        timeForField.add('13.12.20');
        timeForField.add('14.12.13');

        List<String> temperature=new List<String>();
        temperature.add('13');
        temperature.add('15');
        temperature.add('-30');

        WeatherController.insertToForecast(dateForName,'Minsk',dateForField,timeForField,temperature);

        List<Forecast__c> forecast=[select id, Name from Forecast__c limit :3];
        delete forecast;
    }

    @isTest(SeeAllData=true) static void TestSelectForeacst(){
        List<String> dateForName=new List<String>();
        DateForName.add('11/12/2020');
        DateForName.add('13/12/2020');
        DateForName.add('14/12/2020');

        List<String> dateForField=new List<String>();
        dateForField.add('11/11/2020');
        dateForField.add('8/11/2020');
        dateForField.add('10/3/2020');

        List<String> timeForField=new List<String>();
        timeForField.add('11.12.23');
        timeForField.add('13.12.20');
        timeForField.add('14.12.13');

        List<String> temperature=new List<String>();
        temperature.add('13');
        temperature.add('15');
        temperature.add('-30');

        WeatherController.listForecast(dateForName,'Minsk',dateForField,timeForField,temperature);
    }
}
