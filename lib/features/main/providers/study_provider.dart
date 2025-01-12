import 'package:chart_q/core/utils/logger.dart';
import 'package:chart_q/features/main/domain/models/tag.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:chart_q/features/main/data/repositories/study_repository.dart';
import 'package:chart_q/features/main/domain/models/study.dart';
import 'package:chart_q/features/main/providers/tag_provider.dart';

// 전체 Study 목록을 관리하는 provider
final studyListProvider =
    AsyncNotifierProvider<StudyListNotifier, List<Study>>(() {
  return StudyListNotifier();
});

class StudyListNotifier extends AsyncNotifier<List<Study>> {
  @override
  Future<List<Study>> build() async {
    final selectedTag = ref.watch(selectedStudyTagProvider);
    return _fetchStudies(selectedTag);
  }

  Future<List<Study>> _fetchStudies(int selectedTagId) async {
    state = const AsyncValue.loading();
    try {
      if (selectedTagId == -1) {
        return await StudyRepository().getAllStudies();
      } else {
        return await StudyRepository().getStudiesByTag(selectedTagId);
      }
    } catch (error) {
      logger.e('Error fetching studies', error: error);
      return [];
    }
  }

  Future<void> searchStudies(String keyword) async {
    state = const AsyncValue.loading();
    final data = await _fetchStudies(ref.watch(selectedStudyTagProvider));
    if (keyword.isEmpty) {
      state = AsyncValue.data(data);
      return;
    }
    try {
      final searchedStudies = data.where((study) {
        return study.title.contains(keyword);
      }).toList();
      state = AsyncValue.data(searchedStudies);
    } catch (error, stackTrace) {
      state = AsyncValue.error(error, stackTrace);
    }
  }
}

// 선택된 Study의 상세 정보를 관리하는 provider
final selectedStudyProvider =
    AsyncNotifierProvider<SelectedStudyNotifier, Study?>(() {
  return SelectedStudyNotifier();
});

class SelectedStudyNotifier extends AsyncNotifier<Study?> {
  @override
  Future<Study?> build() async {
    return null;
  }

  Future<void> selectStudy(Study study) async {
    state = AsyncValue.data(study);
    try {
      // state = const AsyncValue.loading();
      final content = await StudyRepository().getStudyContent(study.id);
      state = AsyncValue.data(study.copyWith(content: content));
    } catch (error, stackTrace) {
      logger.e('Error fetching study content',
          error: error, stackTrace: stackTrace);
      state = AsyncValue.data(study.copyWith(content: ''));
    }
  }

  void clearSelectedStudy() {
    state = const AsyncValue.data(null);
  }
}
