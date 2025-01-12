import 'package:chart_q/core/supabase/supabase_client.dart';
import 'package:chart_q/core/utils/logger.dart';

class BookmarkRepository {
  Future<List<String>> getBookmarks(String userId) async {
    final response = await supabase
        .from('bookmarks')
        .select('study_id')
        .eq('user_id', userId);
    return response.map((json) => json['study_id'] as String).toList();
  }

  Future<bool> addBookmark(String userId, String studyId) async {
    try {
      await supabase.from('bookmarks').insert({
        'user_id': userId,
        'study_id': studyId,
      });
      return true;
    } catch (error) {
      logger.e('Error adding bookmark', error: error);
      return false;
    }
  }

  Future<bool> removeBookmark(String userId, String studyId) async {
    try {
      await supabase
          .from('bookmarks')
          .delete()
          .eq('user_id', userId)
          .eq('study_id', studyId);
      return true;
    } catch (error) {
      logger.e('Error removing bookmark', error: error);
      return false;
    }
  }
}
