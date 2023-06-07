import 'package:flutter/material.dart';

class LoveButton extends StatefulWidget {
  const LoveButton({super.key,
    required this.normalColor,
    required this.pressedColor,
     required this.onPress,
     required this.unPressed,
     required this.isPressed});

  final Color normalColor;
  final Color pressedColor;
  final VoidCallback onPress;
  final VoidCallback unPressed;
  final bool isPressed;

  @override
  State<LoveButton> createState() => _LoveButtonState();
}

class _LoveButtonState extends State<LoveButton> {

  late bool isPressed;

  @override
  void initState() {
    isPressed=widget.isPressed;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return IconButton(
      constraints: const BoxConstraints(maxHeight: 36),
      padding: const EdgeInsets.all(4.0),
      iconSize: 20,
      color: isPressed?widget.pressedColor:widget.normalColor,
      onPressed: () {
        if (isPressed) {
          setState(() {
            isPressed = false;
          });
          widget.unPressed();
        } else {
          setState(() {
            isPressed = true;
          });
          widget.onPress();
        }
      },
      icon: const Icon(
        Icons.favorite,
      ),
    );
  }
}