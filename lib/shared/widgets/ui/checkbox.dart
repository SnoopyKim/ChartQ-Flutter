import 'package:chart_q/constants/asset.dart';
import 'package:chart_q/constants/style.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

class AppCheckbox extends StatefulWidget {
  final bool initialValue;
  final void Function(bool?) onChanged;
  const AppCheckbox(
      {super.key, this.initialValue = false, required this.onChanged});

  @override
  State<AppCheckbox> createState() => _AppCheckboxState();
}

class _AppCheckboxState extends State<AppCheckbox> {
  late bool isChecked;

  @override
  void initState() {
    super.initState();
    isChecked = widget.initialValue;
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        setState(() {
          isChecked = !isChecked;
        });
        widget.onChanged(isChecked);
      },
      child: Container(
        width: 20,
        height: 20,
        decoration: BoxDecoration(
          color: isChecked ? AppColor.main : AppColor.white,
          borderRadius: BorderRadius.circular(3),
          border: isChecked
              ? null
              : Border.all(color: AppColor.lineGray, width: 1.25),
        ),
        child: isChecked
            ? SvgPicture.asset(AppAsset.check,
                width: 10,
                colorFilter:
                    const ColorFilter.mode(AppColor.white, BlendMode.srcIn))
            : null,
      ),
    );
  }
}
