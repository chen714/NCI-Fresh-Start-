import 'package:flutter_test/flutter_test.dart';
import 'package:flash_chat/validators/textFormFieldValidators.dart';

void main() {
  test('Check for empty password field', () {
    var result = TextFormFieldValidator.validatePassword('');
    expect(result, 'Password needs to be between 8 - 128 characters long');
  });

  test('Check for filled password field', () {
    var result = TextFormFieldValidator.validatePassword('sfhvsRsa,.*&');
    expect(result, null);
  });
  test('Check max length', () {
    var result = TextFormFieldValidator.validatePassword(
        '1234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890');
    expect(result, 'Password needs to be between 8 - 128 characters long');
  });
  test('Check max length class update', () {
    var result = TextFormFieldValidator.validateUpdate(
        'Lorem ipsum dolor sit amet, consectetuer adipiscing elit. Aenean commodo ligula eget dolor. Aenean massa. Cum sociis natoque penatibus et magnis dis parturient montes, nascetur ridiculus mus. Donec qu hsvhvxsh ');
    expect(result, 'Update too long');
  });
  test('Check class update', () {
    var result = TextFormFieldValidator.validateUpdate(
        'Lorem ipsum dolor sit amet, consectetuer adipiscing elit. Aenean commodo ligula eget dolor. Aenean massa. Cum sociis natoque penatibus et magnis dis parturient montes, nascetur ridiculus mus. Donec q');
    expect(result, null);
  });
  test('Check max length message', () {
    var result = TextFormFieldValidator.validateMessage(
        'Lorem ipsum dolor sit amet, consectetuer adipiscing elit. Aenean commodo ligula eget dolor. Aenean massa. Cum sociis natoque penatibus et magnis dis parturient montes, nascetur ridiculus mus. Donec quam felis, ultricies nec, pellentesque eu, pretium quis, sem. Nulla consequat massa quis enim. Donec pede justo, fringilla vel, aliquet nec, vulputate eget, arcu. In enim justo, rhoncus ut, imperdiet a,');
    expect(result, 'Message too long');
  });
  test('Check message validator', () {
    var result = TextFormFieldValidator.validateMessage(
        'Lorem ipsum dolor sit amet, consectetuer adipiscing elit. Aenean commodo ligula eget dolor. Aenean massa. Cum sociis natoque penatibus et magnis dis parturient montes, nascetur ridiculus mus. Donec quam felis, ultricies nec, pellentesque eu, pretium quis, sem. Nulla consequat massa quis enim. Donec pede justo, fringilla vel, aliquet nec, vulputate eget, arcu. In enim justo, rhoncus ut, imperdie');
    expect(result, null);
  });
  test('Check name max length', () {
    var result = TextFormFieldValidator.validateName('Lorem ipsum 1234r sit');
    expect(result, 'Display name needs to be shorter then 20 characters');
  });
  test('Check name illegal characters', () {
    var result = TextFormFieldValidator.validateName('Lorem ipsum &&+');
    expect(result, 'Name can only contain alpha-numeric characters');
  });
  test('Check name', () {
    var result = TextFormFieldValidator.validateName('ychen000');
    expect(result, null);
  });
  test('Check email format', () {
    var result = TextFormFieldValidator.validateEmail('@ncirl.ie@ncirl.ie');
    expect(result, 'Not a valid NCI email ');
  });
  test('Check email nci', () {
    var result =
        TextFormFieldValidator.validateEmail('yuzhangchen0714@gmail.com');
    expect(result, 'Not a valid NCI email ');
  });
  test('Check email', () {
    var result =
        TextFormFieldValidator.validateEmail('x16336066@student.ncirl.ie');
    var result1 = TextFormFieldValidator.validateEmail('ychen000@ncirl.ie');
    expect(result, null);
    expect(result1, null);
  });
  test('Check is faculty illegal email format ', () {
    var result = TextFormFieldValidator.isFaculty('@ncirl.ie@ncirl.ie');
    expect(result, false);
  });
  test('Check is faculty ', () {
    var result = TextFormFieldValidator.isFaculty('ychen000@ncirl.ie');
    expect(result, true);
  });
}
