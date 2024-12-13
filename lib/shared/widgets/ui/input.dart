import 'package:chart_q/constants/style.dart';
import 'package:flutter/material.dart';

class AppTextInput extends TextFormField {
  AppTextInput({
    super.key,
    super.initialValue,
    super.controller,
    String? hintText,
    super.autovalidateMode = AutovalidateMode.disabled,
    super.enabled,
    super.validator,
    super.onChanged,
    super.onSaved,
    super.onFieldSubmitted,
    super.onTap,
    super.keyboardType,
    super.obscureText = false,
    super.maxLines = 1,
    super.maxLength,
    super.autofocus = false,
    super.readOnly,
  }) : super(
          decoration: InputDecoration(
            fillColor: enabled == false ? AppColor.bgGray : null,
            filled: enabled == false,
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(5),
              borderSide: BorderSide(
                color: AppColor.lineGray,
                width: 1,
                strokeAlign: BorderSide.strokeAlignInside,
              ),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(5),
              borderSide: BorderSide(
                color: AppColor.main,
                width: 1,
                strokeAlign: BorderSide.strokeAlignInside,
              ),
            ),
            errorBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(5),
              borderSide: BorderSide(
                color: AppColor.red,
                width: 1,
                strokeAlign: BorderSide.strokeAlignInside,
              ),
            ),
            disabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(5),
              borderSide: BorderSide(
                color: AppColor.lineGray,
                width: 1,
                strokeAlign: BorderSide.strokeAlignInside,
              ),
            ),
            hintText: hintText,
            hintStyle: AppText.two.copyWith(
              color: AppColor.gray,
            ),
            contentPadding: EdgeInsets.symmetric(
              horizontal: 12,
              vertical: 8,
            ),
          ),
          style: AppText.two.copyWith(
            color: enabled == false ? AppColor.gray : AppColor.black,
          ),
        );
}
