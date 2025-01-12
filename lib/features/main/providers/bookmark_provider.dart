import 'package:chart_q/core/auth/auth_provider.dart';
import 'package:chart_q/core/utils/logger.dart';
import 'package:chart_q/features/main/data/repositories/bookmark_repository.dart';
import 'package:chart_q/features/main/data/repositories/study_repository.dart';
import 'package:chart_q/features/main/domain/models/study.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

/// 북마크 ID 목록 전용 Provider (AsyncNotifier)
final bookmarkIdProvider =
    AsyncNotifierProvider<BookmarkIdNotifier, List<String>>(
        () => BookmarkIdNotifier());

class BookmarkIdNotifier extends AsyncNotifier<List<String>> {
  // void init() {
  //   build();
  //   logger.d('init bookmarkIdProvider\n${state.value}');
  // }

  @override
  Future<List<String>> build() async {
    final userId = ref.read(authProvider.notifier).user?.id;
    if (userId == null) return [];
    return await BookmarkRepository().getBookmarks(userId);
  }

  Future<bool> addBookmark(String studyId) async {
    final userId = ref.read(authProvider.notifier).user?.id;
    if (userId == null) return false;

    final result = await BookmarkRepository().addBookmark(userId, studyId);
    if (result) {
      state = AsyncData([...state.value ?? [], studyId]);
    }
    return result;
  }

  Future<bool> removeBookmark(String studyId) async {
    final userId = ref.read(authProvider.notifier).user?.id;
    if (userId == null) return false;

    final result = await BookmarkRepository().removeBookmark(userId, studyId);
    if (result) {
      state = AsyncData((state.value ?? [])..remove(studyId));
    }
    return result;
  }
}

/// 북마크된 스터디 목록 전용 Provider (AsyncNotifier)
final bookmarkListProvider =
    AsyncNotifierProvider<BookmarkListNotifier, List<Study>>(() {
  return BookmarkListNotifier();
});

class BookmarkListNotifier extends AsyncNotifier<List<Study>> {
  List<Study> _cachedBookmarks = [];

  @override
  Future<List<Study>> build() async {
    final bookmarkIdsAsync = await ref.watch(bookmarkIdProvider.future);
    try {
      _cachedBookmarks =
          await StudyRepository().getStudiesByIds(bookmarkIdsAsync);
      return _cachedBookmarks;
    } catch (e) {
      logger.e('북마크 목록 조회 실패: $e');
      return _cachedBookmarks;
    }
  }
}

/// 북마크된 스터디 목록에서 태그로 필터링된 목록
final filteredBookmarkListProvider =
    Provider.family<List<Study>, int?>((ref, selectedTagId) {
  final bookmarks = ref.watch(bookmarkListProvider);
  return bookmarks.when(
    data: (studies) {
      // 선택된 태그가 없으면 모든 북마크 표시
      if (selectedTagId == null || selectedTagId == -1) {
        return studies;
      }
      return studies.where((study) {
        return study.tags?.any((tag) => tag.id == selectedTagId) ?? false;
      }).toList();
    },
    error: (_, __) => [],
    loading: () => [],
  );
});

/// 특정 스터디의 북마크 여부를 확인하는 Provider
final isBookmarkedProvider = Provider.family<bool, String>((ref, studyId) {
  final bookmarks = ref.watch(bookmarkIdProvider);
  logger.d(bookmarks.value);
  return bookmarks.valueOrNull?.contains(studyId) ?? false;
});
