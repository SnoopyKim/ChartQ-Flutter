import 'package:chart_q/core/supabase/supabase_client.dart';
import 'package:chart_q/features/main/domain/models/tag.dart';

class TagRepository {
  Future<List<Tag>> getTags() async {
    final response = await supabase.from('tag').select('*');
    return response.map((json) => Tag.fromJson(json)).toList();
  }
}
