import 'package:flutter/material.dart';

class CustomIconTextButton extends StatelessWidget {
  final String buttonText;
  final IconData buttonIcon;
  final Function function;
  const CustomIconTextButton(
      {Key? key,
      required this.buttonText,
      required this.buttonIcon,
      required this.function})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: TextButton.icon(
        icon: Icon(buttonIcon, color: Colors.black),
        label: Text(
          buttonText,
          style: const TextStyle(color: Colors.black),
        ),
        onPressed: function(),
      ),
    );
  }
}
