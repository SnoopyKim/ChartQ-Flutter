import 'package:cached_network_image/cached_network_image.dart';
import 'package:chart_q/constants/style.dart';
import 'package:chart_q/core/router/router.dart';
import 'package:chart_q/features/main/domain/models/study.dart';
import 'package:chart_q/features/main/providers/study_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../tag.dart';

class StudyCard extends ConsumerWidget {
  final Study study;
  const StudyCard({super.key, required this.study});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Container(
      key: ValueKey(study.id),
      decoration: BoxDecoration(
        color: AppColor.white,
        border: Border.all(color: AppColor.bgGray),
        borderRadius: BorderRadius.circular(10),
        boxShadow: [
          BoxShadow(
            color: AppColor.gray.withOpacity(0.1),
            offset: Offset(0, 2),
            blurRadius: 10,
          )
        ],
      ),
      clipBehavior: Clip.hardEdge,
      child: GestureDetector(
        behavior: HitTestBehavior.translucent,
        onTap: () {
          ref.read(selectedStudyProvider.notifier).selectStudy(study);
          ref.read(routerProvider).push('/study/${study.id}');
        },
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              ClipRRect(
                borderRadius: BorderRadius.circular(6),
                child: Hero(
                  tag: 'image-${study.id}',
                  child: CachedNetworkImage(
                    imageUrl: study.image ?? '',
                    errorWidget: (context, url, error) => Image.asset(
                      'assets/images/placeholder.png',
                      height: 100,
                      width: 100,
                      fit: BoxFit.cover,
                    ),
                    height: 100,
                    width: 100,
                    fit: BoxFit.cover,
                  ),
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(study.title,
                        style: AppText.h2.copyWith(color: AppColor.black)),
                    Text('subtitle',
                        style: AppText.two.copyWith(color: AppColor.gray)),
                    const SizedBox(height: 8),
                    Wrap(
                      spacing: 8,
                      runSpacing: 6,
                      children: (study.tags ?? [])
                          .map((tag) => TagChip(tag: tag.name))
                          .toList(),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
