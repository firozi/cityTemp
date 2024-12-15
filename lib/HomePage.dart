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
            cityName = state.data['cityName'];
            temperature = state.data['temp'].toString();
            context.read<MyBloc>().add(UpdateWeatherDataEvent (city: cityName!,temperature: temperature!));//storing data in hive
            // Update the UI if new data is loaded
            setState(() {});
          } else if (state is WeatherErrorState) {
            // Show an error message if loading fails
            print("error ");
          }
        },
        builder: (context, state) {
          if (state is WeatherLoadingState) {
            return const Center(child: CircularProgressIndicator());
          }
          return Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  'City: ${cityName ?? "Unknown"}',
                  style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 10),
                Text(
                  'Temperature: ${temperature ?? "N/A"}',
                  style: const TextStyle(fontSize: 20),
                ),
              ],
            ),
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          // Navigate to WebViewApp and wait for the result
          await Navigator.of(context).push(
            MaterialPageRoute(
              builder: (context) => WebViewApp(
                CITY: cityName ?? "Unknown",    //passing city and temp to webview page is its null then passing unknown and N/A
                TEMP: temperature ?? "N/A",
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
