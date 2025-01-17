import 'package:flutter/material.dart';
import 'package:hmi_control/components/joystick.dart';
import 'package:hmi_control/components/throttle.dart';
import 'package:hmi_control/utils/socket_server.dart';

class ControlPage extends StatefulWidget {
  const ControlPage({super.key});

  @override
  // ignore: library_private_types_in_public_api
  _ControlPageState createState() => _ControlPageState();
}

class _ControlPageState extends State<ControlPage> {
  late final SocketServer;
  bool _isConnected = false;

  @override
  Widget build(BuildContext context) {
    final appBar = AppBar(
      backgroundColor: Colors.grey[900],
      title: Text(
        'CONTROL',
        style: TextStyle(
          fontWeight: FontWeight.bold,
          fontFamily: 'Courier',
        ),
      ),
      centerTitle: true,
      actions: [
        ElevatedButton(
          onPressed: () {},
          style: ElevatedButton.styleFrom(
            fixedSize: Size(150, 40),
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
        SizedBox(width: 20),
      ],
    );
    final screenHeight = MediaQuery.of(context).size.height -
        (appBar.preferredSize.height + MediaQuery.of(context).padding.top);
    final screenWidth = MediaQuery.of(context).size.width;

    return Scaffold(
      appBar: appBar,
      body: Center(
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Column(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
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
                  child: Text("THRUSTER 1"),
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
                  child: Text("THRUSTER 2"),
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
                  child: Text("THRUSTER 3"),
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
                  child: Text("THRUSTER 4"),
                ),
              ],
            ),
            const SizedBox(width: 50),
            Throttle(
              name: "TES",
              throttleHeight: screenHeight * 4 / 5,
              baseWidth: screenWidth / 15,
              handleHeight: screenWidth / 30,
              callback: (_, __) {},
            ),
            const SizedBox(width: 50),
            Throttle(
              name: "TES",
              throttleHeight: screenHeight * 4 / 5,
              baseWidth: screenWidth / 15,
              handleHeight: screenWidth / 30,
              callback: (_, __) {},
            ),
            const SizedBox(width: 50),
            Throttle(
              name: "TES",
              throttleHeight: screenHeight * 4 / 5,
              baseWidth: screenWidth / 15,
              handleHeight: screenWidth / 30,
              callback: (_, __) {},
            ),
            const SizedBox(width: 50),
            Throttle(
              name: "TES",
              throttleHeight: screenHeight * 4 / 5,
              baseWidth: screenWidth / 15,
              handleHeight: screenWidth / 30,
              callback: (_, __) {},
            ),
            const SizedBox(width: 50),
            Joystick(
              name: "TES",
              joystickSize: screenWidth / 7,
              cursorSize: screenWidth / 25,
              callback: (_, __) {},
            )
          ],
        ),
      ),
    );
  }
}
