import 'package:flutter/material.dart';
import 'package:mynotes/utils/dialogs/generic_dialog.dart';

Future<void> showErrorDialog(
  BuildContext context,
  String text,
) {
  return showGenericDialog<void>(
    context: context,
    title: "An Error Occured",
    contents: text,
    optionsBuilder: () => {
      'OK': null,
    },
  );
}
