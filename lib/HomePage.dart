import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:weather/WebView.dart';
import 'package:weather/bloc/Bloc.dart';
import 'package:weather/bloc/event.dart';
import 'package:weather/bloc/state.dart';

class HomePage extends StatefulWidget {
  @override
  _HomePage createState() => _HomePage();
}

class _HomePage extends State<HomePage> {
  final _mybox = Hive.box('Mybox');
  String? cityName;
  String? temperature;

  @override
  void initState() {
    super.initState();
    // Trigger the LoadLocalData event on Bloc
    context.read<MyBloc>().add(loadLocalData());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Home Page'),
      ),
      body: BlocConsumer<MyBloc, MyState>(
        listener: (context, state) {
          if (state is WeatherLoadedState) {
            // Side effect: Save data to Hive
            context.read<MyBloc>().add(UpdateWeatherDataEvent(
              city: state.data['cityName']!,
              temperature: state.data['temp']!.toString(),
            ));
          } else if (state is WeatherErrorState) {
            print("Error loading weather data");
          }
        },
        builder: (context, state) {
          if (state is WeatherLoadingState) {
            return const Center(child: CircularProgressIndicator());
          } else if (state is WeatherLoadedState) {
            cityName=state.data['cityName'];
            temperature=state.data['temp'];
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    'City: ${state.data['cityName'] ?? "Unknown"}',
                    style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 10),
                  Text(
                    'Temperature: ${state.data['temp']?.toString() ?? "N/A"}',
                    style: const TextStyle(fontSize: 20),
                  ),
                ],
              ),
            );
          }
          return const Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  'City: Unknown',
                  style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 10),
                Text(
                  'Temperature: N/A',
                  style: const TextStyle(fontSize: 20),
                ),
              ],
            ),
          );
        },
      ),

      floatingActionButton: FloatingActionButton(
        onPressed: () {
          // Access the current Bloc state
          final currentState = context.read<MyBloc>().state;

          // Determine city and temperature based on the current state
          final city = (currentState is WeatherLoadedState)
              ? currentState.data['cityName'] ?? "Unknown"
              : "Unknown";

          final temp = (currentState is WeatherLoadedState)
              ? currentState.data['temp']?.toString() ?? "N/A"
              : "N/A";

          // Navigate to WebViewApp with appropriate data
          Navigator.of(context).push(
            MaterialPageRoute(
              builder: (context) => WebViewApp(
                CITY: city,
                TEMP: temp,
              ),
            ),
          );
        },
        child: const Icon(Icons.web_outlined),
        tooltip: 'Update Weather',
      ),

    );
  }
}
