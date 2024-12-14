abstract class MyState{}

class WeatherInitialState extends MyState{}  //to set initial state
class WeatherLoadingState extends MyState{} // to show circular bar when fetching data from api
class WeatherLoadedState extends MyState{// when data is loaded and we pass data to a javascript method to update ui of web
  WeatherLoadedState(this.data);
  Map<String,dynamic> data;
}
class WeatherErrorState extends MyState{   //handling error
  WeatherErrorState(this.error);
  String error;
}