import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:chart_q/features/main/providers/study_provider.dart';
import 'package:chart_q/shared/widgets/app_error_widget.dart';

class StudyScreen extends ConsumerWidget {
  const StudyScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final studyListState = ref.watch(studyListProvider);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        AppBar(
          backgroundColor: Theme.of(context).colorScheme.surface,
          surfaceTintColor: Colors.transparent,
          title: Text(
            'Study',
            style: TextStyle(
                fontSize: 24, fontWeight: FontWeight.w600, height: 34 / 24),
          ),
          centerTitle: false,
          elevation: 0,
        ),
        Container(
          width: double.infinity,
          decoration: BoxDecoration(
            color: Theme.of(context).colorScheme.surface,
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.05),
                offset: Offset(0, 2),
                blurRadius: 1,
              ),
            ],
          ),
          child: SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Row(
              children: [
                Chip(
                  label: Text('전체',
                      style: TextStyle(fontSize: 16, height: 26 / 16)),
                  padding:
                      const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(100),
                    side: BorderSide(color: const Color(0xFFDCDCDC)),
                  ),
                ),
              ],
            ),
          ),
        ),
        Expanded(
          child: studyListState.when(
            data: (studies) => SingleChildScrollView(
              child: ListView.builder(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                padding:
                    const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
                itemCount: studies.length,
                itemBuilder: (context, index) {
                  final study = studies[index];
                  return Card(
                      key: ValueKey(study.id),
                      elevation: 0,
                      clipBehavior: Clip.hardEdge,
                      margin: const EdgeInsets.symmetric(vertical: 8),
                      child: InkWell(
                        onTap: () {
                          ref
                              .read(selectedStudyProvider.notifier)
                              .selectStudy(study);
                          context.go('/study/${study.id}');
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
                                  child: study.image != null
                                      ? Image.network(
                                          study.image!,
                                          height: 100,
                                          width: 100,
                                          fit: BoxFit.cover,
                                        )
                                      : Image.asset(
                                          'assets/images/placeholder.png',
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
                                    Text(
                                      study.title,
                                      style: const TextStyle(
                                        fontSize: 24,
                                        fontWeight: FontWeight.w600,
                                        height: 34 / 24,
                                      ),
                                    ),
                                    Row(
                                      children: (study.tags ?? [])
                                          .map((tag) => Chip(
                                                label: Text(tag.name,
                                                    style: TextStyle(
                                                        fontSize: 16,
                                                        height: 26 / 16)),
                                                padding:
                                                    const EdgeInsets.symmetric(
                                                        horizontal: 6,
                                                        vertical: 2),
                                                shape: RoundedRectangleBorder(
                                                  borderRadius:
                                                      BorderRadius.circular(
                                                          100),
                                                  side: BorderSide(
                                                      color: const Color(
                                                          0xFFDCDCDC)),
                                                ),
                                              ))
                                          .toList(),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                      ));
                },
              ),
            ),
            error: (error, stack) => AppErrorWidget(
              message: error.toString(),
              onRetry: () => ref.refresh(studyRepositoryProvider),
            ),
            loading: () => const Center(
              child: CircularProgressIndicator(),
            ),
          ),
        ),
      ],
    );
  }
}
