import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

Future<T?> showAdaptiveCustomDialog<T>({
  required BuildContext context,
  required String title,
  required String content,
  String confirmText = 'OK',
  String? cancelText,
  VoidCallback? onConfirm,
}) {
  final isIOS = defaultTargetPlatform == TargetPlatform.iOS;

  if (isIOS) {
    return showCupertinoDialog<T>(
      context: context,
      builder: (BuildContext ctx) => CupertinoAlertDialog(
        title: Text(title),
        content: Padding(
          padding: const EdgeInsets.only(top: 8.0),
          child: Text(content),
        ),
        actions: [
          if (cancelText != null)
            CupertinoDialogAction(
              onPressed: () => Navigator.of(ctx).pop(),
              child: Text(cancelText),
            ),
          CupertinoDialogAction(
            isDefaultAction: true,
            onPressed: () {
              Navigator.of(ctx).pop();
              onConfirm?.call();
            },
            child: Text(confirmText),
          ),
        ],
      ),
    );
  }

  return showDialog<T>(
    context: context,
    builder: (BuildContext ctx) => AlertDialog(
      title: Text(title),
      content: Text(content),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      actions: [
        if (cancelText != null)
          TextButton(
            onPressed: () => Navigator.of(ctx).pop(),
            child: Text(cancelText),
          ),
        FilledButton(
          onPressed: () {
            Navigator.of(ctx).pop();
            onConfirm?.call();
          },
          child: Text(confirmText),
        ),
      ],
    ),
  );
}

