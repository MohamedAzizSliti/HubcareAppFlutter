class SplitString{

  String getFirstPartOfAddress(String address) {
    // Find the index of the first comma
    int commaIndex = address.indexOf(',');

    // If there is a comma, return the substring before it
    if (commaIndex != -1) {
      return address.substring(0, commaIndex).trim();
    }

    // If no comma is found, return the whole string
    return address;
  }

  String getRemainingPartOfAddress(String address) {
    // Find the index of the first comma
    int commaIndex = address.indexOf(',');

    // If there is a comma, return the substring after it
    if (commaIndex != -1 && commaIndex + 1 < address.length) {
      return address.substring(commaIndex + 1).trim();
    }

    // If no comma is found or it's at the end, return an empty string
    return '';
  }

}