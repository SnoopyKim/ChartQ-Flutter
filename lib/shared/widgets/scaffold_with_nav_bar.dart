import 'package:chart_q/constants/style.dart';
import 'package:chart_q/core/utils/logger.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:go_router/go_router.dart';

class ScaffoldWithNavBar extends StatelessWidget {
  ScaffoldWithNavBar({
    super.key,
    required this.child,
  });

  final Widget child;

  final List<Map<String, dynamic>> mainRoutes = [
    {
      'path': '/home',
      'label': 'Home',
      'icon': 'assets/icons/home.svg',
      'filledIcon': 'assets/icons/home-filled.svg',
    },
    {
      'path': '/study',
      'label': 'Study',
      'icon': 'assets/icons/study.svg',
      'filledIcon': 'assets/icons/study-filled.svg',
    },
    {
      'path': '/quiz',
      'label': 'Quiz',
      'icon': 'assets/icons/quiz.svg',
      'filledIcon': 'assets/icons/quiz-filled.svg',
    },
    {
      'path': '/profile',
      'label': 'Profile',
      'icon': 'assets/icons/profile.svg',
      'filledIcon': 'assets/icons/profile-filled.svg',
    },
  ];

  @override
  Widget build(BuildContext context) {
    final String location = GoRouterState.of(context).matchedLocation;

    return Scaffold(
      body: child,
      bottomNavigationBar: Container(
        height: 62 + MediaQuery.of(context).padding.bottom,
        decoration: BoxDecoration(
          color: AppColor.white,
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(40),
            topRight: Radius.circular(40),
          ),
          boxShadow: [
            AppShadow.nav,
          ],
        ),
        padding: EdgeInsets.only(
          top: 14,
          bottom: MediaQuery.of(context).padding.bottom + 4,
          left: 16,
          right: 16,
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: mainRoutes.map((route) {
            return Expanded(
              child: GestureDetector(
                behavior: HitTestBehavior.translucent,
                onTap: () => context.go(route['path']),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    SvgPicture.asset(
                      location.startsWith(route['path'])
                          ? route['filledIcon']
                          : route['icon'],
                      width: 24,
                      height: 24,
                    ),
                    Text(
                      route['label'],
                      style: location.startsWith(route['path'])
                          ? AppText.four.copyWith(color: AppColor.main)
                          : AppText.four.copyWith(color: AppColor.black),
                    ),
                  ],
                ),
              ),
            );
          }).toList(),
        ),
      ),
    );
  }
}
