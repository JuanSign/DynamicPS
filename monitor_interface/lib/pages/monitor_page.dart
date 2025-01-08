import 'dart:convert'; // For json.decode()
import 'dart:math'; // For atan2
import 'package:flutter/material.dart';
import 'package:monitor_interface/components/compass.dart';
import 'package:web_socket_channel/web_socket_channel.dart';

class MonitorPage extends StatefulWidget {
  const MonitorPage({super.key});

  @override
  // ignore: library_private_types_in_public_api
  _MonitorPageState createState() => _MonitorPageState();
}

class _MonitorPageState extends State<MonitorPage> {
  final WebSocketChannel channel = WebSocketChannel.connect(
    Uri.parse('ws://192.168.2.62:8765'), // Replace with your WebSocket URL
  );

  // Variables to store wave and wind data
  String waveSpeed = '';
  List<Map<String, dynamic>> waveAngles = [];
  String windSpeed = '';
  List<Map<String, dynamic>> windAngles = [];

  @override
  void initState() {
    super.initState();
    // Listen for incoming WebSocket messages
    channel.stream.listen((message) {
      // Parse the JSON data
      var decodedMessage = json.decode(message);

      // Extract wave data
      setState(() {
        waveSpeed = decodedMessage['wave']['speed'].toString();
        waveAngles = List<Map<String, dynamic>>.from(
          decodedMessage['wave']['points'].map((point) {
            double x = point[0];
            double y = point[1];
            double angle =
                atan2(y, x) * (180 / pi); // Calculate angle in degrees
            return {'x': x, 'y': y, 'angle': angle};
          }),
        );
      });

      // Extract wind data
      setState(() {
        windSpeed = decodedMessage['wind']['speed'].toString();
        windAngles = List<Map<String, dynamic>>.from(
          decodedMessage['wind']['points'].map((point) {
            double x = point[0];
            double y = point[1];
            double angle =
                atan2(y, x) * (180 / pi); // Calculate angle in degrees
            return {'x': x, 'y': y, 'angle': angle};
          }),
        );
      });
    });
  }

  @override
  void dispose() {
    channel.sink.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Monitor Page')),
      body: ListView(
        padding: const EdgeInsets.all(8.0),
        children: [
          Text(
            'Wave Speed: $waveSpeed',
            style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
          ),
          ...waveAngles.map((point) => Text(
                'Wave Point (${point['x']}, ${point['y']}): ${point['angle'].toStringAsFixed(2)}°',
                style: TextStyle(fontSize: 16),
              )),
          SizedBox(height: 16),
          Text(
            'Wind Speed: $windSpeed',
            style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
          ),
          ...windAngles.map((point) => Text(
                'Wind Point (${point['x']}, ${point['y']}): ${point['angle'].toStringAsFixed(2)}°',
                style: TextStyle(fontSize: 16),
              )),
          Text(
            'Wave Points',
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
          Row(mainAxisAlignment: MainAxisAlignment.spaceEvenly, children: [
            ...waveAngles.map((point) => Compass(angle: point['angle']))
          ]),
          SizedBox(height: 20),
          Text(
            'Wind Points',
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
          Row(mainAxisAlignment: MainAxisAlignment.spaceEvenly, children: [
            ...windAngles.map((point) => Compass(angle: point['angle']))
          ]),
        ],
      ),
    );
  }
}
