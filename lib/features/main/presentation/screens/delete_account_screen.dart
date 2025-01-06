import 'package:chart_q/constants/style.dart';
import 'package:chart_q/core/auth/auth_provider.dart';
import 'package:chart_q/core/utils/dialogs.dart';
import 'package:chart_q/core/utils/logger.dart';
import 'package:chart_q/shared/widgets/ui/app_bar.dart';
import 'package:chart_q/shared/widgets/ui/button.dart';
import 'package:chart_q/shared/widgets/ui/checkbox.dart';
import 'package:flutter/material.dart' hide Checkbox;
import 'package:flutter_riverpod/flutter_riverpod.dart';

// 회원탈퇴 화면
class DeleteAccountScreen extends ConsumerWidget {
  const DeleteAccountScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      appBar: AppBars.back(title: "회원탈퇴", onBack: () => Navigator.pop(context)),
      body: LayoutBuilder(builder: (context, constraints) {
        return SingleChildScrollView(
          child: ConstrainedBox(
            constraints: BoxConstraints(
              minHeight: constraints.maxHeight,
            ),
            child: IntrinsicHeight(
              child: Padding(
                padding: EdgeInsets.fromLTRB(16.0, 16.0, 16.0,
                    16.0 + MediaQuery.of(context).padding.bottom),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    Text('정말 Chart Q를', style: AppText.h2),
                    Text('탈퇴하실건가요??',
                        style: AppText.h2.copyWith(color: AppColor.red)),
                    const SizedBox(height: 16),
                    _BulletListItem(text: '탈퇴 후 재가입 시에도 이용 내역은 복구되지 않습니다.'),
                    _BulletListItem(
                        text:
                            '탈퇴 고객의 개인정보는 관련 법령에 따라 일정 기간 안전하게 보관되며, 이후 자동 파기됩니다.'),
                    _BulletListItem(text: '계정 삭제 시 N일간 재 가입을 할 수 없습니다.'),
                    const SizedBox(height: 16),
                    const Spacer(flex: 1),
                    Text.rich(TextSpan(style: AppText.h2, children: [
                      TextSpan(
                          text: '탈퇴 이유',
                          style: TextStyle(color: AppColor.main)),
                      TextSpan(text: '을 알려주시면\n더 좋은 서비스로 다시 찾아뵐게요!')
                    ])),
                    const SizedBox(height: 8),
                    _CheckListItem(text: '신뢰도가 낮음'),
                    _CheckListItem(text: '비용이 너무 비쌈'),
                    _CheckListItem(text: '자주 사용하지 않음'),
                    _CheckListItem(text: '사용이 불편하거나 어려움'),
                    _CheckListItem(text: '다른 유사 서비스 이용'),
                    const Spacer(flex: 2),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        AppCheckbox(onChanged: (value) {}),
                        const SizedBox(width: 8),
                        Text('유의사항을 모두 확인했습니다',
                            style: AppText.three.copyWith(color: AppColor.gray))
                      ],
                    ),
                    const SizedBox(height: 16),
                    AppButtons.primary(
                        title: '탈퇴하기',
                        onPressed: () async {
                          bool result = await context.showConfirmDialog(
                              message: '정말 탈퇴하시겠습니까?\n탈퇴 후 N일간 다시 가입할 수 없습니다',
                              confirmText: '네, 탈퇴할게요');
                          if (result) {
                            // TODO: 탈퇴 로직 추가
                          }
                        })
                  ],
                ),
              ),
            ),
          ),
        );
      }),
    );
  }
}

class _BulletListItem extends StatelessWidget {
  final String text;
  const _BulletListItem({super.key, required this.text});

  @override
  Widget build(BuildContext context) {
    TextStyle style = AppText.three.copyWith(color: AppColor.gray);
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 8.0),
          child: Text('\u2022', style: style),
        ),
        Expanded(child: Text(text, style: style))
      ],
    );
  }
}

class _CheckListItem extends StatelessWidget {
  final String text;
  const _CheckListItem({super.key, required this.text});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Row(
        children: [
          AppCheckbox(onChanged: (value) {}),
          const SizedBox(width: 16),
          Expanded(child: Text(text, style: AppText.one))
        ],
      ),
    );
  }
}
