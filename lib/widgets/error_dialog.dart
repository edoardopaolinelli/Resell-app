import 'package:flutter/material.dart';

void showErrorDialog(
    String initialMessage, BuildContext context, String error) {
  String errorMessage = initialMessage;
  if (error.contains('EMAIL_NOT_FOUND')) {
    errorMessage = 'There\'s no user with that email.';
  } else if (error.contains('EMAIL_EXISTS')) {
    errorMessage = 'This email address is already in use.';
  } else if (error.contains('INVALID_EMAIL')) {
    errorMessage = 'This is not a valid email.';
  } else if (error.contains('INVALID_PASSWORD')) {
    errorMessage = 'This is not a valid password.';
  }
  showDialog(
    context: context,
    builder: (context) => AlertDialog(
      title: const Text('An error occurred!'),
      content: Text('$error\n\n$errorMessage'),
      actions: [
        TextButton(
          onPressed: () => Navigator.of(context).pop(),
          child: const Text('Ok'),
        ),
      ],
    ),
  );
}
