import 'package:flutter/material.dart';

class NumKeyboardKey extends StatefulWidget {
  final dynamic label;
  final dynamic value;
  final ValueSetter<dynamic> onTap;

  const NumKeyboardKey({
    super.key,
    @required this.label,
    @required this.value,
    required this.onTap,
  });

  @override
  State<NumKeyboardKey> createState() => _NumKeyboardKeyState();
}

class _NumKeyboardKeyState extends State<NumKeyboardKey> {
  renderLabel() {
    if (widget.label is Widget) {
      return widget.label;
    }

    return Text(
      widget.label,
      style: const TextStyle(
        fontSize: 30.0,
        fontWeight: FontWeight.bold,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        widget.onTap(widget.value);
      },
      child: AspectRatio(
        aspectRatio: 2, // 넓이 / 높이 = 2
        child: Center(
          child: renderLabel(),
        ),
      ),
    );
  }
}
