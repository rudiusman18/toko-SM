import 'package:flutter/material.dart';
import 'package:tokoSM/theme/theme.dart';

void showAlertDialog({
  required BuildContext context,
  required String message,
  required VoidCallback onCancelPressed,
  required Future<void> Function() onConfirmPressed,
}) {
  showDialog(
    context: context,
    builder: (BuildContext context) {
      return AlertDialog(
        title: Column(
          children: [
            Text(
              "Warning!",
              style: poppins.copyWith(
                color: backgroundColor1,
                fontWeight: semiBold,
              ),
              textAlign: TextAlign.center,
            ),
            Divider(
              thickness: 1,
              color: backgroundColor1,
            ),
          ],
        ),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10),
        ),
        alignment: Alignment.center,
        content: Text(
          message,
          style: poppins.copyWith(color: backgroundColor1),
          textAlign: TextAlign.center,
        ),
        actions: [
          TextButton(
            onPressed: onCancelPressed,
            child: Text(
              "Batal",
              style: poppins.copyWith(
                fontWeight: semiBold,
                color: backgroundColor1,
              ),
            ),
          ),
          TextButton(
            onPressed: onConfirmPressed,
            child: Text(
              "Lanjutkan",
              style: poppins.copyWith(
                fontWeight: semiBold,
                color: backgroundColor1,
              ),
            ),
          ),
        ],
      );
    },
  );
}
