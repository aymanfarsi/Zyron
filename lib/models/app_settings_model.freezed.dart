// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'app_settings_model.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

AppSettingsModel _$AppSettingsModelFromJson(Map<String, dynamic> json) {
  return _AppSettingsModel.fromJson(json);
}

/// @nodoc
mixin _$AppSettingsModel {
  bool get isDarkMode => throw _privateConstructorUsedError;
  bool get isAlwaysOnTop => throw _privateConstructorUsedError;
  bool get isPreventClose => throw _privateConstructorUsedError;
  bool get isAutoStart => throw _privateConstructorUsedError;
  int get startingPage => throw _privateConstructorUsedError;
  PlayerSettingsModel get playerSettings => throw _privateConstructorUsedError;

  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;
  @JsonKey(ignore: true)
  $AppSettingsModelCopyWith<AppSettingsModel> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $AppSettingsModelCopyWith<$Res> {
  factory $AppSettingsModelCopyWith(
          AppSettingsModel value, $Res Function(AppSettingsModel) then) =
      _$AppSettingsModelCopyWithImpl<$Res, AppSettingsModel>;
  @useResult
  $Res call(
      {bool isDarkMode,
      bool isAlwaysOnTop,
      bool isPreventClose,
      bool isAutoStart,
      int startingPage,
      PlayerSettingsModel playerSettings});

  $PlayerSettingsModelCopyWith<$Res> get playerSettings;
}

/// @nodoc
class _$AppSettingsModelCopyWithImpl<$Res, $Val extends AppSettingsModel>
    implements $AppSettingsModelCopyWith<$Res> {
  _$AppSettingsModelCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? isDarkMode = null,
    Object? isAlwaysOnTop = null,
    Object? isPreventClose = null,
    Object? isAutoStart = null,
    Object? startingPage = null,
    Object? playerSettings = null,
  }) {
    return _then(_value.copyWith(
      isDarkMode: null == isDarkMode
          ? _value.isDarkMode
          : isDarkMode // ignore: cast_nullable_to_non_nullable
              as bool,
      isAlwaysOnTop: null == isAlwaysOnTop
          ? _value.isAlwaysOnTop
          : isAlwaysOnTop // ignore: cast_nullable_to_non_nullable
              as bool,
      isPreventClose: null == isPreventClose
          ? _value.isPreventClose
          : isPreventClose // ignore: cast_nullable_to_non_nullable
              as bool,
      isAutoStart: null == isAutoStart
          ? _value.isAutoStart
          : isAutoStart // ignore: cast_nullable_to_non_nullable
              as bool,
      startingPage: null == startingPage
          ? _value.startingPage
          : startingPage // ignore: cast_nullable_to_non_nullable
              as int,
      playerSettings: null == playerSettings
          ? _value.playerSettings
          : playerSettings // ignore: cast_nullable_to_non_nullable
              as PlayerSettingsModel,
    ) as $Val);
  }

  @override
  @pragma('vm:prefer-inline')
  $PlayerSettingsModelCopyWith<$Res> get playerSettings {
    return $PlayerSettingsModelCopyWith<$Res>(_value.playerSettings, (value) {
      return _then(_value.copyWith(playerSettings: value) as $Val);
    });
  }
}

/// @nodoc
abstract class _$$AppSettingsModelImplCopyWith<$Res>
    implements $AppSettingsModelCopyWith<$Res> {
  factory _$$AppSettingsModelImplCopyWith(_$AppSettingsModelImpl value,
          $Res Function(_$AppSettingsModelImpl) then) =
      __$$AppSettingsModelImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {bool isDarkMode,
      bool isAlwaysOnTop,
      bool isPreventClose,
      bool isAutoStart,
      int startingPage,
      PlayerSettingsModel playerSettings});

  @override
  $PlayerSettingsModelCopyWith<$Res> get playerSettings;
}

