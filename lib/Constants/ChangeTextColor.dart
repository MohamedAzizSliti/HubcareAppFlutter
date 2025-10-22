import 'package:flutter/material.dart';

import 'ColorCodes.dart';

class ChangeTextColor {
  static Color getTextColor(String textToBeAssesed, bool boolValue) {
    if (boolValue) {
      //Logic to be checked if checkbox is clicked
      return AppColors.textColor;
    } else {
      //Logic to be checked if checkbox is unticked
      return Colors.grey;
    }
  }
}
