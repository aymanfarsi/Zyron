// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'youtube_model.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

YouTubeModel _$YouTubeModelFromJson(Map<String, dynamic> json) {
  return _YouTubeModel.fromJson(json);
}

/// @nodoc
mixin _$YouTubeModel {
  List<YouTubeModel> get channels => throw _privateConstructorUsedError;

  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;
  @JsonKey(ignore: true)
  $YouTubeModelCopyWith<YouTubeModel> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $YouTubeModelCopyWith<$Res> {
  factory $YouTubeModelCopyWith(
          YouTubeModel value, $Res Function(YouTubeModel) then) =
      _$YouTubeModelCopyWithImpl<$Res, YouTubeModel>;
  @useResult
  $Res call({List<YouTubeModel> channels});
}

/// @nodoc
class _$YouTubeModelCopyWithImpl<$Res, $Val extends YouTubeModel>
    implements $YouTubeModelCopyWith<$Res> {
  _$YouTubeModelCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? channels = null,
  }) {
    return _then(_value.copyWith(
      channels: null == channels
          ? _value.channels
          : channels // ignore: cast_nullable_to_non_nullable
              as List<YouTubeModel>,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$YouTubeModelImplCopyWith<$Res>
    implements $YouTubeModelCopyWith<$Res> {
  factory _$$YouTubeModelImplCopyWith(
          _$YouTubeModelImpl value, $Res Function(_$YouTubeModelImpl) then) =
      __$$YouTubeModelImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({List<YouTubeModel> channels});
}

/// @nodoc
class __$$YouTubeModelImplCopyWithImpl<$Res>
    extends _$YouTubeModelCopyWithImpl<$Res, _$YouTubeModelImpl>
    implements _$$YouTubeModelImplCopyWith<$Res> {
  __$$YouTubeModelImplCopyWithImpl(
      _$YouTubeModelImpl _value, $Res Function(_$YouTubeModelImpl) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? channels = null,
  }) {
    return _then(_$YouTubeModelImpl(
      channels: null == channels
          ? _value._channels
          : channels // ignore: cast_nullable_to_non_nullable
              as List<YouTubeModel>,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$YouTubeModelImpl implements _YouTubeModel {
  _$YouTubeModelImpl({required final List<YouTubeModel> channels})
      : _channels = channels;

  factory _$YouTubeModelImpl.fromJson(Map<String, dynamic> json) =>
      _$$YouTubeModelImplFromJson(json);

  final List<YouTubeModel> _channels;
  @override
  List<YouTubeModel> get channels {
    if (_channels is EqualUnmodifiableListView) return _channels;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_channels);
  }

  @override
  String toString() {
    return 'YouTubeModel(channels: $channels)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$YouTubeModelImpl &&
            const DeepCollectionEquality().equals(other._channels, _channels));
  }

  @JsonKey(ignore: true)
  @override
  int get hashCode =>
      Object.hash(runtimeType, const DeepCollectionEquality().hash(_channels));

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$YouTubeModelImplCopyWith<_$YouTubeModelImpl> get copyWith =>
      __$$YouTubeModelImplCopyWithImpl<_$YouTubeModelImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$YouTubeModelImplToJson(
      this,
    );
  }
}

abstract class _YouTubeModel implements YouTubeModel {
  factory _YouTubeModel({required final List<YouTubeModel> channels}) =
      _$YouTubeModelImpl;

  factory _YouTubeModel.fromJson(Map<String, dynamic> json) =
      _$YouTubeModelImpl.fromJson;

  @override
  List<YouTubeModel> get channels;
  @override
  @JsonKey(ignore: true)
  _$$YouTubeModelImplCopyWith<_$YouTubeModelImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
