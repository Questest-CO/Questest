// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'filled_questionnaire_model.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

FilledQuestionnaireModel _$FilledQuestionnaireModelFromJson(
    Map<String, dynamic> json) {
  return _FilledQuestionnaireModel.fromJson(json);
}

/// @nodoc
mixin _$FilledQuestionnaireModel {
  @JsonKey(fromJson: _parseId)
  int get id => throw _privateConstructorUsedError;
  @JsonKey(name: 'questionnaireid', fromJson: _parseId)
  int get questionnaireId => throw _privateConstructorUsedError;
  @JsonKey(name: 'date_filled')
  DateTime get dateFilled => throw _privateConstructorUsedError;
  @JsonKey(name: 'filled_by', fromJson: _parseId)
  int get filledBy => throw _privateConstructorUsedError;
  @JsonKey(name: 'result_id', fromJson: _parseNullableInt)
  int? get resultId => throw _privateConstructorUsedError;

  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;
  @JsonKey(ignore: true)
  $FilledQuestionnaireModelCopyWith<FilledQuestionnaireModel> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $FilledQuestionnaireModelCopyWith<$Res> {
  factory $FilledQuestionnaireModelCopyWith(FilledQuestionnaireModel value,
          $Res Function(FilledQuestionnaireModel) then) =
      _$FilledQuestionnaireModelCopyWithImpl<$Res, FilledQuestionnaireModel>;
  @useResult
  $Res call(
      {@JsonKey(fromJson: _parseId) int id,
      @JsonKey(name: 'questionnaireid', fromJson: _parseId) int questionnaireId,
      @JsonKey(name: 'date_filled') DateTime dateFilled,
      @JsonKey(name: 'filled_by', fromJson: _parseId) int filledBy,
      @JsonKey(name: 'result_id', fromJson: _parseNullableInt) int? resultId});
}

/// @nodoc
class _$FilledQuestionnaireModelCopyWithImpl<$Res,
        $Val extends FilledQuestionnaireModel>
    implements $FilledQuestionnaireModelCopyWith<$Res> {
  _$FilledQuestionnaireModelCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? questionnaireId = null,
    Object? dateFilled = null,
    Object? filledBy = null,
    Object? resultId = freezed,
  }) {
    return _then(_value.copyWith(
      id: null == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as int,
      questionnaireId: null == questionnaireId
          ? _value.questionnaireId
          : questionnaireId // ignore: cast_nullable_to_non_nullable
              as int,
      dateFilled: null == dateFilled
          ? _value.dateFilled
          : dateFilled // ignore: cast_nullable_to_non_nullable
              as DateTime,
      filledBy: null == filledBy
          ? _value.filledBy
          : filledBy // ignore: cast_nullable_to_non_nullable
              as int,
      resultId: freezed == resultId
          ? _value.resultId
          : resultId // ignore: cast_nullable_to_non_nullable
              as int?,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$FilledQuestionnaireModelImplCopyWith<$Res>
    implements $FilledQuestionnaireModelCopyWith<$Res> {
  factory _$$FilledQuestionnaireModelImplCopyWith(
          _$FilledQuestionnaireModelImpl value,
          $Res Function(_$FilledQuestionnaireModelImpl) then) =
      __$$FilledQuestionnaireModelImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {@JsonKey(fromJson: _parseId) int id,
      @JsonKey(name: 'questionnaireid', fromJson: _parseId) int questionnaireId,
      @JsonKey(name: 'date_filled') DateTime dateFilled,
      @JsonKey(name: 'filled_by', fromJson: _parseId) int filledBy,
      @JsonKey(name: 'result_id', fromJson: _parseNullableInt) int? resultId});
}

/// @nodoc
class __$$FilledQuestionnaireModelImplCopyWithImpl<$Res>
    extends _$FilledQuestionnaireModelCopyWithImpl<$Res,
        _$FilledQuestionnaireModelImpl>
    implements _$$FilledQuestionnaireModelImplCopyWith<$Res> {
  __$$FilledQuestionnaireModelImplCopyWithImpl(
      _$FilledQuestionnaireModelImpl _value,
      $Res Function(_$FilledQuestionnaireModelImpl) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? questionnaireId = null,
    Object? dateFilled = null,
    Object? filledBy = null,
    Object? resultId = freezed,
  }) {
    return _then(_$FilledQuestionnaireModelImpl(
      id: null == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as int,
      questionnaireId: null == questionnaireId
          ? _value.questionnaireId
          : questionnaireId // ignore: cast_nullable_to_non_nullable
              as int,
      dateFilled: null == dateFilled
          ? _value.dateFilled
          : dateFilled // ignore: cast_nullable_to_non_nullable
              as DateTime,
      filledBy: null == filledBy
          ? _value.filledBy
          : filledBy // ignore: cast_nullable_to_non_nullable
              as int,
      resultId: freezed == resultId
          ? _value.resultId
          : resultId // ignore: cast_nullable_to_non_nullable
              as int?,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$FilledQuestionnaireModelImpl implements _FilledQuestionnaireModel {
  const _$FilledQuestionnaireModelImpl(
      {@JsonKey(fromJson: _parseId) required this.id,
      @JsonKey(name: 'questionnaireid', fromJson: _parseId)
      required this.questionnaireId,
      @JsonKey(name: 'date_filled') required this.dateFilled,
      @JsonKey(name: 'filled_by', fromJson: _parseId) required this.filledBy,
      @JsonKey(name: 'result_id', fromJson: _parseNullableInt) this.resultId});

  factory _$FilledQuestionnaireModelImpl.fromJson(Map<String, dynamic> json) =>
      _$$FilledQuestionnaireModelImplFromJson(json);

  @override
  @JsonKey(fromJson: _parseId)
  final int id;
  @override
  @JsonKey(name: 'questionnaireid', fromJson: _parseId)
  final int questionnaireId;
  @override
  @JsonKey(name: 'date_filled')
  final DateTime dateFilled;
  @override
  @JsonKey(name: 'filled_by', fromJson: _parseId)
  final int filledBy;
  @override
  @JsonKey(name: 'result_id', fromJson: _parseNullableInt)
  final int? resultId;

  @override
  String toString() {
    return 'FilledQuestionnaireModel(id: $id, questionnaireId: $questionnaireId, dateFilled: $dateFilled, filledBy: $filledBy, resultId: $resultId)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$FilledQuestionnaireModelImpl &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.questionnaireId, questionnaireId) ||
                other.questionnaireId == questionnaireId) &&
            (identical(other.dateFilled, dateFilled) ||
                other.dateFilled == dateFilled) &&
            (identical(other.filledBy, filledBy) ||
                other.filledBy == filledBy) &&
            (identical(other.resultId, resultId) ||
                other.resultId == resultId));
  }

  @JsonKey(ignore: true)
  @override
  int get hashCode => Object.hash(
      runtimeType, id, questionnaireId, dateFilled, filledBy, resultId);

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$FilledQuestionnaireModelImplCopyWith<_$FilledQuestionnaireModelImpl>
      get copyWith => __$$FilledQuestionnaireModelImplCopyWithImpl<
          _$FilledQuestionnaireModelImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$FilledQuestionnaireModelImplToJson(
      this,
    );
  }
}

abstract class _FilledQuestionnaireModel implements FilledQuestionnaireModel {
  const factory _FilledQuestionnaireModel(
      {@JsonKey(fromJson: _parseId) required final int id,
      @JsonKey(name: 'questionnaireid', fromJson: _parseId)
      required final int questionnaireId,
      @JsonKey(name: 'date_filled') required final DateTime dateFilled,
      @JsonKey(name: 'filled_by', fromJson: _parseId)
      required final int filledBy,
      @JsonKey(name: 'result_id', fromJson: _parseNullableInt)
      final int? resultId}) = _$FilledQuestionnaireModelImpl;

  factory _FilledQuestionnaireModel.fromJson(Map<String, dynamic> json) =
      _$FilledQuestionnaireModelImpl.fromJson;

  @override
  @JsonKey(fromJson: _parseId)
  int get id;
  @override
  @JsonKey(name: 'questionnaireid', fromJson: _parseId)
  int get questionnaireId;
  @override
  @JsonKey(name: 'date_filled')
  DateTime get dateFilled;
  @override
  @JsonKey(name: 'filled_by', fromJson: _parseId)
  int get filledBy;
  @override
  @JsonKey(name: 'result_id', fromJson: _parseNullableInt)
  int? get resultId;
  @override
  @JsonKey(ignore: true)
  _$$FilledQuestionnaireModelImplCopyWith<_$FilledQuestionnaireModelImpl>
      get copyWith => throw _privateConstructorUsedError;
}
