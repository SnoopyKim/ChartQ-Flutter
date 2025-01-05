import 'package:chart_q/constants/style.dart';
import 'package:chart_q/core/auth/auth_provider.dart';
import 'package:chart_q/core/router/router.dart';
import 'package:chart_q/core/router/routes.dart';
import 'package:chart_q/constants/asset.dart';
import 'package:chart_q/core/utils/dialogs.dart';
import 'package:chart_q/core/utils/logger.dart';
import 'package:chart_q/shared/providers/scaffold_messenger_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:go_router/go_router.dart';

class ProfileScreen extends ConsumerWidget {
  ProfileScreen({super.key});

  final menus = [
    {
      'title': '즐겨찾기',
      'icon': AppAsset.bookmark,
      'path': AppRoutes.profile,
    },
    {
      'title': '알림설정',
      'icon': AppAsset.alert,
      'path': AppRoutes.profile,
    },
    {
      'title': '뱃지',
      'icon': AppAsset.badge,
      'path': AppRoutes.profile,
    },
    {
      'title': '언어변경',
      'icon': AppAsset.translate,
      'path': AppRoutes.profile,
    },
    {
      'title': '1:1문의',
      'icon': AppAsset.help,
      'path': AppRoutes.profile,
    },
    {
      'title': '이용약관',
      'icon': AppAsset.terms,
      'path': AppRoutes.profile,
    },
  ];

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final user = ref.read(authProvider.notifier).user;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        AppBar(
          title: Text('Profile',
              style: AppText.h2.copyWith(color: AppColor.black)),
          centerTitle: false,
          actions: [
            IconButton(
                onPressed: () {},
                icon: SvgPicture.asset(AppAsset.alert, width: 24, height: 24))
          ],
          backgroundColor: AppColor.white,
          surfaceTintColor: AppColor.white,
        ),
        Expanded(
            child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  // Profile
                  GestureDetector(
                    onTap: () => context.go('/profile/edit'),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Stack(
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
                                foregroundImage: NetworkImage(
                                    user?.userMetadata?['avatar_url'] ?? ''),
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
                                child: SvgPicture.asset(AppAsset.setting,
                                    width: 24,
                                    height: 24,
                                    fit: BoxFit.none,
                                    colorFilter: const ColorFilter.mode(
                                        AppColor.gray, BlendMode.srcIn)),
                              ),
                            )
                          ],
                        ),
                        const SizedBox(height: 8),
                        Text(
                          user?.email ?? 'EMAIL',
                          style: AppText.three.copyWith(color: AppColor.black),
                        ),
                        Text(
                          user?.userMetadata?['chartq_nickname'] ?? 'NICKNAME',
                          style: AppText.three.copyWith(color: AppColor.black),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 8),
                  // Badges
                  Row(mainAxisAlignment: MainAxisAlignment.center, children: [
                    ColoredBox(
                        color: Colors.red,
                        child: SizedBox.square(dimension: 52)),
                    SizedBox(width: 12),
                    ColoredBox(
                        color: Colors.green,
                        child: SizedBox.square(dimension: 52)),
                    SizedBox(width: 12),
                    ColoredBox(
                        color: Colors.blue,
                        child: SizedBox.square(dimension: 52)),
                  ]),
                  const SizedBox(height: 16),
                  // Study Overview
                  Container(
                    decoration: BoxDecoration(
                      color: AppColor.white,
                      border: Border.all(
                        color: AppColor.bgGray, // 테두리 색상
                        width: 1, // 테두리 두께
                      ),
                      borderRadius: BorderRadius.circular(20),
                      boxShadow: [AppShadow.one],
                    ),
                    padding: EdgeInsets.all(16),
                    child: Row(
                      children: [
                        Expanded(
                            child: Column(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            SvgPicture.asset(AppAsset.study),
                            Padding(
                              padding:
                                  const EdgeInsets.only(top: 8.0, bottom: 2),
                              child: Text('총 학습 시간', style: AppText.three),
                            ),
                            Text.rich(TextSpan(
                                text: '212',
                                style: AppText.one,
                                children: [
                                  TextSpan(
                                    text: ' 분',
                                    style: AppText.three,
                                  )
                                ]))
                          ],
                        )),
                        Container(
                          width: 1,
                          height: 36,
                          color: AppColor.lineGray,
                          padding: EdgeInsets.symmetric(horizontal: 8),
                        ),
                        Expanded(
                            child: Column(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            SvgPicture.asset(AppAsset.quiz),
                            Padding(
                              padding:
                                  const EdgeInsets.only(top: 8.0, bottom: 2),
                              child: Text('총 퀴즈 풀이', style: AppText.three),
                            ),
                            Text.rich(TextSpan(
                                text: '5',
                                style: AppText.one,
                                children: [
                                  TextSpan(
                                    text: ' 개',
                                    style: AppText.three,
                                  )
                                ]))
                          ],
                        ))
                      ],
                    ),
                  ),
                  const SizedBox(height: 16),
                  Image.asset('assets/images/ad-banner-basic.png'),
                  const SizedBox(height: 16),
                  Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: menus
                        .map((menu) => InkWell(
                              borderRadius: BorderRadius.circular(8),
                              hoverColor: AppColor.white,
                              splashColor: AppColor.bgGray,
                              splashFactory: InkSparkle.splashFactory,
                              child: Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  children: [
                                    SvgPicture.asset(menu['icon']!,
                                        width: 24, height: 24),
                                    const SizedBox(width: 16),
                                    Expanded(
                                        child: Text(menu['title']!,
                                            style: AppText.one)),
                                    Icon(
                                      Icons.arrow_forward_ios,
                                      size: 24,
                                      color: AppColor.black,
                                    )
                                  ],
                                ),
                              ),
                              onTap: () {},
                            ) as Widget)
                        .toList(),
                  ),
                  const SizedBox(height: 16),
                  Row(
                    children: [
                      Container(
                        margin: const EdgeInsets.only(
                            top: 8.0, bottom: 24.0, left: 8.0),
                        decoration: BoxDecoration(
                          border: Border(
                              bottom:
                                  BorderSide(color: AppColor.gray, width: 0.5)),
                        ),
                        child: GestureDetector(
                          onTap: () async {
                            bool result = await context.showConfirmDialog(
                                message: '지금 그만하면 결과를 볼 수 없어요.\n종료할까요?',
                                confirmText: '계속하기',
                                cancelText: '그만하기');
                            if (result) {
                              await ref.read(authProvider.notifier).signOut();
                              ref.read(routerProvider).go(AppRoutes.login);
                            }
                          },
                          child: Text(
                            '로그아웃',
                            style: AppText.four
                                .copyWith(color: AppColor.gray, height: 1.2),
                          ),
                        ),
                      ),
                    ],
                  )
                ]),
          ),
        ))
      ],
    );
  }
}
