import 'package:flutter/material.dart';

class CustomButton extends StatelessWidget {
  const CustomButton({super.key, required this.onPressed, required this.text});

  final Function() onPressed;
  final String text;

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: onPressed,
      style: ButtonStyle(
        backgroundColor:
        MaterialStateProperty.all<Color>(Colors.redAccent),
        padding: MaterialStateProperty.all<EdgeInsets>(
            const EdgeInsets.symmetric(vertical: 12, horizontal: 16)),
        shape: MaterialStateProperty.all<OutlinedBorder>(
            RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(4))),
      ),
      child: Text(
        text,
        style: const TextStyle(
          fontSize: 16,
          fontWeight: FontWeight.w600,
          color: Colors.white
        ),
      ),
    );
  }
}
