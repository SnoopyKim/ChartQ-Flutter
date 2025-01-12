import 'dart:developer';

import 'package:chart_q/constants/asset.dart';
import 'package:chart_q/constants/style.dart';
import 'package:chart_q/features/main/providers/tag_provider.dart';
import 'package:chart_q/shared/widgets/cards/study_card.dart';
import 'package:chart_q/shared/widgets/tag.dart';
import 'package:chart_q/shared/widgets/ui/input.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:chart_q/features/main/providers/study_provider.dart';
import 'package:chart_q/shared/widgets/app_error_widget.dart';
import 'package:flutter_svg/flutter_svg.dart';

class StudyScreen extends ConsumerWidget {
  const StudyScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final studyListState = ref.watch(studyListProvider);
    final tagListState = ref.watch(tagListProvider);
    final selectedTag = ref.watch(selectedTagProvider);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Padding(
          padding: EdgeInsets.fromLTRB(
              16, MediaQuery.of(context).padding.top + 16, 16, 16),
          child: Row(
            children: [
              Text('Study', style: AppText.h2),
            ],
          ),
        ),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: AppTextInput(
            hintText: '검색',
            onFieldSubmitted: (value) {
              ref.read(studyListProvider.notifier).searchStudies(value);
            },
            onTapOutside: (event) => FocusScope.of(context).unfocus(),
            prefixIcon: Padding(
              padding: const EdgeInsets.only(left: 16, right: 8),
              child: SvgPicture.asset(
                AppAsset.search,
                height: 24,
                width: 24,
                colorFilter:
                    const ColorFilter.mode(AppColor.gray, BlendMode.srcIn),
              ),
            ),
          ),
        ),
        Container(
          height: 64,
          decoration: BoxDecoration(
            color: AppColor.white,
            boxShadow: [
              BoxShadow(
                color: AppColor.gray.withOpacity(0.1),
                offset: Offset(0, 4),
                blurRadius: 4,
              ),
            ],
          ),
          child: tagListState.when(
            data: (tags) => SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              padding: const EdgeInsets.all(16),
              child: Row(
                children: tags
                    .map<Widget>((tag) => Padding(
                          padding: const EdgeInsets.only(left: 8.0),
                          child: TagChip(
                            tag: tag.name,
                            isSelected: selectedTag.id == tag.id,
                            onTap: () => ref
                                .read(selectedTagProvider.notifier)
                                .state = tag,
                          ),
                        ))
                    .toList(),
              ),
            ),
            loading: () => const SizedBox.shrink(),
            error: (error, stack) => AppErrorWidget(
              message: error.toString(),
              onRetry: () => ref.refresh(tagListProvider),
            ),
          ),
        ),
        Expanded(
          child: studyListState.when(
            data: (studies) => ListView.separated(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
              itemCount: studies.length,
              itemBuilder: (context, index) {
                final study = studies[index];
                return StudyCard(study: study);
              },
              separatorBuilder: (context, index) => const SizedBox(height: 16),
            ),
            error: (error, stack) => AppErrorWidget(
              message: error.toString(),
              onRetry: () => ref.refresh(studyListProvider),
            ),
            loading: () => const Padding(
              padding: EdgeInsets.only(top: 16),
              child: Center(
                  child: CircularProgressIndicator(color: AppColor.main)),
            ),
          ),
        ),
      ],
    );
  }
}
