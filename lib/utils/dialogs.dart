import 'package:flutter/material.dart';

class Dialogs {
  static void showLoadingDialog(BuildContext context) {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) => const Center(
        child: CircularProgressIndicator(),
      ),
    );
  }

  static void closeDialog(BuildContext context) {
    Navigator.of(context).pop();
  }
}
