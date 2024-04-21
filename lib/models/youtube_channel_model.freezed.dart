// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'youtube_channel_model.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

YouTubeChannelModel _$YouTubeChannelModelFromJson(Map<String, dynamic> json) {
  return _YouTubeChannelModel.fromJson(json);
}

/// @nodoc
mixin _$YouTubeChannelModel {
  String get id => throw _privateConstructorUsedError;
  String get name => throw _privateConstructorUsedError;
  String get url => throw _privateConstructorUsedError;
  String get logo => throw _privateConstructorUsedError;

  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;
  @JsonKey(ignore: true)
  $YouTubeChannelModelCopyWith<YouTubeChannelModel> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $YouTubeChannelModelCopyWith<$Res> {
  factory $YouTubeChannelModelCopyWith(
          YouTubeChannelModel value, $Res Function(YouTubeChannelModel) then) =
      _$YouTubeChannelModelCopyWithImpl<$Res, YouTubeChannelModel>;
  @useResult
  $Res call({String id, String name, String url, String logo});
}

/// @nodoc
class _$YouTubeChannelModelCopyWithImpl<$Res, $Val extends YouTubeChannelModel>
    implements $YouTubeChannelModelCopyWith<$Res> {
  _$YouTubeChannelModelCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? name = null,
    Object? url = null,
    Object? logo = null,
  }) {
    return _then(_value.copyWith(
      id: null == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as String,
      name: null == name
          ? _value.name
          : name // ignore: cast_nullable_to_non_nullable
              as String,
      url: null == url
          ? _value.url
          : url // ignore: cast_nullable_to_non_nullable
              as String,
      logo: null == logo
          ? _value.logo
          : logo // ignore: cast_nullable_to_non_nullable
              as String,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$YouTubeChannelModelImplCopyWith<$Res>
    implements $YouTubeChannelModelCopyWith<$Res> {
  factory _$$YouTubeChannelModelImplCopyWith(_$YouTubeChannelModelImpl value,
          $Res Function(_$YouTubeChannelModelImpl) then) =
      __$$YouTubeChannelModelImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({String id, String name, String url, String logo});
}

/// @nodoc
class __$$YouTubeChannelModelImplCopyWithImpl<$Res>
    extends _$YouTubeChannelModelCopyWithImpl<$Res, _$YouTubeChannelModelImpl>
    implements _$$YouTubeChannelModelImplCopyWith<$Res> {
  __$$YouTubeChannelModelImplCopyWithImpl(_$YouTubeChannelModelImpl _value,
      $Res Function(_$YouTubeChannelModelImpl) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? name = null,
    Object? url = null,
    Object? logo = null,
  }) {
    return _then(_$YouTubeChannelModelImpl(
      id: null == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as String,
      name: null == name
          ? _value.name
          : name // ignore: cast_nullable_to_non_nullable
              as String,
      url: null == url
          ? _value.url
          : url // ignore: cast_nullable_to_non_nullable
              as String,
      logo: null == logo
          ? _value.logo
          : logo // ignore: cast_nullable_to_non_nullable
              as String,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$YouTubeChannelModelImpl implements _YouTubeChannelModel {
  _$YouTubeChannelModelImpl(
      {required this.id,
      required this.name,
      required this.url,
      required this.logo});

  factory _$YouTubeChannelModelImpl.fromJson(Map<String, dynamic> json) =>
      _$$YouTubeChannelModelImplFromJson(json);

  @override
  final String id;
  @override
  final String name;
  @override
  final String url;
  @override
  final String logo;

  @override
  String toString() {
    return 'YouTubeChannelModel(id: $id, name: $name, url: $url, logo: $logo)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$YouTubeChannelModelImpl &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.name, name) || other.name == name) &&
            (identical(other.url, url) || other.url == url) &&
            (identical(other.logo, logo) || other.logo == logo));
  }

  @JsonKey(ignore: true)
  @override
  int get hashCode => Object.hash(runtimeType, id, name, url, logo);

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$YouTubeChannelModelImplCopyWith<_$YouTubeChannelModelImpl> get copyWith =>
      __$$YouTubeChannelModelImplCopyWithImpl<_$YouTubeChannelModelImpl>(
          this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$YouTubeChannelModelImplToJson(
      this,
    );
  }
}

abstract class _YouTubeChannelModel implements YouTubeChannelModel {
  factory _YouTubeChannelModel(
      {required final String id,
      required final String name,
      required final String url,
      required final String logo}) = _$YouTubeChannelModelImpl;

  factory _YouTubeChannelModel.fromJson(Map<String, dynamic> json) =
      _$YouTubeChannelModelImpl.fromJson;

  @override
  String get id;
  @override
  String get name;
  @override
  String get url;
  @override
  String get logo;
  @override
  @JsonKey(ignore: true)
  _$$YouTubeChannelModelImplCopyWith<_$YouTubeChannelModelImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
