import 'package:flutter/material.dart';
import 'package:hmi_control/pages/hil_page.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.grey[900],
        title: Text(
          'DYNAMIC POSITIONING SYSTEM',
          style: TextStyle(
            fontWeight: FontWeight.bold,
            fontFamily: 'Courier',
          ),
        ),
        centerTitle: true,
      ),
      body: Center(
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            ElevatedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const HilPage()),
                );
              },
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
              child: Text('H.I.L'),
            ),
            SizedBox(width: 20),
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
                    color: Colors.white, // Outline color
                    width: 2.0, // Outline thickness
                  ),
                ),
              ),
              child: Text('CONTROL'),
            ),
          ],
        ),
      ),
    );
  }
}
