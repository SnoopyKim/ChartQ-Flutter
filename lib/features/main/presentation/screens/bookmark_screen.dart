import 'package:chart_q/core/router/router.dart';
import 'package:chart_q/features/main/providers/bookmark_provider.dart';
import 'package:chart_q/features/main/providers/tag_provider.dart';
import 'package:chart_q/shared/widgets/cards/bookmark_card.dart';
import 'package:chart_q/shared/widgets/tag.dart';
import 'package:chart_q/shared/widgets/ui/app_bar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class BookmarkScreen extends ConsumerWidget {
  const BookmarkScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final tags = ref.watch(tagListProvider);
    final selectedTag = ref.watch(selectedBookmarkTagProvider);
    final filteredBookmarks =
        ref.watch(filteredBookmarkListProvider(selectedTag));

    return Scaffold(
      appBar: AppBars.back(
        title: '즐겨찾기',
        onBack: () => ref.read(routerProvider).pop(),
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(48),
          child: SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            padding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
            child: Row(
              children: tags
                  .when(
                    data: (tags) => tags,
                    error: (_, __) => [],
                    loading: () => [],
                  )
                  .map((tag) => Padding(
                        padding: const EdgeInsets.only(left: 8.0),
                        child: TagChip(
                          tag: tag.name,
                          isSelected: selectedTag == tag.id,
                          onTap: () => ref
                              .read(selectedBookmarkTagProvider.notifier)
                              .state = tag.id,
                        ),
                      ))
                  .toList(),
            ),
          ),
        ),
      ),
      body: GridView.builder(
        padding: const EdgeInsets.all(16),
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
          mainAxisSpacing: 16,
          crossAxisSpacing: 16,
        ),
        itemBuilder: (context, index) =>
            BookmarkCard(study: filteredBookmarks[index]),
        itemCount: filteredBookmarks.length,
      ),
    );
  }
}
