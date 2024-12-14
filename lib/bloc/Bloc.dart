import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:weather/bloc/repository.dart';
import 'package:weather/bloc/repository.dart';
import 'package:weather/bloc/state.dart';

import 'event.dart';

class MyBloc extends Bloc<MyEvent, MyState> {
  final Repository repository;// creating repo instance

  MyBloc(this.repository) : super(WeatherInitialState()) {   //setting initailstate
    // Registering the event handler for GetRandomCityData
    on<GetRandomCityData>((event, emit) async {
      emit(WeatherLoadingState());    // setting loading state
      try {
        final data = await repository.fetchDataFromApi();
        emit(WeatherLoadedState(data!)); //after data fetched update the state to loaded
      } catch (e) {
        emit(WeatherErrorState('Failed to load data')); //handling error
      }
    });
  }


}
