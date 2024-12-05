import 'package:chart_q/core/auth/auth_provider.dart';
import 'package:chart_q/core/utils/logger.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class WelcomePage extends ConsumerStatefulWidget {
  const WelcomePage({super.key});

  @override
  ConsumerState<WelcomePage> createState() => _WelcomePageState();
}

class _WelcomePageState extends ConsumerState<WelcomePage> {
  final _formKey = GlobalKey<FormState>();
  final _nicknameController = TextEditingController();
  final _countryController = TextEditingController();
  final _nameController = TextEditingController();
  final _phoneController = TextEditingController();

  @override
  void initState() {
    super.initState();
    final currentUser = ref.read(authProvider.notifier).user;
    if (currentUser != null) {
      _nicknameController.text = currentUser.userMetadata?['name'] ?? '';
      _nameController.text = currentUser.userMetadata?['name'] ?? '';
      _phoneController.text = currentUser.phone ?? '';
    }
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
    ref.read(authProvider.notifier).updateUser(additional: {
      'is_welcome_done': true,
    });
  }

  void _handleSubmit() async {
    if (_formKey.currentState!.validate()) {
      // 입력된 정보 처리 로직 구현
      final result = await ref.read(authProvider.notifier).updateUser(
          name: _nameController.text,
          phone: _phoneController.text,
          nickname: _nicknameController.text,
          additional: {
            'is_welcome_done': true,
          });
      if (result.user == null) {
        logger.e('Failed to update user');
      } else {
        logger.d(
            'Success to update user [Welcome Done: ${result.user?.userMetadata?['chartq']['is_welcome_done']}]');
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
            children: [
              TextFormField(
                controller: _nicknameController,
                decoration: const InputDecoration(
                  labelText: '닉네임',
                  hintText: '사용하실 닉네임을 입력해주세요',
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return '닉네임을 입력해주세요';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _nameController,
                decoration: const InputDecoration(
                  labelText: '이름',
                  hintText: '이름을 입력해주세요',
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return '이름을 입력해주세요';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _phoneController,
                decoration: const InputDecoration(
                  labelText: '전화번호',
                  hintText: '전화번호를 입력해주세요',
                ),
                keyboardType: TextInputType.phone,
              ),
              const SizedBox(height: 24),
              TextButton(
                onPressed: _passToNext,
                child: const Text('다음에 하기'),
              ),
              ElevatedButton(
                onPressed: _handleSubmit,
                child: const Text('완료'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
