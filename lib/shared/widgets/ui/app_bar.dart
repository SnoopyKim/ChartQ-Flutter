import 'package:chart_q/constants/asset.dart';
import 'package:chart_q/constants/style.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class AppBars {
  static AppBar back({
    required String title,
    required VoidCallback onBack,
    List<Widget> actions = const [],
  }) {
    return AppBar(
      title: Text(title, style: AppText.one.copyWith(color: AppColor.black)),
      titleSpacing: 2,
      centerTitle: false,
      backgroundColor: AppColor.white,
      surfaceTintColor: AppColor.white,
      automaticallyImplyLeading: false,
      leading: GestureDetector(
        onTap: onBack,
        behavior: HitTestBehavior.translucent,
        child: Padding(
            padding: const EdgeInsets.only(left: 16.0),
            child: SvgPicture.asset(AppAsset.arrowLeft, width: 24, height: 24)),
      ),
      actions: actions,
      leadingWidth: 40,
      elevation: 0,
    );
  }
}
