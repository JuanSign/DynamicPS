import 'package:flutter/material.dart';
import 'package:monitor_interface/pages/monitor_page.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Simulator Test',
      home: MonitorPage(),
    );
  }
}
