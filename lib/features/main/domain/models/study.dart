import 'package:chart_q/features/main/domain/models/tag.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'study.freezed.dart';
part 'study.g.dart';

@freezed
class Study with _$Study {
  const factory Study({
    required String id,
    required String title,
    List<Tag>? tags,
    String? image,
    String? content,
    @JsonKey(name: 'updated_at') required DateTime updatedAt,
  }) = _Study;

  factory Study.fromJson(Map<String, dynamic> json) => _$StudyFromJson(json);
}
