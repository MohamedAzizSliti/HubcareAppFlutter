import 'package:flutter/material.dart';

class AppInputDecorations {
  static InputDecoration getDefaultInputDecoration({
    String? label,
    String? hintText,
  }) {
    return InputDecoration(
      labelText: label,
      hintText: hintText,
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(8.0),
      ),
      contentPadding: const EdgeInsets.symmetric(vertical: 10, horizontal: 15),
    );
  }
}

class AppTextStyles {
  static const TextStyle inputTextStyle = TextStyle(
    fontSize: 16,
    color: Colors.black,
  );

// Add more styles as needed
}