import 'package:flutter/material.dart';
import 'widgets/chatscreen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Gemini Sample"),
        centerTitle: true,
        elevation: 0,
      ),
      body: ChatScreen(),
    );
  }
}
