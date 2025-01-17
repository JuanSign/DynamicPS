import 'dart:math';

import 'package:flutter/material.dart';

class Joystick extends StatefulWidget {
  final double joystickSize;
  final double cursorSize;
  final String name;
  final Function(double, String) callback;

  const Joystick(
      {super.key,
      this.joystickSize = 100,
      this.cursorSize = 40,
      required this.name,
      required this.callback});

  @override
  // ignore: library_private_types_in_public_api
  _JoystickState createState() => _JoystickState();
}

class _JoystickState extends State<Joystick> {
  late final Function(double, String) _callback;
  late final String _name;

  late final double _joystickSize;
  late final double _cursorSize;
  late Offset _handlePosition;
  bool _isDragging = false;

  @override
  void initState() {
    super.initState();
    _callback = widget.callback;
    _name = widget.name;

    _joystickSize = widget.joystickSize;
    _cursorSize = widget.cursorSize;
    _handlePosition = Offset(_joystickSize, _joystickSize);
  }

  void _startDragging(DragStartDetails details) {
    final Offset dragPosition = details.localPosition;
    final double distance =
        (dragPosition - Offset(_joystickSize, _joystickSize)).distance;

    if (distance <= _cursorSize) _isDragging = true;
  }

  void _updatePosition(DragUpdateDetails details) {
    if (!_isDragging) return;
    setState(() {
      final Offset newPosition = details.localPosition;
      final angle =
          (newPosition - Offset(_joystickSize, _joystickSize)).direction;
      final double distance =
          (newPosition - Offset(_joystickSize, _joystickSize)).distance;

      _callback(angle, _name);

      if (distance <= _joystickSize - _cursorSize) {
        _handlePosition = newPosition;
      } else {
        _handlePosition = Offset(
          _joystickSize + (_joystickSize - _cursorSize) * cos(angle),
          _joystickSize + (_joystickSize - _cursorSize) * sin(angle),
        );
      }
    });
  }

  void _resetPosition() {
    setState(() {
      _handlePosition = Offset(_joystickSize, _joystickSize);
      _isDragging = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onPanStart: _startDragging,
      onPanUpdate: _updatePosition,
      onPanEnd: (_) => _resetPosition(),
      child: CustomPaint(
        size: Size(_joystickSize * 2, _joystickSize * 2),
        painter: JoystickPainter(_handlePosition, _joystickSize, _cursorSize),
      ),
    );
  }
}

class JoystickPainter extends CustomPainter {
  final Offset handlePosition;
  final double joystickSize;
  final double cursorSize;

  JoystickPainter(this.handlePosition, this.joystickSize, this.cursorSize);

  @override
  void paint(Canvas canvas, Size size) {
    final Paint basePaint = Paint()
      ..color = Colors.grey
      ..style = PaintingStyle.fill;

    final Paint handlePaint = Paint()
      ..color = const Color.fromARGB(255, 10, 90, 155)
      ..style = PaintingStyle.fill;

    canvas.drawCircle(
        Offset(joystickSize, joystickSize), joystickSize, basePaint);
    canvas.drawCircle(handlePosition, cursorSize, handlePaint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return true;
  }
}
