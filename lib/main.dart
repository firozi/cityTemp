import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hive_flutter/adapters.dart';
import 'package:weather/HomePage.dart';
import 'package:weather/bloc/Bloc.dart';
import 'package:weather/bloc/repository.dart';
import 'package:webview_flutter/webview_flutter.dart';

void main() async{
  WidgetsFlutterBinding.ensureInitialized();
  await Hive.initFlutter();
  final box=await Hive.openBox("Mybox");
  runApp(
    BlocProvider(
      create: (context)=>MyBloc(Repository()),
      child: MaterialApp(
        theme: ThemeData(useMaterial3: true),
        home:  HomePage(),
      ),
    ),
  );
}

