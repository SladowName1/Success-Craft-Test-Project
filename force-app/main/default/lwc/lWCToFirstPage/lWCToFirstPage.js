import { LightningElement,track, wire } from 'lwc';
import loadInfoAboutWeather from '@salesforce/apex/WeatherController.ApiCall'
import insertToCity from '@salesforce/apex/WeatherController.insertToCity'
import insertToForecast from '@salesforce/apex/WeatherController.insertToForecast'
import listForecast from '@salesforce/apex/WeatherController.listForecast'

export default class LWCToFirstPage extends LightningElement {
    cityName = '';
    changeCityName;
    @track listForecast;
    counter=0;

    @wire(loadInfoAboutWeather,{City:'$cityName'}) forecastWeather;

    handleChangeCity(event){
        this.changeCityName = event.target.value;
        this.cityName = this.changeCityName;
    }

    handleClick(){
        this.forecastWeather=JSON.parse(this.forecastWeather.data);
        const formattedDate = [];
        const dateForName = [];
        const timeForTimeFiled = [];
        const temps = [];


        for(let i = 0; i < this.forecastWeather.list.length; i++){
            let date = new Date(this.forecastWeather.list[i].dt * 1000);
            let year = date.getFullYear();
            let mm = date.getMonth() + 1;
            let dd = date.getDate();
            let hour = date.getHours();
            let min = date.getMinutes();
            let mil = date.getMilliseconds();

            let formdate = mm + '/' + dd + '/' + year;
            let dateFName = dd + '/' + mm + '/'+year;
            let timeForField = hour + '.' + min + '.'+mil;
            let tempsForList = this.forecastWeather.list[i].main.temp.toString();

            formattedDate.push(formdate);
            dateForName.push(dateFName);
            timeForTimeFiled.push(timeForField);
            temps.push(tempsForList);
        }     

        let cityName = this.forecastWeather.city.name;
        let countryName = this.forecastWeather.city.country;

        insertToCity({City:cityName,Country:countryName});
        insertToForecast({DateForName:dateForName,City:cityName,DateForDateField:formattedDate,TimeForTimeField:timeForTimeFiled,temperature:temps});

        listForecast({DateForName:dateForName,City:cityName,DateForDateField:formattedDate,TimeForTimeField:timeForTimeFiled,temperature:temps})
        .then((result)=>{
            this.listForecast=result;
            for(let i=0;i<this.listForecast.length;i++){
                this.listForecast[i].Time__c=this.listForecast[i].Time__c/10800000*3;
            }
        })
        .catch((error)=>{
            console.log(error);
        });
        this.listForecast=null;
        console.log(this.listForecast);
    }
}