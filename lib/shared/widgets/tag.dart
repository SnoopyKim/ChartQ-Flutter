import 'package:flutter/material.dart';

import '../../constants/style.dart';

class TagChip extends StatelessWidget {
  final String tag;
  final bool isSelected;
  final VoidCallback? onTap;
  const TagChip({
    super.key,
    required this.tag,
    this.isSelected = false,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        height: 32,
        padding: const EdgeInsets.fromLTRB(12, 3, 12, 3),
        decoration: BoxDecoration(
          color: isSelected ? AppColor.main : AppColor.white,
          borderRadius: BorderRadius.circular(100),
          border:
              Border.all(color: isSelected ? AppColor.main : AppColor.lineGray),
        ),
        child: Text(tag,
            style: AppText.two
                .copyWith(color: isSelected ? AppColor.white : AppColor.black)),
      ),
    );
  }
}
