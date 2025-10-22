import 'package:flutter/material.dart';

import 'ColorCodes.dart';

class InputField {

  InputDecoration inputDecoration(var hint, Color baseColor, Color borderColor) {
    return InputDecoration(
      hintText: hint,
      hintStyle: TextStyle(
          fontSize: 14, color: AppColors.fontGrayColors),
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(7),
        borderSide: BorderSide(
          width: 0,
          color: borderColor.withOpacity(.5),
          style: BorderStyle.none,
        ),
      ),
      enabledBorder: OutlineInputBorder(
        borderSide: BorderSide(
            color: borderColor.withOpacity(.5),
            width: 1.0),
        borderRadius: BorderRadius.circular(7.0),
      ),
      focusedBorder: OutlineInputBorder(
        borderSide: BorderSide(
            color: borderColor.withOpacity(.5),
            width: 1.0),
        borderRadius: BorderRadius.circular(7.0),
      ),
      filled: true,
      fillColor: baseColor.withOpacity(.1),
      contentPadding: const EdgeInsets.all(7),

    );
  }
}