// BuildContext Extension
import 'package:chart_q/core/router/router.dart';
import 'package:chart_q/shared/dialogs/confirm.dart';
import 'package:flutter/material.dart';

class Dialogs {
  static Future<T?> showConfirmDialog<T>({
    required BuildContext context,
    required String message,
    String? confirmText,
    String? cancelText,
  }) {
    return showDialog<T>(
      context: context,
      builder: (_) => ConfirmDialog(
        message: message,
        confirmText: confirmText ?? '네',
        cancelText: cancelText ?? '아니오',
      ),
    );
  }
}

extension CustomDialogExt on BuildContext {
  Future<T?> showConfirmDialog<T>({
    required String message,
    String? confirmText,
    String? cancelText,
  }) {
    return Dialogs.showConfirmDialog(
      context: this,
      message: message,
      confirmText: confirmText,
      cancelText: cancelText,
    );
  }
}
