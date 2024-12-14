
import 'package:flutter/material.dart';
import 'package:hive_flutter/adapters.dart';
import 'package:weather/WebView.dart';

//This is our home page
class HomePage extends StatefulWidget {
  @override
  _HomePage createState() => _HomePage();
}

class _HomePage extends State<HomePage> {
  final _mybox=Hive.box('Mybox');

  String ?cityName;
  String ?temperature;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    if (_mybox.containsKey('city') && _mybox.containsKey('temp')) {
      // Retrieve the data if it exists
      cityName = _mybox.get('city');
      temperature = _mybox.get('temp');
      setState(() {

      });
      print("City: $cityName, Temperature: $temperature");
    } else {
      // If data doesn't exist, you can handle it here
      print("No city or temperature data found in Hive.");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Home Page'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              'City: ${cityName?? "Unknown"}',
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 10),
            Text(
              'Temperature: ${temperature?? "N/A"}',
              style: TextStyle(fontSize: 20),
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        //as we click on the floating action button we will navigate to WebView page
      onPressed: ()async{
    await Navigator.of(context).push(MaterialPageRoute(builder: (context)=>WebViewApp(CITY: cityName??"Unknown",TEMP: temperature??"N/A",)));
    //we will wait on this line until user pop from the webView page
      setState(() {
        cityName=_mybox.get('city');
        temperature=_mybox.get('temp').toString();
      });
      return;



      },
        child: Icon(Icons.web_outlined),
        tooltip: 'Update Weather',
      ),
    );
  }
}
