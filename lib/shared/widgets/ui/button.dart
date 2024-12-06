import 'package:chart_q/constants/style.dart';
import 'package:flutter/material.dart';

class AppButtons {
  static Widget primary({
    required String title,
    required VoidCallback onPressed,
    bool disabled = false,
  }) {
    return FilledButton(
      onPressed: disabled ? null : onPressed,
      style: FilledButton.styleFrom(
        backgroundColor: AppColor.main,
        foregroundColor: AppColor.white,
        disabledBackgroundColor: AppColor.bgGray,
        disabledForegroundColor: AppColor.gray,
        padding: EdgeInsets.symmetric(
          horizontal: 20,
          vertical: 8,
        ),
        alignment: Alignment.center,
      ),
      child: Text(title, style: AppText.two),
    );
  }

  static Widget outline({
    required String title,
    required VoidCallback onPressed,
    bool disabled = false,
  }) {
    return OutlinedButton(
      onPressed: disabled ? null : onPressed,
      style: OutlinedButton.styleFrom(
        backgroundColor: AppColor.white,
        foregroundColor: AppColor.black,
        side: BorderSide(color: AppColor.lineGray),
        padding: EdgeInsets.symmetric(
          horizontal: 20,
          vertical: 8,
        ),
      ),
      child: Text(title, style: AppText.two),
    );
  }

  static Widget text({
    required String title,
    required VoidCallback onPressed,
    bool disabled = false,
  }) {
    return GestureDetector(
      onTap: disabled ? null : onPressed,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 4),
        child: Text(
          title,
          style: AppText.three.copyWith(
            color: disabled ? AppColor.gray : AppColor.black,
          ),
        ),
      ),
    );
  }
}
