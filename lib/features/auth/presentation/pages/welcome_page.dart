import 'package:chart_q/constants/style.dart';
import 'package:chart_q/core/auth/auth_provider.dart';
import 'package:chart_q/core/router/router.dart';
import 'package:chart_q/core/router/routes.dart';
import 'package:chart_q/core/utils/logger.dart';
import 'package:chart_q/core/utils/phone.dart';
import 'package:chart_q/shared/providers/scaffold_messenger_provider.dart';
import 'package:chart_q/shared/widgets/country_picker.dart';
import 'package:chart_q/shared/widgets/ui/button.dart';
import 'package:chart_q/shared/widgets/ui/input.dart';
import 'package:country_picker/country_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class WelcomePage extends ConsumerStatefulWidget {
  const WelcomePage({super.key});

  @override
  ConsumerState<WelcomePage> createState() => _WelcomePageState();
}

class _WelcomePageState extends ConsumerState<WelcomePage> {
  final _formKey = GlobalKey<FormState>();
  late TextEditingController _nicknameController;
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
      _nameController = TextEditingController(
        text: currentUser.userMetadata?['name'] ?? '',
      );
      _phoneController = TextEditingController(
        text: currentUser.userMetadata?['phone'] ?? '',
      );
    }
  }

  @override
  void dispose() {
    _nicknameController.dispose();
    _nameController.dispose();
    _phoneController.dispose();
    super.dispose();
  }

  void _passToNext() async {
    // 기본 닉네임은 이름으로 설정
    final result = await ref
        .read(authProvider.notifier)
        .updateUser(nickname: _nameController.text, isWelcomed: true);

    handleResponse(result);
  }

  void _handleSubmit() async {
    if (!_formKey.currentState!.validate()) return;
    // 입력된 정보 처리 로직 구현
    final response = await ref.read(authProvider.notifier).updateUser(
        name: _nameController.text,
        phone: PhoneUtils.formatPhoneNumber(_phoneController.text),
        nickname: _nicknameController.text,
        country: _country?.countryCode,
        isWelcomed: true);

    handleResponse(response);
  }

  void handleResponse(UserResponse response) {
    if (response.user == null) {
      ref.read(scaffoldMessengerKeyProvider).currentState?.showSnackBar(
            SnackBar(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              backgroundColor: AppColor.red,
              behavior: SnackBarBehavior.floating,
              duration: const Duration(seconds: 2),
              content: Text('프로필을 업데이트하는데 문제가 발생했습니다'),
            ),
          );
    } else {
      ref.read(routerProvider).replace(AppRoutes.home);
      ref.read(scaffoldMessengerKeyProvider).currentState?.showSnackBar(
            SnackBar(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              backgroundColor: AppColor.main,
              behavior: SnackBarBehavior.floating,
              duration: const Duration(seconds: 2),
              content: Text('프로필 업데이트 완료'),
            ),
          );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('환영합니다', style: AppText.h3),
      ),
      body: Padding(
        padding: EdgeInsets.fromLTRB(
            16.0, 16.0, 16.0, MediaQuery.of(context).padding.bottom + 16.0),
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
              CountryPicker(
                initialCountry: _country,
                onSelectCountry: (country) {
                  setState(() {
                    _country = country;
                  });
                },
              ),
              SizedBox(height: 16),
              Text('이름'),
              const SizedBox(height: 8),
              AppTextInput(
                controller: _nameController,
                hintText: '이름을 입력해주세요',
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
                          '나중에 하기',
                          style: AppText.three.copyWith(color: AppColor.black),
                        ),
                      ),
                      AppButtons.primary(
                        onPressed: _handleSubmit,
                        title: '완료',
                      ),
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
