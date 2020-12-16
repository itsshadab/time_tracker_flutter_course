abstract class StringValidator{
  bool isValid(String value);
}

class NonEmptyStringValidator implements StringValidator{
  @override
  bool isValid(String value){
    return value.isNotEmpty;
  }
}

class EmailAndPasswordValidator {
  final StringValidator emailValidator = NonEmptyStringValidator ();
  final StringValidator passwordValidator = NonEmptyStringValidator ();
  final String invalidEmailErrorText = 'Email Text can\'t be empty';
  final String invalidPasswordErrorText = 'Password Text can\'t be empty';
}