import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:weather/bloc/repository.dart';
import 'package:weather/bloc/repository.dart';
import 'package:weather/bloc/state.dart';

import 'event.dart';

class MyBloc extends Bloc<MyEvent, MyState> {

  final Repository repository;// creating repo instance

  MyBloc(this.repository) : super(WeatherInitialState()) {//setting initailal

    on<GetRandomCityData>((event, emit) async {   // Registering the event handler for GetRandomCityData
      emit(WeatherLoadingState());    // setting loading state
      try {
        final data = await repository.fetchDataFromApi();
        emit(WeatherLoadedState(data!)); //after data fetched update the state to loaded
      } catch (e) {
        emit(WeatherErrorState('Failed to load data')); //handling error
      }
    });


    on<loadLocalData>((event, emit) async {
      emit(WeatherLoadingState());
      try {
        final city = repository.loadDataFromLocalStorage('city');
        final temp = repository.loadDataFromLocalStorage('temp');
        if (city != null && temp != null) {
          emit(WeatherLoadedState({'cityName': city, 'temp': temp}));
        } else {
          emit(WeatherErrorState('No local data available'));
        }
      } catch (e) {
        emit(WeatherErrorState('Failed to load local data'));
      }
    });

    on<UpdateWeatherDataEvent>((event, emit) async {

      try {
        repository.saveDataToLocalStorage('city', event.city);
        repository.saveDataToLocalStorage('temp', event.temperature);
      } catch (e) {
        emit(WeatherErrorState('Failed to update and persist data'));
      }
    });
  }





}
