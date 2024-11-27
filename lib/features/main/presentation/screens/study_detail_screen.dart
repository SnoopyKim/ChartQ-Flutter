import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:chart_q/features/main/providers/study_provider.dart';
import 'package:chart_q/shared/widgets/app_error_widget.dart';

class StudyDetailScreen extends ConsumerWidget {
  final String studyId;

  const StudyDetailScreen({
    super.key,
    required this.studyId,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final studyAsync = ref.watch(studyProvider(studyId));

    return Scaffold(
      appBar: AppBar(
        title: studyAsync.when(
          data: (study) => Text(study.title,
              style: const TextStyle(
                  fontSize: 16, fontWeight: FontWeight.bold, height: 26 / 16)),
          error: (_, __) => const Text('스터디 상세화면'),
          loading: () => const Text('로딩중...'),
        ),
        titleSpacing: 0,
        centerTitle: false,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new),
          iconSize: 16,
          onPressed: () => Navigator.pop(context),
        ),
        leadingWidth: 40,
        elevation: 0,
      ),
      body: studyAsync.when(
        data: (study) => SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              if (study.image != null)
                Image.network(
                  study.image!,
                  height: 200,
                  width: double.infinity,
                  fit: BoxFit.cover,
                ),
              Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      study.title,
                      style: const TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                        height: 34 / 24,
                      ),
                    ),
                    Text(
                      '${study.updatedAt.year}-${study.updatedAt.month}-${study.updatedAt.day}',
                      style: TextStyle(
                        color: Colors.grey[600],
                        fontSize: 14,
                      ),
                    ),
                    const SizedBox(height: 16),
                    Text(study.content ?? ''),
                  ],
                ),
              )
            ],
          ),
        ),
        error: (error, stack) => AppErrorWidget(
          message: error.toString(),
          onRetry: () => ref.refresh(studyProvider(studyId)),
        ),
        loading: () => const Center(
          child: CircularProgressIndicator(),
        ),
      ),
    );
  }
}
