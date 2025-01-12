import 'package:cached_network_image/cached_network_image.dart';
import 'package:chart_q/constants/asset.dart';
import 'package:chart_q/constants/style.dart';
import 'package:chart_q/core/router/router.dart';
import 'package:chart_q/core/utils/logger.dart';
import 'package:chart_q/features/main/providers/bookmark_provider.dart';
import 'package:chart_q/shared/widgets/tag.dart';
import 'package:chart_q/shared/widgets/ui/app_bar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:chart_q/features/main/providers/study_provider.dart';
import 'package:flutter_svg/svg.dart';
import 'package:flutter_widget_from_html/flutter_widget_from_html.dart';

class StudyDetailScreen extends ConsumerWidget {
  final String studyId;

  const StudyDetailScreen({
    super.key,
    required this.studyId,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final selectedStudy = ref.watch(selectedStudyProvider);
    final study = selectedStudy.value;

    final isBookmarked = ref.watch(isBookmarkedProvider(studyId));

    return Scaffold(
      appBar: AppBars.back(
        title: study?.title ?? "",
        onBack: () => ref.read(routerProvider).pop(),
        actions: [
          GestureDetector(
            onTap: () {
              if (study == null) return;
              if (isBookmarked) {
                ref.read(bookmarkIdProvider.notifier).removeBookmark(study.id);
              } else {
                ref.read(bookmarkIdProvider.notifier).addBookmark(study.id);
              }
            },
            child: SvgPicture.asset(
              isBookmarked ? AppAsset.bookmarkFilled : AppAsset.bookmark,
              width: 24,
              height: 24,
            ),
          ),
          const SizedBox(width: 8),
          GestureDetector(
            onTap: () {},
            child: SvgPicture.asset(AppAsset.export, width: 24, height: 24),
          ),
          const SizedBox(width: 16),
        ],
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Hero(
              tag: 'image-${study?.id}',
              child: CachedNetworkImage(
                imageUrl: study?.image ?? '',
                errorWidget: (context, url, error) => Image.asset(
                  'assets/images/placeholder.png',
                  height: 260,
                  width: double.infinity,
                  fit: BoxFit.cover,
                ),
                height: 260,
                width: double.infinity,
                fit: BoxFit.cover,
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    study?.title ?? '',
                    style: AppText.h2,
                  ),
                  Text(
                    '${study?.updatedAt.year}-${study?.updatedAt.month}-${study?.updatedAt.day}',
                    style: AppText.two.copyWith(color: AppColor.gray),
                  ),
                  const SizedBox(height: 8),
                  Wrap(
                    spacing: 8,
                    runSpacing: 6,
                    children: (study?.tags ?? [])
                        .map((tag) => TagChip(tag: tag.name))
                        .toList(),
                  ),
                  const SizedBox(height: 16),
                  HtmlWidget(
                    study?.content ?? '',
                    customStylesBuilder: (element) {
                      if (element.localName?.toLowerCase() == 'a') {
                        return {'color': 'rgb(59 130 246)'};
                      }
                      return null;
                    },
                    onTapUrl: (url) {
                      // TODO: 외부 링크 열기 or 웹뷰
                      print(url);
                      return true;
                    },
                    textStyle: AppText.two.copyWith(height: 1.4),
                  ),
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}
