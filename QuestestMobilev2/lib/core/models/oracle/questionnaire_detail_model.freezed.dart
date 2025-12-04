// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'questionnaire_detail_model.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

QuestionnaireOption _$QuestionnaireOptionFromJson(Map<String, dynamic> json) {
  return _QuestionnaireOption.fromJson(json);
}

/// @nodoc
mixin _$QuestionnaireOption {
  int get id => throw _privateConstructorUsedError;
  String get content => throw _privateConstructorUsedError;
  @JsonKey(name: 'is_correct')
  bool? get isCorrect => throw _privateConstructorUsedError;

  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;
  @JsonKey(ignore: true)
  $QuestionnaireOptionCopyWith<QuestionnaireOption> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $QuestionnaireOptionCopyWith<$Res> {
  factory $QuestionnaireOptionCopyWith(
          QuestionnaireOption value, $Res Function(QuestionnaireOption) then) =
      _$QuestionnaireOptionCopyWithImpl<$Res, QuestionnaireOption>;
  @useResult
  $Res call(
      {int id, String content, @JsonKey(name: 'is_correct') bool? isCorrect});
}

/// @nodoc
class _$QuestionnaireOptionCopyWithImpl<$Res, $Val extends QuestionnaireOption>
    implements $QuestionnaireOptionCopyWith<$Res> {
  _$QuestionnaireOptionCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? content = null,
    Object? isCorrect = freezed,
  }) {
    return _then(_value.copyWith(
      id: null == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as int,
      content: null == content
          ? _value.content
          : content // ignore: cast_nullable_to_non_nullable
              as String,
      isCorrect: freezed == isCorrect
          ? _value.isCorrect
          : isCorrect // ignore: cast_nullable_to_non_nullable
              as bool?,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$QuestionnaireOptionImplCopyWith<$Res>
    implements $QuestionnaireOptionCopyWith<$Res> {
  factory _$$QuestionnaireOptionImplCopyWith(_$QuestionnaireOptionImpl value,
          $Res Function(_$QuestionnaireOptionImpl) then) =
      __$$QuestionnaireOptionImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {int id, String content, @JsonKey(name: 'is_correct') bool? isCorrect});
}

/// @nodoc
class __$$QuestionnaireOptionImplCopyWithImpl<$Res>
    extends _$QuestionnaireOptionCopyWithImpl<$Res, _$QuestionnaireOptionImpl>
    implements _$$QuestionnaireOptionImplCopyWith<$Res> {
  __$$QuestionnaireOptionImplCopyWithImpl(_$QuestionnaireOptionImpl _value,
      $Res Function(_$QuestionnaireOptionImpl) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? content = null,
    Object? isCorrect = freezed,
  }) {
    return _then(_$QuestionnaireOptionImpl(
      id: null == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as int,
      content: null == content
          ? _value.content
          : content // ignore: cast_nullable_to_non_nullable
              as String,
      isCorrect: freezed == isCorrect
          ? _value.isCorrect
          : isCorrect // ignore: cast_nullable_to_non_nullable
              as bool?,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$QuestionnaireOptionImpl implements _QuestionnaireOption {
  const _$QuestionnaireOptionImpl(
      {required this.id,
      required this.content,
      @JsonKey(name: 'is_correct') this.isCorrect});

  factory _$QuestionnaireOptionImpl.fromJson(Map<String, dynamic> json) =>
      _$$QuestionnaireOptionImplFromJson(json);

  @override
  final int id;
  @override
  final String content;
  @override
  @JsonKey(name: 'is_correct')
  final bool? isCorrect;

  @override
  String toString() {
    return 'QuestionnaireOption(id: $id, content: $content, isCorrect: $isCorrect)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$QuestionnaireOptionImpl &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.content, content) || other.content == content) &&
            (identical(other.isCorrect, isCorrect) ||
                other.isCorrect == isCorrect));
  }

  @JsonKey(ignore: true)
  @override
  int get hashCode => Object.hash(runtimeType, id, content, isCorrect);

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$QuestionnaireOptionImplCopyWith<_$QuestionnaireOptionImpl> get copyWith =>
      __$$QuestionnaireOptionImplCopyWithImpl<_$QuestionnaireOptionImpl>(
          this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$QuestionnaireOptionImplToJson(
      this,
    );
  }
}

abstract class _QuestionnaireOption implements QuestionnaireOption {
  const factory _QuestionnaireOption(
          {required final int id,
          required final String content,
          @JsonKey(name: 'is_correct') final bool? isCorrect}) =
      _$QuestionnaireOptionImpl;

  factory _QuestionnaireOption.fromJson(Map<String, dynamic> json) =
      _$QuestionnaireOptionImpl.fromJson;

  @override
  int get id;
  @override
  String get content;
  @override
  @JsonKey(name: 'is_correct')
  bool? get isCorrect;
  @override
  @JsonKey(ignore: true)
  _$$QuestionnaireOptionImplCopyWith<_$QuestionnaireOptionImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

QuestionnaireQuestion _$QuestionnaireQuestionFromJson(
    Map<String, dynamic> json) {
  return _QuestionnaireQuestion.fromJson(json);
}

/// @nodoc
mixin _$QuestionnaireQuestion {
  int get id => throw _privateConstructorUsedError;
  String get content => throw _privateConstructorUsedError;
  List<QuestionnaireOption> get options => throw _privateConstructorUsedError;

  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;
  @JsonKey(ignore: true)
  $QuestionnaireQuestionCopyWith<QuestionnaireQuestion> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $QuestionnaireQuestionCopyWith<$Res> {
  factory $QuestionnaireQuestionCopyWith(QuestionnaireQuestion value,
          $Res Function(QuestionnaireQuestion) then) =
      _$QuestionnaireQuestionCopyWithImpl<$Res, QuestionnaireQuestion>;
  @useResult
  $Res call({int id, String content, List<QuestionnaireOption> options});
}

/// @nodoc
class _$QuestionnaireQuestionCopyWithImpl<$Res,
        $Val extends QuestionnaireQuestion>
    implements $QuestionnaireQuestionCopyWith<$Res> {
  _$QuestionnaireQuestionCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? content = null,
    Object? options = null,
  }) {
    return _then(_value.copyWith(
      id: null == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as int,
      content: null == content
          ? _value.content
          : content // ignore: cast_nullable_to_non_nullable
              as String,
      options: null == options
          ? _value.options
          : options // ignore: cast_nullable_to_non_nullable
              as List<QuestionnaireOption>,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$QuestionnaireQuestionImplCopyWith<$Res>
    implements $QuestionnaireQuestionCopyWith<$Res> {
  factory _$$QuestionnaireQuestionImplCopyWith(
          _$QuestionnaireQuestionImpl value,
          $Res Function(_$QuestionnaireQuestionImpl) then) =
      __$$QuestionnaireQuestionImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({int id, String content, List<QuestionnaireOption> options});
}

/// @nodoc
class __$$QuestionnaireQuestionImplCopyWithImpl<$Res>
    extends _$QuestionnaireQuestionCopyWithImpl<$Res,
        _$QuestionnaireQuestionImpl>
    implements _$$QuestionnaireQuestionImplCopyWith<$Res> {
  __$$QuestionnaireQuestionImplCopyWithImpl(_$QuestionnaireQuestionImpl _value,
      $Res Function(_$QuestionnaireQuestionImpl) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? content = null,
    Object? options = null,
  }) {
    return _then(_$QuestionnaireQuestionImpl(
      id: null == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as int,
      content: null == content
          ? _value.content
          : content // ignore: cast_nullable_to_non_nullable
              as String,
      options: null == options
          ? _value._options
          : options // ignore: cast_nullable_to_non_nullable
              as List<QuestionnaireOption>,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$QuestionnaireQuestionImpl implements _QuestionnaireQuestion {
  const _$QuestionnaireQuestionImpl(
      {required this.id,
      required this.content,
      required final List<QuestionnaireOption> options})
      : _options = options;

  factory _$QuestionnaireQuestionImpl.fromJson(Map<String, dynamic> json) =>
      _$$QuestionnaireQuestionImplFromJson(json);

  @override
  final int id;
  @override
  final String content;
  final List<QuestionnaireOption> _options;
  @override
  List<QuestionnaireOption> get options {
    if (_options is EqualUnmodifiableListView) return _options;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_options);
  }

  @override
  String toString() {
    return 'QuestionnaireQuestion(id: $id, content: $content, options: $options)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$QuestionnaireQuestionImpl &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.content, content) || other.content == content) &&
            const DeepCollectionEquality().equals(other._options, _options));
  }

  @JsonKey(ignore: true)
  @override
  int get hashCode => Object.hash(
      runtimeType, id, content, const DeepCollectionEquality().hash(_options));

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$QuestionnaireQuestionImplCopyWith<_$QuestionnaireQuestionImpl>
      get copyWith => __$$QuestionnaireQuestionImplCopyWithImpl<
          _$QuestionnaireQuestionImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$QuestionnaireQuestionImplToJson(
      this,
    );
  }
}

abstract class _QuestionnaireQuestion implements QuestionnaireQuestion {
  const factory _QuestionnaireQuestion(
          {required final int id,
          required final String content,
          required final List<QuestionnaireOption> options}) =
      _$QuestionnaireQuestionImpl;

  factory _QuestionnaireQuestion.fromJson(Map<String, dynamic> json) =
      _$QuestionnaireQuestionImpl.fromJson;

  @override
  int get id;
  @override
  String get content;
  @override
  List<QuestionnaireOption> get options;
  @override
  @JsonKey(ignore: true)
  _$$QuestionnaireQuestionImplCopyWith<_$QuestionnaireQuestionImpl>
      get copyWith => throw _privateConstructorUsedError;
}

QuestionnaireDetailModel _$QuestionnaireDetailModelFromJson(
    Map<String, dynamic> json) {
  return _QuestionnaireDetailModel.fromJson(json);
}

/// @nodoc
mixin _$QuestionnaireDetailModel {
  int get id => throw _privateConstructorUsedError;
  String get title => throw _privateConstructorUsedError;
  List<QuestionnaireQuestion> get questions =>
      throw _privateConstructorUsedError;

  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;
  @JsonKey(ignore: true)
  $QuestionnaireDetailModelCopyWith<QuestionnaireDetailModel> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $QuestionnaireDetailModelCopyWith<$Res> {
  factory $QuestionnaireDetailModelCopyWith(QuestionnaireDetailModel value,
          $Res Function(QuestionnaireDetailModel) then) =
      _$QuestionnaireDetailModelCopyWithImpl<$Res, QuestionnaireDetailModel>;
  @useResult
  $Res call({int id, String title, List<QuestionnaireQuestion> questions});
}

/// @nodoc
class _$QuestionnaireDetailModelCopyWithImpl<$Res,
        $Val extends QuestionnaireDetailModel>
    implements $QuestionnaireDetailModelCopyWith<$Res> {
  _$QuestionnaireDetailModelCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? title = null,
    Object? questions = null,
  }) {
    return _then(_value.copyWith(
      id: null == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as int,
      title: null == title
          ? _value.title
          : title // ignore: cast_nullable_to_non_nullable
              as String,
      questions: null == questions
          ? _value.questions
          : questions // ignore: cast_nullable_to_non_nullable
              as List<QuestionnaireQuestion>,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$QuestionnaireDetailModelImplCopyWith<$Res>
    implements $QuestionnaireDetailModelCopyWith<$Res> {
  factory _$$QuestionnaireDetailModelImplCopyWith(
          _$QuestionnaireDetailModelImpl value,
          $Res Function(_$QuestionnaireDetailModelImpl) then) =
      __$$QuestionnaireDetailModelImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({int id, String title, List<QuestionnaireQuestion> questions});
}

/// @nodoc
class __$$QuestionnaireDetailModelImplCopyWithImpl<$Res>
    extends _$QuestionnaireDetailModelCopyWithImpl<$Res,
        _$QuestionnaireDetailModelImpl>
    implements _$$QuestionnaireDetailModelImplCopyWith<$Res> {
  __$$QuestionnaireDetailModelImplCopyWithImpl(
      _$QuestionnaireDetailModelImpl _value,
      $Res Function(_$QuestionnaireDetailModelImpl) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? title = null,
    Object? questions = null,
  }) {
    return _then(_$QuestionnaireDetailModelImpl(
      id: null == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as int,
      title: null == title
          ? _value.title
          : title // ignore: cast_nullable_to_non_nullable
              as String,
      questions: null == questions
          ? _value._questions
          : questions // ignore: cast_nullable_to_non_nullable
              as List<QuestionnaireQuestion>,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$QuestionnaireDetailModelImpl implements _QuestionnaireDetailModel {
  const _$QuestionnaireDetailModelImpl(
      {required this.id,
      required this.title,
      required final List<QuestionnaireQuestion> questions})
      : _questions = questions;

  factory _$QuestionnaireDetailModelImpl.fromJson(Map<String, dynamic> json) =>
      _$$QuestionnaireDetailModelImplFromJson(json);

  @override
  final int id;
  @override
  final String title;
  final List<QuestionnaireQuestion> _questions;
  @override
  List<QuestionnaireQuestion> get questions {
    if (_questions is EqualUnmodifiableListView) return _questions;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_questions);
  }

  @override
  String toString() {
    return 'QuestionnaireDetailModel(id: $id, title: $title, questions: $questions)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$QuestionnaireDetailModelImpl &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.title, title) || other.title == title) &&
            const DeepCollectionEquality()
                .equals(other._questions, _questions));
  }

  @JsonKey(ignore: true)
  @override
  int get hashCode => Object.hash(
      runtimeType, id, title, const DeepCollectionEquality().hash(_questions));

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$QuestionnaireDetailModelImplCopyWith<_$QuestionnaireDetailModelImpl>
      get copyWith => __$$QuestionnaireDetailModelImplCopyWithImpl<
          _$QuestionnaireDetailModelImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$QuestionnaireDetailModelImplToJson(
      this,
    );
  }
}

abstract class _QuestionnaireDetailModel implements QuestionnaireDetailModel {
  const factory _QuestionnaireDetailModel(
          {required final int id,
          required final String title,
          required final List<QuestionnaireQuestion> questions}) =
      _$QuestionnaireDetailModelImpl;

  factory _QuestionnaireDetailModel.fromJson(Map<String, dynamic> json) =
      _$QuestionnaireDetailModelImpl.fromJson;

  @override
  int get id;
  @override
  String get title;
  @override
  List<QuestionnaireQuestion> get questions;
  @override
  @JsonKey(ignore: true)
  _$$QuestionnaireDetailModelImplCopyWith<_$QuestionnaireDetailModelImpl>
      get copyWith => throw _privateConstructorUsedError;
}
