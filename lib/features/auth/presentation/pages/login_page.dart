import 'package:chart_q/constants/style.dart';
import 'package:chart_q/core/router/router.dart';
import 'package:chart_q/core/router/routes.dart';
import 'package:chart_q/core/utils/asset.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:chart_q/core/auth/auth_provider.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:lottie/lottie.dart';

class LoginPage extends ConsumerStatefulWidget {
  const LoginPage({super.key});

  @override
  ConsumerState<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends ConsumerState<LoginPage> {
  // final _emailController = TextEditingController();
  // final _passwordController = TextEditingController();
  // final _formKey = GlobalKey<FormState>();

  @override
  void dispose() {
    // _emailController.dispose();
    // _passwordController.dispose();
    super.dispose();
  }

  // Future<void> _signIn() async {
  //   if (_formKey.currentState!.validate()) {
  //     try {
  //       await ref.read(authProvider.notifier).signIn(
  //             email: _emailController.text,
  //             password: _passwordController.text,
  //           );
  //     } catch (e) {
  //       if (mounted) {
  //         ScaffoldMessenger.of(context).showSnackBar(
  //           SnackBar(content: Text(e.toString())),
  //         );
  //       }
  //     }
  //   }
  // }

  Future<void> _signInWithGoogle() async {
    try {
      await ref.read(authProvider.notifier).signInWithGoogle();
      ref.read(routerProvider).go(AppRoutes.home);
    } catch (e) {
      _showError(e.toString());
    }
  }

  Future<void> _signInWithApple() async {
    try {
      await ref.read(authProvider.notifier).signInWithApple();
      ref.read(routerProvider).go(AppRoutes.home);
    } catch (e) {
      _showError(e.toString());
    }
  }

  Future<void> _signInWithFacebook() async {
    try {
      await ref.read(authProvider.notifier).signInWithFacebook();
      ref.read(routerProvider).go(AppRoutes.home);
    } catch (e) {
      _showError(e.toString());
    }
  }

  void _showError(String message) {
    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          backgroundColor: AppColor.red,
          duration: Duration(seconds: 3),
          behavior: SnackBarBehavior.floating,
          content: Text(message),
          dismissDirection: DismissDirection.vertical,
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(16),
          child: Column(
            children: [
              Lottie.asset(
                'assets/lottie/login.json',
                width: MediaQuery.of(context).size.width - 32,
                height: MediaQuery.of(context).size.width - 32,
                fit: BoxFit.contain,
              ),
              const SizedBox(height: 32),
              SvgPicture.asset(AppAsset.logoName),
              const SizedBox(height: 8),
              Text.rich(
                TextSpan(text: '20분에 평균 50문제 습득!\n', children: [
                  TextSpan(text: '차트', style: TextStyle(color: AppColor.main)),
                  TextSpan(text: '를 가장 많이 연습할 수 있는 '),
                  TextSpan(
                      text: '스터디 앱', style: TextStyle(color: AppColor.main))
                ]),
                style: AppText.three,
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 48),
              SnsButton(
                onTap: _signInWithGoogle,
                icon: AppAsset.google,
                text: 'Google로 시작하기',
                color: AppColor.white,
                textColor: AppColor.gray,
                borderColor: AppColor.lineGray,
              ),
              const SizedBox(height: 16),
              SnsButton(
                onTap: _signInWithApple,
                icon: AppAsset.apple,
                text: 'Apple로 시작하기',
                color: AppColor.bgBlack,
                textColor: AppColor.white,
              ),
              const SizedBox(height: 16),
              SnsButton(
                onTap: _signInWithFacebook,
                icon: AppAsset.facebook,
                text: 'Facebook로 시작하기',
                color: Color(0xff1877F2),
                textColor: AppColor.white,
              ),
              const SizedBox(height: 16),
            ],
          ),
        ),
      ),
    );
  }
}

class SnsButton extends StatelessWidget {
  const SnsButton({
    super.key,
    required this.onTap,
    required this.icon,
    required this.text,
    required this.color,
    required this.textColor,
    this.borderColor,
  });
  final VoidCallback onTap;
  final String icon;
  final String text;
  final Color color;
  final Color textColor;
  final Color? borderColor;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        height: 40,
        decoration: BoxDecoration(
          color: color,
          border: borderColor != null ? Border.all(color: borderColor!) : null,
          borderRadius: BorderRadius.circular(20),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            SvgPicture.asset(icon, width: 24, height: 24),
            const SizedBox(width: 10),
            Text(text, style: AppText.three.copyWith(color: textColor)),
          ],
        ),
      ),
    );
  }
}
