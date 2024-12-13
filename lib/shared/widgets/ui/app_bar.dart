import 'package:chart_q/constants/style.dart';
import 'package:flutter/material.dart';

class AppBars {
  static AppBar back({
    required String title,
    required VoidCallback onBack,
    List<Widget> actions = const [],
  }) {
    return AppBar(
      title: Text(title, style: AppText.one.copyWith(color: AppColor.black)),
      titleSpacing: 8,
      centerTitle: false,
      backgroundColor: AppColor.white,
      automaticallyImplyLeading: false,
      leading: GestureDetector(
        onTap: onBack,
        behavior: HitTestBehavior.translucent,
        child: Padding(
          padding: const EdgeInsets.only(left: 16.0),
          child: const Icon(
            Icons.arrow_back_ios_new,
            size: 14,
            color: AppColor.black,
          ),
        ),
      ),
      actions: actions,
      leadingWidth: 40,
      elevation: 0,
    );
  }
}
