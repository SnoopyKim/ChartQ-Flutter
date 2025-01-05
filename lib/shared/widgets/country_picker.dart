import 'package:chart_q/constants/style.dart';
import 'package:chart_q/constants/asset.dart';
import 'package:country_picker/country_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

import 'ui/input.dart';

class CountryPicker extends StatefulWidget {
  const CountryPicker(
      {super.key, this.initialCountry, required this.onSelectCountry});

  final Country? initialCountry;
  final Function(Country) onSelectCountry;

  @override
  State<CountryPicker> createState() => _CountryPickerState();
}

class _CountryPickerState extends State<CountryPicker> {
  late Country _country;
  final _countryController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _country = widget.initialCountry ?? Country.worldWide;
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _countryController.text =
          '${_country.flagEmoji} ${_country.getTranslatedName(context)}';
    });
  }

  @override
  void dispose() {
    _countryController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AppTextInput(
      controller: _countryController,
      readOnly: true,
      hintText: '국가를 선택해주세요',
      validator: (_) {
        if (_country == Country.worldWide) {
          return "Country cannot be empty";
        }
        return null;
      },
      onTap: () {
        showCountryPicker(
          context: context,
          useSafeArea: true,
          useRootNavigator: true,
          favorite: ['KR', 'US'],
          countryFilter: [
            'KR', // 한국
            'US', // 미국
            'JP', // 일본
            'CN', // 중국
            'GB', // 영국
            'DE', // 독일
            'FR', // 프랑스
            'IT', // 이탈리아
            'CA', // 캐나다
            'AU', // 호주
            'SG', // 싱가포르
            'IN', // 인도
          ],
          countryListTheme: CountryListThemeData(
            bottomSheetHeight: MediaQuery.of(context).size.height * 0.8,
            borderRadius: BorderRadius.circular(10),
            flagSize: 20,
            textStyle: AppText.three.copyWith(color: AppColor.black),
            searchTextStyle: AppText.two.copyWith(color: AppColor.black),
            inputDecoration: InputDecoration(
              prefixIcon: Padding(
                padding: const EdgeInsets.all(12.0),
                child: SvgPicture.asset(
                  AppAsset.search,
                  colorFilter: const ColorFilter.mode(
                    AppColor.gray,
                    BlendMode.srcIn,
                  ),
                ),
              ),
              hintText: '국가를 선택해주세요',
              hintStyle: AppText.two.copyWith(color: AppColor.gray),
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
              contentPadding: EdgeInsets.symmetric(
                horizontal: 12,
                vertical: 8,
              ),
            ),
          ),
          onSelect: (Country country) {
            setState(() {
              _country = country;
              _countryController.text =
                  '${_country.flagEmoji} ${_country.getTranslatedName(context)}';
            });
            widget.onSelectCountry(country);
          },
        );
      },
    );
  }
}
