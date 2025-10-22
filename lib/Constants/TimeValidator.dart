import 'package:flutter/material.dart';

class TimeValidator {
  // Static method to validate if chosen time is after the current time
  static bool isDateTimeAfterNow(DateTime chosenDateTime) {
    final now = DateTime.now();
    // Compare the chosen DateTime with the current DateTime
    if (chosenDateTime.isAfter(now)) {
      return true;
    }
    return false;
  }

  static bool isTimeAfterNow(TimeOfDay chosenTime) {
    final now = TimeOfDay.now();
    // Compare hours first, if equal, compare minutes
    if (chosenTime.hour > now.hour ||
        (chosenTime.hour == now.hour && chosenTime.minute > now.minute)) {
      return true;
    }
    return false;
  }

  static bool isFirstDateTimeAfterSecond(DateTime firstDateTime, DateTime secondDateTime) {
    // Compare the two DateTime objects
    if (firstDateTime.isAtSameMomentAs(secondDateTime) || firstDateTime.isAfter(secondDateTime)) {
      return true;
    }
    return false;
  }


  static bool isStartBeforeEnd(DateTime startDateTime, DateTime endDateTime) {
    return startDateTime.isBefore(endDateTime);
  }

}