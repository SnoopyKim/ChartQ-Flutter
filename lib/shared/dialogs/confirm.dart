import 'package:chart_q/constants/style.dart';
import 'package:chart_q/core/router/router.dart';
import 'package:chart_q/shared/widgets/ui/button.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'base.dart';

class ConfirmDialog extends StatelessWidget {
  final String message;
  final String confirmText;
  final String cancelText;
  const ConfirmDialog({
    super.key,
    required this.message,
    required this.confirmText,
    required this.cancelText,
  });

  @override
  @override
  Widget build(BuildContext context) {
    return BaseDialog(
      child: Text(message, style: AppText.three, textAlign: TextAlign.center),
      action: Consumer(
        builder: (_, ref, __) {
          return Row(
            children: [
              Expanded(
                child: AppButtons.outline(
                  title: cancelText,
                  onPressed: () => ref.read(routerProvider).pop(false),
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: AppButtons.primary(
                  title: confirmText,
                  onPressed: () => ref.read(routerProvider).pop(true),
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}
