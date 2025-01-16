import 'package:flutter/material.dart';
import 'package:hmi_control/utils/socket_server.dart';

class HilPage extends StatefulWidget {
  const HilPage({super.key});

  @override
  // ignore: library_private_types_in_public_api
  _HilPageState createState() => _HilPageState();
}

class _HilPageState extends State<HilPage> {
  // ignore: non_constant_identifier_names
  final TextEditingController _IPAddress = TextEditingController();
  // ignore: non_constant_identifier_names
  final TextEditingController _Port = TextEditingController();

  late final SocketServer _server;
  bool _isConnected = false;

  List<Widget> log = [];

  @override
  void initState() {
    super.initState();
    _server = SocketServer(_logger);
  }

  void _logger(String message) {
    String time = DateTime.now().toString();
    setState(() {
      log.add(Text('[$time] : $message'));
    });
  }

  void _connect() async {
    await _server.connect(_IPAddress.text, int.parse(_Port.text), 'hil');
    setState(() {
      _isConnected = true;
    });
  }

  void _disconnect() {
    _server.disconnect();
    setState(() {
      _isConnected = false;
    });
  }

  void _clearLog() {
    setState(() {
      log.clear();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.grey[900],
        title: Text(
          'HARDWARE-IN-THE-LOOP TESTING',
          style: TextStyle(
            fontWeight: FontWeight.bold,
            fontFamily: 'Courier',
          ),
        ),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            TextField(
              controller: _IPAddress,
              decoration: InputDecoration(
                labelText: 'IP Address',
                border: OutlineInputBorder(
                  // Adds a border around the TextField
                  borderRadius: BorderRadius.zero,
                ),
                focusedBorder: OutlineInputBorder(
                  borderSide: BorderSide(
                    color: Colors.white, // Change the highlight color to white
                    width: 2.0, // You can adjust the width as needed
                  ),
                  borderRadius: BorderRadius.zero, // Ensure the corners match
                ),
              ),
            ),
            const SizedBox(height: 16),
            TextField(
              controller: _Port,
              decoration: const InputDecoration(
                labelText: 'Port',
                border: OutlineInputBorder(
                  // Adds a border around the TextField
                  borderRadius: BorderRadius.zero,
                ),
                focusedBorder: OutlineInputBorder(
                  borderSide: BorderSide(
                    color: Colors.white, // Change the highlight color to white
                    width: 2.0, // You can adjust the width as needed
                  ),
                  borderRadius: BorderRadius.zero, // Ensure the corners match
                ),
              ),
            ),
            const SizedBox(height: 16),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                ElevatedButton(
                  onPressed: _isConnected ? _disconnect : _connect,
                  style: ElevatedButton.styleFrom(
                    fixedSize: Size(200, 60),
                    textStyle: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      fontFamily: 'Courier',
                    ),
                    foregroundColor: Colors.white,
                    backgroundColor: _isConnected ? Colors.red : Colors.green,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.zero,
                      side: const BorderSide(
                        color: Colors.white,
                        width: 2.0,
                      ),
                    ),
                  ),
                  child: _isConnected ? Text("DISCONNECT") : Text('CONNECT'),
                ),
                ElevatedButton(
                  onPressed: () {},
                  style: ElevatedButton.styleFrom(
                    fixedSize: Size(200, 60),
                    textStyle: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      fontFamily: 'Courier',
                    ),
                    foregroundColor: Colors.white,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.zero,
                      side: const BorderSide(
                        color: Colors.white,
                        width: 2.0,
                      ),
                    ),
                  ),
                  child: Text("TEST"),
                ),
                ElevatedButton(
                  onPressed: _clearLog,
                  style: ElevatedButton.styleFrom(
                    fixedSize: Size(200, 60),
                    textStyle: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      fontFamily: 'Courier',
                    ),
                    foregroundColor: Colors.white,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.zero,
                      side: const BorderSide(
                        color: Colors.white, // Outline color
                        width: 2.0, // Outline thickness
                      ),
                    ),
                  ),
                  child: Text("CLEAR LOG"),
                ),
              ],
            ),
            const SizedBox(height: 16),
            Expanded(
              child: SizedBox(
                width: double.infinity,
                child: SingleChildScrollView(
                  scrollDirection: Axis.vertical,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: log,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
