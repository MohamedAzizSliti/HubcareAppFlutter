import 'package:flutter/material.dart';

class CustomTextFormField extends StatelessWidget {
  final String? label;
  final String? hintText;
  final TextEditingController? controller;
  final TextInputType? keyboardType;
  final bool obscureText;
  final String? Function(String?)? validator;
  final void Function(String)? onChanged;
  final InputDecoration? decoration;
  final TextStyle? style;
  final bool autoFocus;

  const CustomTextFormField({
    Key? key,
    this.label,
    this.hintText,
    this.controller,
    this.keyboardType,
    this.obscureText = false,
    this.validator,
    this.onChanged,
    this.decoration,
    this.style,
    this.autoFocus = false,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: controller,
      keyboardType: keyboardType,
      obscureText: obscureText,
      validator: validator,
      onChanged: onChanged,
      autofocus: autoFocus,
      style: style,
      decoration: decoration ??
          InputDecoration(
            labelText: label,
            hintText: hintText,
            border: const OutlineInputBorder(),
          ),
    );
  }
}