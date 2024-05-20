import 'package:flutter/material.dart';

class PinContainer extends StatelessWidget {
  const PinContainer({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.only(
        bottom: 40,
      ),
      child: Image.asset(
        'assets/pin.png',
        height: 40,
        width: 40,
      ),
    );
  }
}
