import 'package:chart_q/constants/style.dart';
import 'package:flutter/material.dart';

class BaseDialog extends StatelessWidget {
  final Widget child;
  final Widget action;
  const BaseDialog({super.key, required this.child, required this.action});

  @override
  Widget build(BuildContext context) {
    return Dialog(
      backgroundColor: AppColor.white,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(20),
      ),
      insetPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
      child: Padding(
        padding: const EdgeInsets.fromLTRB(16, 32, 16, 16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          mainAxisSize: MainAxisSize.min,
          children: [
            child,
            const SizedBox(height: 24),
            action,
          ],
        ),
      ),
    );
  }
}
