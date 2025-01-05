import 'package:chart_q/constants/style.dart';
import 'package:chart_q/core/auth/auth_provider.dart';
import 'package:chart_q/core/router/router.dart';
import 'package:chart_q/core/utils/dialogs.dart';
import 'package:chart_q/core/utils/phone.dart';
import 'package:chart_q/shared/providers/scaffold_messenger_provider.dart';
import 'package:chart_q/shared/widgets/country_picker.dart';
import 'package:chart_q/shared/widgets/ui/button.dart';
import 'package:chart_q/shared/widgets/ui/input.dart';
import 'package:country_picker/country_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class ProfileEditScreen extends ConsumerStatefulWidget {
  const ProfileEditScreen({super.key});

  @override
  ConsumerState<ProfileEditScreen> createState() => _ProfileEditScreenState();
}

class _ProfileEditScreenState extends ConsumerState<ProfileEditScreen> {
  final _formKey = GlobalKey<FormState>();
  final _nicknameKey = GlobalKey<FormFieldState>();
  late TextEditingController _nicknameController;
  late TextEditingController _nameController;
  late TextEditingController _phoneController;

  final _nicknameFocusNode = FocusNode();
  bool _isNicknameFocused = false;

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
    _nameController = TextEditingController(
      text: user?.userMetadata?['name'] ?? '',
    );
    _phoneController = TextEditingController(
      text: user?.userMetadata?['phone'] ?? '',
    );

    // 포커스 상태 변화 감지 리스너 등록
    _nicknameFocusNode.addListener(() {
      setState(() {
        _isNicknameFocused = _nicknameFocusNode.hasFocus;
        if (!_isNicknameFocused) {
          _nicknameKey.currentState?.validate();
        }
      });
    });
  }

  @override
  void dispose() {
    _nicknameController.dispose();
    _nameController.dispose();
    _phoneController.dispose();

    _nicknameFocusNode.dispose();

    super.dispose();
  }

  void _updateProfile() async {
    if (!_formKey.currentState!.validate()) return;
    bool result = await context.showConfirmDialog(message: '변경 사항을 저장할까요?');
    if (!result) return;

    await ref.read(authProvider.notifier).updateUser(
          nickname: _nicknameController.text,
          country: _country!.countryCode,
          name: _nameController.text,
          phone: PhoneUtils.formatPhoneNumber(
            _phoneController.text,
            countryCode: _country!.phoneCode,
          ),
        );

    ref.read(scaffoldMessengerKeyProvider).currentState?.showSnackBar(
          SnackBar(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
            backgroundColor: AppColor.main,
            showCloseIcon: true,
            behavior: SnackBarBehavior.floating,
            duration: Duration(seconds: 2),
            content: Text('프로필 정보가 업데이트되었습니다'),
            dismissDirection: DismissDirection.vertical,
          ),
        );
    ref.read(routerProvider).pop();
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
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Padding(
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
                      key: _nicknameKey,
                      controller: _nicknameController,
                      focusNode: _nicknameFocusNode,
                      hintText: '닉네임을 입력하세요',
                      // errorText: '이미 사용중인 닉네임이에요',
                      helperText: _isNicknameFocused
                          ? '닉네임은 특수문자 없이 3-12글자여야 합니다'
                          : null,
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return "닉네임을 입력하세요";
                        }
                        if (value.length < 3 || value.length > 12) {
                          return "닉네임은 3-12글자여야 합니다";
                        }
                        if (!nicknameRegex.hasMatch(value)) {
                          return "닉네임에 특수문자를 포함할 수 없습니다";
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
                          onPressed: _updateProfile,
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
            ColoredBox(
              color: AppColor.bgGray,
              child: SizedBox(height: 10),
            ),
            Row(
              children: [
                Container(
                  decoration: BoxDecoration(
                    border: Border(
                        bottom: BorderSide(color: AppColor.gray, width: 0.5)),
                  ),
                  margin: const EdgeInsets.fromLTRB(16.0, 16.0, 0.0, 0.0),
                  child: GestureDetector(
                    onTap: () {},
                    child: Text(
                      '회원탈퇴',
                      style: AppText.four
                          .copyWith(color: AppColor.gray, height: 1.2),
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
