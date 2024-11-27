// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'study.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

Study _$StudyFromJson(Map<String, dynamic> json) {
  return _Study.fromJson(json);
}

/// @nodoc
mixin _$Study {
  String get id => throw _privateConstructorUsedError;
  String get title => throw _privateConstructorUsedError;
  List<Tag>? get tags => throw _privateConstructorUsedError;
  String? get image => throw _privateConstructorUsedError;
  String? get content => throw _privateConstructorUsedError;
  @JsonKey(name: 'updated_at')
  DateTime get updatedAt => throw _privateConstructorUsedError;

  /// Serializes this Study to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of Study
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $StudyCopyWith<Study> get copyWith => throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $StudyCopyWith<$Res> {
  factory $StudyCopyWith(Study value, $Res Function(Study) then) =
      _$StudyCopyWithImpl<$Res, Study>;
  @useResult
  $Res call(
      {String id,
      String title,
      List<Tag>? tags,
      String? image,
      String? content,
      @JsonKey(name: 'updated_at') DateTime updatedAt});
}

/// @nodoc
class _$StudyCopyWithImpl<$Res, $Val extends Study>
    implements $StudyCopyWith<$Res> {
  _$StudyCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of Study
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? title = null,
    Object? tags = freezed,
    Object? image = freezed,
    Object? content = freezed,
    Object? updatedAt = null,
  }) {
    return _then(_value.copyWith(
      id: null == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as String,
      title: null == title
          ? _value.title
          : title // ignore: cast_nullable_to_non_nullable
              as String,
      tags: freezed == tags
          ? _value.tags
          : tags // ignore: cast_nullable_to_non_nullable
              as List<Tag>?,
      image: freezed == image
          ? _value.image
          : image // ignore: cast_nullable_to_non_nullable
              as String?,
      content: freezed == content
          ? _value.content
          : content // ignore: cast_nullable_to_non_nullable
              as String?,
      updatedAt: null == updatedAt
          ? _value.updatedAt
          : updatedAt // ignore: cast_nullable_to_non_nullable
              as DateTime,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$StudyImplCopyWith<$Res> implements $StudyCopyWith<$Res> {
  factory _$$StudyImplCopyWith(
          _$StudyImpl value, $Res Function(_$StudyImpl) then) =
      __$$StudyImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {String id,
      String title,
      List<Tag>? tags,
      String? image,
      String? content,
      @JsonKey(name: 'updated_at') DateTime updatedAt});
}

/// @nodoc
class __$$StudyImplCopyWithImpl<$Res>
    extends _$StudyCopyWithImpl<$Res, _$StudyImpl>
    implements _$$StudyImplCopyWith<$Res> {
  __$$StudyImplCopyWithImpl(
      _$StudyImpl _value, $Res Function(_$StudyImpl) _then)
      : super(_value, _then);

  /// Create a copy of Study
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? title = null,
    Object? tags = freezed,
    Object? image = freezed,
    Object? content = freezed,
    Object? updatedAt = null,
  }) {
    return _then(_$StudyImpl(
      id: null == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as String,
      title: null == title
          ? _value.title
          : title // ignore: cast_nullable_to_non_nullable
              as String,
      tags: freezed == tags
          ? _value._tags
          : tags // ignore: cast_nullable_to_non_nullable
              as List<Tag>?,
      image: freezed == image
          ? _value.image
          : image // ignore: cast_nullable_to_non_nullable
              as String?,
      content: freezed == content
          ? _value.content
          : content // ignore: cast_nullable_to_non_nullable
              as String?,
      updatedAt: null == updatedAt
          ? _value.updatedAt
          : updatedAt // ignore: cast_nullable_to_non_nullable
              as DateTime,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$StudyImpl implements _Study {
  const _$StudyImpl(
      {required this.id,
      required this.title,
      final List<Tag>? tags,
      this.image,
      this.content,
      @JsonKey(name: 'updated_at') required this.updatedAt})
      : _tags = tags;

  factory _$StudyImpl.fromJson(Map<String, dynamic> json) =>
      _$$StudyImplFromJson(json);

  @override
  final String id;
  @override
  final String title;
  final List<Tag>? _tags;
  @override
  List<Tag>? get tags {
    final value = _tags;
    if (value == null) return null;
    if (_tags is EqualUnmodifiableListView) return _tags;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(value);
  }

  @override
  final String? image;
  @override
  final String? content;
  @override
  @JsonKey(name: 'updated_at')
  final DateTime updatedAt;

  @override
  String toString() {
    return 'Study(id: $id, title: $title, tags: $tags, image: $image, content: $content, updatedAt: $updatedAt)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$StudyImpl &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.title, title) || other.title == title) &&
            const DeepCollectionEquality().equals(other._tags, _tags) &&
            (identical(other.image, image) || other.image == image) &&
            (identical(other.content, content) || other.content == content) &&
            (identical(other.updatedAt, updatedAt) ||
                other.updatedAt == updatedAt));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(runtimeType, id, title,
      const DeepCollectionEquality().hash(_tags), image, content, updatedAt);

  /// Create a copy of Study
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$StudyImplCopyWith<_$StudyImpl> get copyWith =>
      __$$StudyImplCopyWithImpl<_$StudyImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$StudyImplToJson(
      this,
    );
  }
}

abstract class _Study implements Study {
  const factory _Study(
          {required final String id,
          required final String title,
          final List<Tag>? tags,
          final String? image,
          final String? content,
          @JsonKey(name: 'updated_at') required final DateTime updatedAt}) =
      _$StudyImpl;

  factory _Study.fromJson(Map<String, dynamic> json) = _$StudyImpl.fromJson;

  @override
  String get id;
  @override
  String get title;
  @override
  List<Tag>? get tags;
  @override
  String? get image;
  @override
  String? get content;
  @override
  @JsonKey(name: 'updated_at')
  DateTime get updatedAt;

  /// Create a copy of Study
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$StudyImplCopyWith<_$StudyImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
