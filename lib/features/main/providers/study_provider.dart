import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:chart_q/features/main/data/repositories/study_repository.dart';
import 'package:chart_q/features/main/domain/models/study.dart';

final studyRepositoryProvider = Provider((ref) => StudyRepository());

final studiesProvider = FutureProvider<List<Study>>((ref) async {
  final repository = ref.watch(studyRepositoryProvider);
  return repository.getStudies();
});

final studyProvider = FutureProvider.family<Study, String>((ref, id) async {
  final repository = ref.watch(studyRepositoryProvider);
  return repository.getStudy(id);
});
