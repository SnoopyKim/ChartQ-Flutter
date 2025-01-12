import 'package:chart_q/core/utils/logger.dart';
import 'package:chart_q/core/supabase/supabase_client.dart';
import 'package:chart_q/features/main/domain/models/study.dart';
import 'package:chart_q/features/main/domain/models/tag.dart';

class StudyRepository {
  Future<List<Study>> getAllStudies() async {
    final response = await supabase
        .from("study")
        .select("id, title, image, updated_at, study_tags(tag(*))")
        .order('updated_at', ascending: false);

    return response.map((json) {
      List<Tag> tags = json['study_tags']
          .map<Tag>((tag) => Tag.fromJson(tag['tag'] as Map<String, dynamic>))
          .toList();
      return Study.fromJson(json).copyWith(tags: tags);
    }).toList();
  }

  Future<List<Study>> getStudiesByTag(int tagId) async {
    final response = await supabase
        .from("study_tags")
        .select(
            "study(id, title, image, updated_at, study_tags(tag(*)))") // studies 테이블의 데이터를 가져옴
        .eq("tag_id", tagId);
    return response.map((json) {
      final studyData = json['study'];
      List<Tag> tags = studyData['study_tags']
          .map<Tag>((tag) => Tag.fromJson(tag['tag'] as Map<String, dynamic>))
          .toList();
      return Study.fromJson(studyData).copyWith(tags: tags);
    }).toList();
  }

  Future<Study> getStudy(String id) async {
    final response = await supabase
        .from('study')
        .select('*, study_tags(tag(*))')
        .eq('id', id);
    logger.d(response);
    return Study.fromJson(response.first).copyWith(
      tags: response.first['study_tags']
          .map<Tag>((tag) => Tag.fromJson(tag['tag'] as Map<String, dynamic>))
          .toList(),
    );
  }

  Future<String> getStudyContent(String id) async {
    final response =
        await supabase.from('study').select('content').eq('id', id);
    return response.first['content'] ?? '';
  }
}
