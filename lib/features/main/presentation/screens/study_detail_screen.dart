import 'package:chart_q/shared/widgets/app_error_widget.dart';
import 'package:chart_q/shared/widgets/ui/app_bar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:chart_q/features/main/providers/study_provider.dart';
import 'package:flutter_widget_from_html/flutter_widget_from_html.dart';

class StudyDetailScreen extends ConsumerWidget {
  final String studyId;

  const StudyDetailScreen({
    super.key,
    required this.studyId,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final selectedStudy = ref.watch(selectedStudyProvider);
    final study = selectedStudy.value;

    return Scaffold(
      appBar: AppBars.back(
          title: study?.title ?? "", onBack: () => Navigator.pop(context)),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Hero(
              tag: 'image-${study?.id}',
              child: study?.image != null
                  ? Image.network(
                      study?.image ?? '',
                      height: 260,
                      width: double.infinity,
                      fit: BoxFit.cover,
                    )
                  : Image.asset(
                      'assets/images/placeholder.png',
                      height: 260,
                      width: double.infinity,
                      fit: BoxFit.cover,
                    ),
            ),
            Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    study?.title ?? '',
                    style: const TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                      height: 34 / 24,
                    ),
                  ),
                  Text(
                    '${study?.updatedAt.year}-${study?.updatedAt.month}-${study?.updatedAt.day}',
                    style: TextStyle(
                      color: Colors.grey[600],
                      fontSize: 14,
                    ),
                  ),
                  Wrap(
                    children: (study?.tags ?? [])
                        .map((tag) => Chip(
                              label: Text(tag.name,
                                  style:
                                      TextStyle(fontSize: 16, height: 26 / 16)),
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 6, vertical: 2),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(100),
                                side:
                                    BorderSide(color: const Color(0xFFDCDCDC)),
                              ),
                            ))
                        .toList(),
                  ),
                  const SizedBox(height: 16),
                  selectedStudy.when(
                    data: (study) => HtmlWidget(
                      study?.content ?? '',
                      customStylesBuilder: (element) {
                        if (element.localName?.toLowerCase() == 'a') {
                          return {'color': 'rgb(59 130 246)'};
                        }
                        return null;
                      },
                      onTapUrl: (url) {
                        print(url);
                        return true;
                      },
                      textStyle: const TextStyle(fontSize: 14),
                    ),
                    loading: () => const Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [CircularProgressIndicator()],
                    ),
                    error: (error, stack) =>
                        AppErrorWidget(message: error.toString()),
                  ),
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}
