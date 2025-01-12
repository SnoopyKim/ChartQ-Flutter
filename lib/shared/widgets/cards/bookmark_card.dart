import 'package:cached_network_image/cached_network_image.dart';
import 'package:chart_q/constants/style.dart';
import 'package:chart_q/core/router/router.dart';
import 'package:chart_q/core/router/routes.dart';
import 'package:chart_q/features/main/domain/models/study.dart';
import 'package:chart_q/features/main/providers/study_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class BookmarkCard extends ConsumerWidget {
  final Study study;
  const BookmarkCard({super.key, required this.study});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return GestureDetector(
      behavior: HitTestBehavior.translucent,
      onTap: () {
        ref.read(selectedStudyProvider.notifier).selectStudy(study);
        ref.read(routerProvider).push(AppRoutes.studyDetail(study.id));
      },
      child: Container(
        decoration: BoxDecoration(
          color: AppColor.white,
          borderRadius: BorderRadius.circular(10),
          boxShadow: [
            BoxShadow(
              color: AppColor.gray.withOpacity(0.1),
              offset: Offset(0, 2),
              blurRadius: 10,
            )
          ],
        ),
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            Expanded(
              child: AspectRatio(
                aspectRatio: 1,
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(12),
                  child: Hero(
                    tag: 'image-${study.id}',
                    child: CachedNetworkImage(
                      imageUrl: study.image ?? '',
                      errorWidget: (context, url, error) => Image.asset(
                        'assets/images/placeholder.png',
                        fit: BoxFit.cover,
                      ),
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
              ),
            ),
            const SizedBox(height: 8),
            Text(study.title, style: AppText.one),
            Text('SubTitle',
                style: AppText.four.copyWith(color: AppColor.gray)),
          ],
        ),
      ),
    );
  }
}
