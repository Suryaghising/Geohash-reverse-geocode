import 'package:flutter/material.dart';

class CustomTextField extends StatelessWidget {
  const CustomTextField({super.key, required this.hintText, this.controller, this.textInputAction, this.validator, this.obscureText, this.suffix, this.inputType});

  final String hintText;
  final TextEditingController? controller;
  final TextInputAction? textInputAction;
  final String? Function(String?)? validator;
  final bool? obscureText;
  final Widget? suffix;
  final TextInputType? inputType;

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: controller,
      style: Theme.of(context).textTheme.bodyMedium,
      textInputAction: textInputAction,
      obscureText: obscureText ?? false,
      keyboardType: inputType,
      decoration: InputDecoration(
        border: const OutlineInputBorder(borderSide: BorderSide(color: Colors.black)),
        focusedBorder: const OutlineInputBorder(borderSide: BorderSide(color: Colors.black)),
        hintStyle: Theme.of(context).textTheme.bodyMedium?.copyWith(color: Colors.grey.withOpacity(0.4)),
        suffixIcon: suffix,
        hintText: hintText,
      ),
      validator: validator,
    );
  }
}
