import 'package:chart_q/constants/style.dart';
import 'package:chart_q/core/auth/auth_provider.dart';
import 'package:chart_q/core/utils/logger.dart';
import 'package:chart_q/core/utils/phone.dart';
import 'package:chart_q/shared/widgets/ui/button.dart';
import 'package:chart_q/shared/widgets/ui/input.dart';
import 'package:country_picker/country_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class WelcomePage extends ConsumerStatefulWidget {
  const WelcomePage({super.key});

  @override
  ConsumerState<WelcomePage> createState() => _WelcomePageState();
}

class _WelcomePageState extends ConsumerState<WelcomePage> {
  final _formKey = GlobalKey<FormState>();
  late TextEditingController _nicknameController;
  late TextEditingController _countryController;
  late TextEditingController _nameController;
  late TextEditingController _phoneController;

  late Country? _country;

  // 유니코드 정규식: 구두점과 기호를 제외한 문자만 허용
  final RegExp nicknameRegex = RegExp(r'^[^\p{P}\p{S}]+$', unicode: true);

  @override
  void initState() {
    super.initState();
    final currentUser = ref.read(authProvider.notifier).user;
    _country = Country.tryParse(currentUser?.userMetadata?['country'] ?? 'KR');

    if (currentUser != null) {
      _nicknameController = TextEditingController(
        text: currentUser.userMetadata?['name'] ?? '',
      );
      _countryController = TextEditingController();
      _nameController = TextEditingController(
        text: currentUser.userMetadata?['name'] ?? '',
      );
      _phoneController = TextEditingController(
        text: currentUser.userMetadata?['phone'] ?? '',
      );
    }

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

  void _passToNext() async {
    ref
        .read(authProvider.notifier)
        .updateUser(nickname: _nicknameController.text, isWelcomed: true);
  }

  void _handleSubmit() async {
    if (_formKey.currentState!.validate()) {
      // 입력된 정보 처리 로직 구현
      final result = await ref.read(authProvider.notifier).updateUser(
          name: _nameController.text,
          phone: PhoneUtils.formatPhoneNumber(_phoneController.text),
          nickname: _nicknameController.text,
          isWelcomed: true);
      if (result.user == null) {
        logger.e('Failed to update user');
      } else {
        logger.d(
            'Success to update user [Welcome Done: ${result.user?.userMetadata?['chartq_is_welcomed']}]');
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('환영합니다'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
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
              const SizedBox(height: 16),
              Expanded(
                child: Align(
                  alignment: Alignment.bottomCenter,
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      TextButton(
                        onPressed: _passToNext,
                        child: Text(
                          '다음에 하기',
                          style: AppText.three.copyWith(color: AppColor.black),
                        ),
                      ),
                      AppButtons.primary(
                        onPressed: _handleSubmit,
                        title: '완료',
                      ),
                      const SizedBox(height: 16),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
