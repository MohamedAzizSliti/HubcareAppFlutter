class Validation {
  static bool validateEmail1(String value) {
    final RegExp regex = RegExp(
        r'^(([^<>()[\]\\.,;:\s@\"]+(\.[^<>()[\]\\.,;:\s@\"]+)*)| (\".+\"))@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\])|(([a-zA-Z\-0-9]+\.)+[a-zA-Z]{2,}))$');
    if (!regex.hasMatch(value)) {
      return true;
    } else {
      return false;
    }
  }

  static bool validatePassword1(String value) {
    if (value.length < 6 && (value.length > 10)) {
      return true;
    } else {
      return false;
    }
  }

  String validatePassword(String value) {
    if (value.isEmpty) {
      return "* Required";
    } else if (value.length < 6) {
      return "Password should be atleast 6 characters";
    } else if (value.length > 10) {
      return "Password should not be greater than 10 characters";
    } else
      return "null";
  }

  String? validateName(String value) {
    if (value.length < 3) {
      return 'First name must be more than 3 charaters';
    } else {
      return null;
    }
  }

  String? validateAddress(String value) {
    if (value.length < 3) {
      return 'Address can not be empty';
    } else {
      return null;
    }
  }

  String? validateCPF(String value) {
    if (value.length < 3) {
      return 'CPF can not be empty';
    } else {
      return null;
    }
  }

  String? validateMobile(String value) {
    if (value.length != 10) {
      return 'Mobile mumber must be of 10 digit';
    } else {
      return null;
    }
  }

  String? validateEmail(String value) {
    if (value != null || value.isNotEmpty) {
      final RegExp regex = RegExp(
          r'^(([^<>()[\]\\.,;:\s@\"]+(\.[^<>()[\]\\.,;:\s@\"]+)*)| (\".+\"))@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\])|(([a-zA-Z\-0-9]+\.)+[a-zA-Z]{2,}))$');
      if (!regex.hasMatch(value)) {
        return 'Enter a valid email';
      } else {
        return null;
      }
    } else {
      return 'Enter a valid email';
    }
  }

  String? validatedPassword(String value) {
    if (value.trim().length < 6) {
      return 'Password must be 6 character length';
    } else {
      return null;
    }
  }

  String? validateConPassword(String pass, String conpass) {
    print(pass);
    print(conpass);

    if (pass != conpass) {
      return 'Password and confirm password must be eqauls';
    } else {
      return null;
    }
  }
}
