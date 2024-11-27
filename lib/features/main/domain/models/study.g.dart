// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'study.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$StudyImpl _$$StudyImplFromJson(Map<String, dynamic> json) => _$StudyImpl(
      id: json['id'] as String,
      title: json['title'] as String,
      tags: (json['tags'] as List<dynamic>?)
          ?.map((e) => Tag.fromJson(e as Map<String, dynamic>))
          .toList(),
      image: json['image'] as String?,
      content: json['content'] as String?,
      updatedAt: DateTime.parse(json['updated_at'] as String),
    );

Map<String, dynamic> _$$StudyImplToJson(_$StudyImpl instance) =>
    <String, dynamic>{
      'id': instance.id,
      'title': instance.title,
      'tags': instance.tags,
      'image': instance.image,
      'content': instance.content,
      'updated_at': instance.updatedAt.toIso8601String(),
    };