/// @nodoc
class __$$AppSettingsModelImplCopyWithImpl<$Res>
    extends _$AppSettingsModelCopyWithImpl<$Res, _$AppSettingsModelImpl>
    implements _$$AppSettingsModelImplCopyWith<$Res> {
  __$$AppSettingsModelImplCopyWithImpl(_$AppSettingsModelImpl _value,
      $Res Function(_$AppSettingsModelImpl) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? isDarkMode = null,
    Object? isAlwaysOnTop = null,
    Object? isPreventClose = null,
    Object? isAutoStart = null,
    Object? startingPage = null,
    Object? playerSettings = null,
  }) {
    return _then(_$AppSettingsModelImpl(
      isDarkMode: null == isDarkMode
          ? _value.isDarkMode
          : isDarkMode // ignore: cast_nullable_to_non_nullable
              as bool,
      isAlwaysOnTop: null == isAlwaysOnTop
          ? _value.isAlwaysOnTop
          : isAlwaysOnTop // ignore: cast_nullable_to_non_nullable
              as bool,
      isPreventClose: null == isPreventClose
          ? _value.isPreventClose
          : isPreventClose // ignore: cast_nullable_to_non_nullable
              as bool,
      isAutoStart: null == isAutoStart
          ? _value.isAutoStart
          : isAutoStart // ignore: cast_nullable_to_non_nullable
              as bool,
      startingPage: null == startingPage
          ? _value.startingPage
          : startingPage // ignore: cast_nullable_to_non_nullable
              as int,
      playerSettings: null == playerSettings
          ? _value.playerSettings
          : playerSettings // ignore: cast_nullable_to_non_nullable
              as PlayerSettingsModel,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$AppSettingsModelImpl implements _AppSettingsModel {
  _$AppSettingsModelImpl(
      {required this.isDarkMode,
      required this.isAlwaysOnTop,
      required this.isPreventClose,
      required this.isAutoStart,
      required this.startingPage,
      required this.playerSettings});

  factory _$AppSettingsModelImpl.fromJson(Map<String, dynamic> json) =>
      _$$AppSettingsModelImplFromJson(json);

  @override
  final bool isDarkMode;
  @override
  final bool isAlwaysOnTop;
  @override
  final bool isPreventClose;
  @override
  final bool isAutoStart;
  @override
  final int startingPage;
  @override
  final PlayerSettingsModel playerSettings;

  @override
  String toString() {
    return 'AppSettingsModel(isDarkMode: $isDarkMode, isAlwaysOnTop: $isAlwaysOnTop, isPreventClose: $isPreventClose, isAutoStart: $isAutoStart, startingPage: $startingPage, playerSettings: $playerSettings)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$AppSettingsModelImpl &&
            (identical(other.isDarkMode, isDarkMode) ||
                other.isDarkMode == isDarkMode) &&
            (identical(other.isAlwaysOnTop, isAlwaysOnTop) ||
                other.isAlwaysOnTop == isAlwaysOnTop) &&
            (identical(other.isPreventClose, isPreventClose) ||
                other.isPreventClose == isPreventClose) &&
            (identical(other.isAutoStart, isAutoStart) ||
                other.isAutoStart == isAutoStart) &&
            (identical(other.startingPage, startingPage) ||
                other.startingPage == startingPage) &&
            (identical(other.playerSettings, playerSettings) ||
                other.playerSettings == playerSettings));
  }

  @JsonKey(ignore: true)
  @override
  int get hashCode => Object.hash(runtimeType, isDarkMode, isAlwaysOnTop,
      isPreventClose, isAutoStart, startingPage, playerSettings);

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$AppSettingsModelImplCopyWith<_$AppSettingsModelImpl> get copyWith =>
      __$$AppSettingsModelImplCopyWithImpl<_$AppSettingsModelImpl>(
          this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$AppSettingsModelImplToJson(
      this,
    );
  }
}

abstract class _AppSettingsModel implements AppSettingsModel {
  factory _AppSettingsModel(
          {required final bool isDarkMode,
          required final bool isAlwaysOnTop,
          required final bool isPreventClose,
          required final bool isAutoStart,
          required final int startingPage,
          required final PlayerSettingsModel playerSettings}) =
      _$AppSettingsModelImpl;

  factory _AppSettingsModel.fromJson(Map<String, dynamic> json) =
      _$AppSettingsModelImpl.fromJson;

  @override
  bool get isDarkMode;
  @override
  bool get isAlwaysOnTop;
  @override
  bool get isPreventClose;
  @override
  bool get isAutoStart;
  @override
  int get startingPage;
  @override
  PlayerSettingsModel get playerSettings;
  @override
  @JsonKey(ignore: true)
  _$$AppSettingsModelImplCopyWith<_$AppSettingsModelImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
