import 'package:flutter/material.dart';
import 'package:mynotes/utils/dialogs/generic_dialog.dart';

Future<bool> showDeleteDialog(BuildContext context) {
  return showGenericDialog<bool>(
    context: context,
    title: "Delete",
    contents: "Are you sure you want to delete this item?",
    optionsBuilder: () => {
      'Cancel': false,
      'yes': true,
    },
  ).then((value) => value ?? false);
}
