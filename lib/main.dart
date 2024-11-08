import 'package:flutter/material.dart';
import 'homescreen.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

Future main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await dotenv.load();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: "Gemini Sample",
      theme: ThemeData(
        brightness: Brightness.dark,
        scaffoldBackgroundColor: Colors.black,
        appBarTheme: AppBarTheme(
          backgroundColor: Colors.black,
          iconTheme: IconThemeData(color: Colors.white),
        ),
        iconTheme: IconThemeData(color: Colors.white),
        buttonTheme: ButtonThemeData(buttonColor: Colors.teal),
      ),
      debugShowCheckedModeBanner: false,
      home: HomeScreen(),
    );
  }
}
