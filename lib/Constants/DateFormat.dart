import 'package:intl/intl.dart';
class DateFormatter{
  const DateFormatter();


  String formatDateString(String dateString) {
    // Parse the date string to a DateTime object
    DateTime dateTime = DateTime.parse(dateString);

    // Format the DateTime object to the desired format
    String formattedDate = DateFormat('dd/MM/yyyy').format(dateTime);

    return formattedDate;
  }

  String formatTimeString(String timeString) {
    // Parse the time string to a DateTime object
    DateTime dateTime = DateFormat("HH:mm:ss").parse(timeString);

    // Format the DateTime object to the desired 12-hour format with AM/PM
    String formattedTime = DateFormat('hh:mm a').format(dateTime);

    return formattedTime;
  }

}