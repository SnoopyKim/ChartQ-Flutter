import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:chart_q/features/main/providers/study_provider.dart';
import 'package:chart_q/shared/widgets/app_error_widget.dart';

class StudyScreen extends ConsumerWidget {
  const StudyScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final studiesAsync = ref.watch(studiesProvider);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        AppBar(
          title: Text(
            'Study',
            style: TextStyle(
                fontSize: 24, fontWeight: FontWeight.w600, height: 34 / 24),
          ),
          centerTitle: false,
        ),
        Expanded(
            child: SingleChildScrollView(
          child: studiesAsync.when(
            data: (studies) => ListView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              padding: const EdgeInsets.symmetric(horizontal: 16),
              itemCount: studies.length,
              itemBuilder: (context, index) {
                final study = studies[index];
                return Card(
                  margin: const EdgeInsets.only(bottom: 16),
                  child: InkWell(
                    onTap: () => context.go('/study/${study.id}'),
                    child: Padding(
                      padding: const EdgeInsets.all(16),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          if (study.image != null)
                            ClipRRect(
                              borderRadius: BorderRadius.circular(8),
                              child: Image.network(
                                study.image!,
                                height: 200,
                                width: double.infinity,
                                fit: BoxFit.cover,
                              ),
                            ),
                          const SizedBox(height: 12),
                          Text(
                            study.title,
                            style: const TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const SizedBox(height: 8),
                          // Text(study.description),
                          // const SizedBox(height: 8),
                          Text(
                            '${study.updatedAt.year}-${study.updatedAt.month}-${study.updatedAt.day}',
                            style: TextStyle(
                              color: Colors.grey[600],
                              fontSize: 12,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                );
              },
            ),
            error: (error, stack) => AppErrorWidget(
              message: error.toString(),
              onRetry: () => ref.refresh(studyRepositoryProvider),
            ),
            loading: () => const Center(
              child: CircularProgressIndicator(),
            ),
          ),
        ))
      ],
    );
  }
}
