import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hive_flutter/adapters.dart';
import 'package:weather/bloc/Bloc.dart';
import 'package:weather/bloc/event.dart';
import 'package:weather/bloc/state.dart';
import 'package:webview_flutter/webview_flutter.dart';

class WebViewApp extends StatefulWidget {
   WebViewApp({super.key, required this.CITY,required this.TEMP});
   //getting the name and temp from the home screen as we navigate to this screen
 final CITY;
 final TEMP;

  @override
  State<WebViewApp> createState() => _WebViewAppState();
}

class _WebViewAppState extends State<WebViewApp> {
   String?  city;
  String? temp;
  late final WebViewController controller;
   final _mybox=Hive.box('Mybox'); //accessing our hive database


  @override
  void initState() {
    super.initState();
    controller = WebViewController()//Initialing the WebViewController, which is responsible for controlling and managing the WebView widget
      ..setJavaScriptMode(JavaScriptMode.unrestricted) //allowing javascript code to run without any restriction
      ..addJavaScriptChannel("Flutter", onMessageReceived: (message) { //adding channel to communicate to javascript
        if (message.message == 'fetchRandomCity') {   //onclick on get random city data we sending a message fetchrandomcity which is equal to this message so we can execute the GetRandomCityData event
          print("fetched random city");
          context.read<MyBloc>().add(GetRandomCityData());
          print("called");
        } else if(message.message=='closeWebView'){  //same here sending message from javascript and checking here then pop this screen
          Navigator.of(context).pop();
        }
      })
      ..loadRequest(
        Uri.parse('https://firozi.github.io/webView/')); //This loads the web content into the WebView from the URL

  }
bool waiting=false;
  @override
  Widget build(BuildContext context) {
    WidgetsBinding.instance.addPostFrameCallback((_){
      //this method will be called after the build method is called and with future delayed im delaying by 3 sec so that webpage is loaded until then ,so we can call the javascript method to update the ui with city and temp from the home screen
      //there is onPageFinished method in webViewWidget se could have done this there but idk there was some problem so im doing this

      Future.delayed(Duration(seconds: 3),(){
        controller.runJavaScript('updateCityData("${widget.CITY}", "${widget.TEMP}")');});

    });
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: const Text('Flutter WebView wait 3 sec..'),
      ),
      body: BlocConsumer<MyBloc, MyState>(
        listener: (context, state) {
          if (state is WeatherLoadedState) {
            print("loaded state");
            // Pass data to WebView when data is fetched
             city = state.data['cityName'];
             temp = state.data['temp'];
            _mybox.put('city', city);//storing data in hive
            _mybox.put('temp', temp);

            controller.runJavaScript('updateCityData("$city", "$temp")');
          } else if (state is WeatherErrorState) {
            // Handle errors
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text(state.error)),
            );
          }
        },
        builder: (context, state) {
          if (state is WeatherLoadingState) {
            print("loading state");
            return const Center(child: CircularProgressIndicator());
          }
          return WebViewWidget(controller: controller);
        },
      ),
    );
  }
}


