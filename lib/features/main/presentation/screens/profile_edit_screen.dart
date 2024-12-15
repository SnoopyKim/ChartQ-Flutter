import 'package:chart_q/constants/style.dart';
import 'package:chart_q/core/auth/auth_provider.dart';
import 'package:chart_q/core/utils/logger.dart';
import 'package:chart_q/core/utils/phone.dart';
import 'package:chart_q/shared/widgets/ui/button.dart';
import 'package:chart_q/shared/widgets/ui/input.dart';
import 'package:country_picker/country_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_svg/flutter_svg.dart';

class ProfileEditScreen extends ConsumerStatefulWidget {
  const ProfileEditScreen({super.key});

  @override
  ConsumerState<ProfileEditScreen> createState() => _ProfileEditScreenState();
}

class _ProfileEditScreenState extends ConsumerState<ProfileEditScreen> {
  final _formKey = GlobalKey<FormState>();
  late TextEditingController _nicknameController;
  late TextEditingController _countryController;
  late TextEditingController _nameController;
  late TextEditingController _phoneController;

  late String? _avatarUrl;
  late Country? _country;

  // 유니코드 정규식: 구두점과 기호를 제외한 문자만 허용
  final RegExp nicknameRegex = RegExp(r'^[^\p{P}\p{S}]+$', unicode: true);

  @override
  void initState() {
    super.initState();
    final user = ref.read(authProvider.notifier).user;

    _avatarUrl = user?.userMetadata?['avatar_url'];
    _country = Country.tryParse(user?.userMetadata?['country'] ?? 'KR');

    _nicknameController = TextEditingController(
      text: user?.userMetadata?['chartq_nickname'] ?? '',
    );
    _countryController = TextEditingController();
    _nameController = TextEditingController(
      text: user?.userMetadata?['name'] ?? '',
    );
    _phoneController = TextEditingController(
      text: user?.userMetadata?['phone'] ?? '',
    );

    WidgetsBinding.instance.addPostFrameCallback((_) {
      _countryController.text =
          '${_country?.flagEmoji} ${_country?.getTranslatedName(context)}';
    });
  }

  @override
  void dispose() {
    _nicknameController.dispose();
    _countryController.dispose();
    _nameController.dispose();
    _phoneController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('프로필 설정'),
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('내 정보', style: AppText.one),
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 16.0),
                  child: GestureDetector(
                    onTap: () {
                      // 프로필 이미지 변경
                    },
                    child: Stack(
                      children: [
                        Container(
                          width: 52,
                          height: 52,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            border: Border.all(
                              color: AppColor.lineGray,
                              width: 1.0,
                            ),
                          ),
                          child: CircleAvatar(
                            radius: 25,
                            backgroundColor: AppColor.bgGreen,
                            foregroundColor: AppColor.main,
                            foregroundImage: NetworkImage(_avatarUrl ?? ''),
                            child: Icon(
                              Icons.person_outline,
                              size: 24,
                            ),
                          ),
                        ),
                        Positioned(
                          right: 0,
                          bottom: 0,
                          child: Container(
                            width: 20,
                            height: 20,
                            decoration: BoxDecoration(
                              color: AppColor.bgGray,
                              shape: BoxShape.circle,
                            ),
                            child: Icon(
                              Icons.settings_outlined,
                              size: 20,
                              color: AppColor.gray,
                            ),
                          ),
                        )
                      ],
                    ),
                  ),
                ),
                Text('닉네임'),
                const SizedBox(height: 8),
                AppTextInput(
                  controller: _nicknameController,
                  hintText: '3글자 이상으로 입력해주세요',
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return "Nickname cannot be empty";
                    }
                    if (value.length < 3 || value.length > 12) {
                      return "Nickname must be 3-12 characters long";
                    }
                    if (!nicknameRegex.hasMatch(value)) {
                      return "Nickname cannot contain punctuation or symbols";
                    }
                    return null;
                  },
                ),
                SizedBox(height: 16),
                Text('국가'),
                const SizedBox(height: 8),
                AppTextInput(
                  controller: _countryController,
                  readOnly: true,
                  hintText: '국가를 선택해주세요',
                  validator: (_) {
                    if (_country == null) {
                      return "Country cannot be empty";
                    }
                    return null;
                  },
                  onTap: () {
                    showCountryPicker(
                      context: context,
                      useSafeArea: true,
                      useRootNavigator: true,
                      countryFilter: ['KR', 'US', 'JP', 'CN'],
                      countryListTheme: CountryListThemeData(
                        bottomSheetHeight:
                            MediaQuery.of(context).size.height * 0.8,
                        borderRadius: BorderRadius.circular(10),
                        textStyle: AppText.two,
                        inputDecoration: InputDecoration(
                          hintText: '국가를 선택해주세요',
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
                              '${_country?.flagEmoji} ${_country?.getTranslatedName(context)}';
                        });
                      },
                    );
                  },
                ),
                SizedBox(height: 16),
                Text('이름'),
                const SizedBox(height: 8),
                AppTextInput(
                  controller: _nameController,
                  hintText: '이름을 입력해주세요',
                  enabled: false,
                ),
                SizedBox(height: 16),
                Text('전화번호'),
                const SizedBox(height: 8),
                AppTextInput(
                  controller: _phoneController,
                  hintText: '전화번호를 입력해주세요',
                  keyboardType: TextInputType.phone,
                ),
                SizedBox(height: 16),
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    AppButtons.primary(
                      title: '저장',
                      onPressed: () {
                        if (_formKey.currentState!.validate()) {
                          ref.read(authProvider.notifier).updateUser(
                              nickname: _nicknameController.text,
                              country: _country!.countryCode,
                              name: _nameController.text,
                              phone: PhoneUtils.formatPhoneNumber(
                                _phoneController.text,
                                countryCode: _country!.phoneCode,
                              ));
                        }
                      },
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
