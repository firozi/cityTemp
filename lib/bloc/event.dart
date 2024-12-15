abstract class MyEvent{}

class GetRandomCityData extends MyEvent{} //to click on Get Random city data

class loadLocalData extends MyEvent{}

class UpdateWeatherDataEvent extends MyEvent {
final String city;
final String temperature;

 UpdateWeatherDataEvent({required this.city, required this.temperature});

@override
List<Object?> get props => [city, temperature];
}