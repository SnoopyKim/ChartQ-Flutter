import 'package:chart_q/core/utils/logger.dart';
import 'package:chart_q/core/supabase/supabase_client.dart';
import 'package:chart_q/features/main/domain/models/study.dart';

class StudyRepository {
  Future<List<Study>> getStudies() async {
    final response = await supabase
        .from('study')
        .select()
        .order('updated_at', ascending: false);

    return response.map((json) => Study.fromJson(json)).toList();
  }

  Future<Study> getStudy(String id) async {
    final response = await supabase.from('study').select().eq('id', id);
    logger.d(response);
    return Study.fromJson(response.first);
  }
}
