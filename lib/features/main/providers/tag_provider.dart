import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:chart_q/features/main/data/repositories/tag_repository.dart';
import 'package:chart_q/features/main/domain/models/tag.dart';

final tagListProvider = AsyncNotifierProvider<TagListNotifier, List<Tag>>(() {
  return TagListNotifier();
});

class TagListNotifier extends AsyncNotifier<List<Tag>> {
  @override
  Future<List<Tag>> build() async {
    return await _fetchTags();
  }

  Future<List<Tag>> _fetchTags() async {
    return [Tag(id: -1, name: '전체')] + await TagRepository().getTags();
  }
}

final selectedTagProvider =
    StateProvider<Tag>((ref) => Tag(id: -1, name: '전체'));
