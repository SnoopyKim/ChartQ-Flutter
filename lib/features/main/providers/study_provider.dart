import 'package:chart_q/core/utils/logger.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:chart_q/features/main/data/repositories/study_repository.dart';
import 'package:chart_q/features/main/domain/models/study.dart';

final studyRepositoryProvider = Provider((ref) => StudyRepository());

// 전체 Study 목록을 관리하는 provider
final studyListProvider =
    AsyncNotifierProvider<StudyListNotifier, List<Study>>(() {
  return StudyListNotifier();
});

class StudyListNotifier extends AsyncNotifier<List<Study>> {
  @override
  Future<List<Study>> build() async {
    return _fetchStudies();
  }

  Future<List<Study>> _fetchStudies() async {
    final repository = ref.read(studyRepositoryProvider);
    return repository.getAllStudies();
  }

  Future<void> filterByTag(String tagId) async {
    state = const AsyncValue.loading();
    try {
      final repository = ref.read(studyRepositoryProvider);
      final studies = await repository.getStudiesByTag(tagId);
      state = AsyncValue.data(studies);
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
      state = const AsyncValue.loading();
      final repository = ref.read(studyRepositoryProvider);
      final content = await repository.getStudyContent(study.id);
      state = AsyncValue.data(study.copyWith(content: content));
    } catch (error, stackTrace) {
      state = AsyncValue.error(error, stackTrace);
    }
  }

  void clearSelectedStudy() {
    state = const AsyncValue.data(null);
  }
}

// 선택된 태그를 관리하는 provider
final selectedTagProvider = StateProvider<String?>((ref) => null);
