class TextFormFieldValidator {
  static String validateEmail(String email) {
    if (email.isEmpty)
      return 'Email can not be empty';
    else {
      final emailRegex = RegExp(
          r"^[a-zA-Z0-9.!#$%&'*+/=?^_`{|}~-]+@[a-zA-Z0-9](?:[a-zA-Z0-9-]{0,253}[a-zA-Z0-9])?(?:\.[a-zA-Z0-9](?:[a-zA-Z0-9-]{0,253}[a-zA-Z0-9])?)*$");
      if (emailRegex.hasMatch(email)) {
        if (email.contains('@ncirl.ie') ||
            email.contains('@student.ncirl.ie')) {
          return null;
        } else {
          return 'Not a valid NCI email ';
        }
      } else {
        return 'Not a valid NCI email ';
      }
    }
  }

  static String validateName(String name) {
    if (name.length > 20) {
      return 'Display name needs to be shorter then 20 characters';
    } else {
      final nameFieldRegEx = RegExp("^[A-Za-z0-9 ]+\$");
      if (nameFieldRegEx.hasMatch(name)) {
        return null;
      } else {
        return 'Name can only contain alpha-numeric characters';
      }
    }
  }

  static String validateMessage(String message) {
    if (message.length > 400) {
      return 'Message too long';
    } else {
      return null;
    }
  }

  static String validateUpdate(String update) {
    if (update.length > 200) {
      return 'Update too long';
    } else {
      return null;
    }
  }

  static String validatePassword(String password) {
    if (password.length > 8 && password.length < 128) {
      return null;
    } else {
      return 'Password needs to be between 8 - 128 characters long';
    }
  }
}
