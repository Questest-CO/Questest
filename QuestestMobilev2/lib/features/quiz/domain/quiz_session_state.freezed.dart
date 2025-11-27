// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'quiz_session_state.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

/// @nodoc
mixin _$QuizSessionState {
  /// List of questions in this quiz session
  List<QuizQuestion> get questions => throw _privateConstructorUsedError;

  /// Current question index (0-based)
  int get currentQuestionIndex => throw _privateConstructorUsedError;

  /// Map of question ID to answer(s)
  /// - SingleChoice: int (selected option ID)
  /// - MultipleChoice: Set<int> (selected option IDs)
  /// - OpenText: String (user's text answer)
  Map<int, dynamic> get answers => throw _privateConstructorUsedError;

  /// Remaining time in seconds
  int get remainingSeconds => throw _privateConstructorUsedError;

  /// Current quiz status
  QuizStatus get status => throw _privateConstructorUsedError;

  @JsonKey(ignore: true)
  $QuizSessionStateCopyWith<QuizSessionState> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $QuizSessionStateCopyWith<$Res> {
  factory $QuizSessionStateCopyWith(
          QuizSessionState value, $Res Function(QuizSessionState) then) =
      _$QuizSessionStateCopyWithImpl<$Res, QuizSessionState>;
  @useResult
  $Res call(
      {List<QuizQuestion> questions,
      int currentQuestionIndex,
      Map<int, dynamic> answers,
      int remainingSeconds,
      QuizStatus status});
}

/// @nodoc
class _$QuizSessionStateCopyWithImpl<$Res, $Val extends QuizSessionState>
    implements $QuizSessionStateCopyWith<$Res> {
  _$QuizSessionStateCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? questions = null,
    Object? currentQuestionIndex = null,
    Object? answers = null,
    Object? remainingSeconds = null,
    Object? status = null,
  }) {
    return _then(_value.copyWith(
      questions: null == questions
          ? _value.questions
          : questions // ignore: cast_nullable_to_non_nullable
              as List<QuizQuestion>,
      currentQuestionIndex: null == currentQuestionIndex
          ? _value.currentQuestionIndex
          : currentQuestionIndex // ignore: cast_nullable_to_non_nullable
              as int,
      answers: null == answers
          ? _value.answers
          : answers // ignore: cast_nullable_to_non_nullable
              as Map<int, dynamic>,
      remainingSeconds: null == remainingSeconds
          ? _value.remainingSeconds
          : remainingSeconds // ignore: cast_nullable_to_non_nullable
              as int,
      status: null == status
          ? _value.status
          : status // ignore: cast_nullable_to_non_nullable
              as QuizStatus,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$QuizSessionStateImplCopyWith<$Res>
    implements $QuizSessionStateCopyWith<$Res> {
  factory _$$QuizSessionStateImplCopyWith(_$QuizSessionStateImpl value,
          $Res Function(_$QuizSessionStateImpl) then) =
      __$$QuizSessionStateImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {List<QuizQuestion> questions,
      int currentQuestionIndex,
      Map<int, dynamic> answers,
      int remainingSeconds,
      QuizStatus status});
}

/// @nodoc
class __$$QuizSessionStateImplCopyWithImpl<$Res>
    extends _$QuizSessionStateCopyWithImpl<$Res, _$QuizSessionStateImpl>
    implements _$$QuizSessionStateImplCopyWith<$Res> {
  __$$QuizSessionStateImplCopyWithImpl(_$QuizSessionStateImpl _value,
      $Res Function(_$QuizSessionStateImpl) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? questions = null,
    Object? currentQuestionIndex = null,
    Object? answers = null,
    Object? remainingSeconds = null,
    Object? status = null,
  }) {
    return _then(_$QuizSessionStateImpl(
      questions: null == questions
          ? _value._questions
          : questions // ignore: cast_nullable_to_non_nullable
              as List<QuizQuestion>,
      currentQuestionIndex: null == currentQuestionIndex
          ? _value.currentQuestionIndex
          : currentQuestionIndex // ignore: cast_nullable_to_non_nullable
              as int,
      answers: null == answers
          ? _value._answers
          : answers // ignore: cast_nullable_to_non_nullable
              as Map<int, dynamic>,
      remainingSeconds: null == remainingSeconds
          ? _value.remainingSeconds
          : remainingSeconds // ignore: cast_nullable_to_non_nullable
              as int,
      status: null == status
          ? _value.status
          : status // ignore: cast_nullable_to_non_nullable
              as QuizStatus,
    ));
  }
}

/// @nodoc

class _$QuizSessionStateImpl extends _QuizSessionState {
  const _$QuizSessionStateImpl(
      {required final List<QuizQuestion> questions,
      required this.currentQuestionIndex,
      required final Map<int, dynamic> answers,
      required this.remainingSeconds,
      required this.status})
      : _questions = questions,
        _answers = answers,
        super._();

  /// List of questions in this quiz session
  final List<QuizQuestion> _questions;

  /// List of questions in this quiz session
  @override
  List<QuizQuestion> get questions {
    if (_questions is EqualUnmodifiableListView) return _questions;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_questions);
  }

  /// Current question index (0-based)
  @override
  final int currentQuestionIndex;

  /// Map of question ID to answer(s)
  /// - SingleChoice: int (selected option ID)
  /// - MultipleChoice: Set<int> (selected option IDs)
  /// - OpenText: String (user's text answer)
  final Map<int, dynamic> _answers;

  /// Map of question ID to answer(s)
  /// - SingleChoice: int (selected option ID)
  /// - MultipleChoice: Set<int> (selected option IDs)
  /// - OpenText: String (user's text answer)
  @override
  Map<int, dynamic> get answers {
    if (_answers is EqualUnmodifiableMapView) return _answers;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableMapView(_answers);
  }

  /// Remaining time in seconds
  @override
  final int remainingSeconds;

  /// Current quiz status
  @override
  final QuizStatus status;

  @override
  String toString() {
    return 'QuizSessionState(questions: $questions, currentQuestionIndex: $currentQuestionIndex, answers: $answers, remainingSeconds: $remainingSeconds, status: $status)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$QuizSessionStateImpl &&
            const DeepCollectionEquality()
                .equals(other._questions, _questions) &&
            (identical(other.currentQuestionIndex, currentQuestionIndex) ||
                other.currentQuestionIndex == currentQuestionIndex) &&
            const DeepCollectionEquality().equals(other._answers, _answers) &&
            (identical(other.remainingSeconds, remainingSeconds) ||
                other.remainingSeconds == remainingSeconds) &&
            (identical(other.status, status) || other.status == status));
  }

  @override
  int get hashCode => Object.hash(
      runtimeType,
      const DeepCollectionEquality().hash(_questions),
      currentQuestionIndex,
      const DeepCollectionEquality().hash(_answers),
      remainingSeconds,
      status);

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$QuizSessionStateImplCopyWith<_$QuizSessionStateImpl> get copyWith =>
      __$$QuizSessionStateImplCopyWithImpl<_$QuizSessionStateImpl>(
          this, _$identity);
}

abstract class _QuizSessionState extends QuizSessionState {
  const factory _QuizSessionState(
      {required final List<QuizQuestion> questions,
      required final int currentQuestionIndex,
      required final Map<int, dynamic> answers,
      required final int remainingSeconds,
      required final QuizStatus status}) = _$QuizSessionStateImpl;
  const _QuizSessionState._() : super._();

  @override

  /// List of questions in this quiz session
  List<QuizQuestion> get questions;
  @override

  /// Current question index (0-based)
  int get currentQuestionIndex;
  @override

  /// Map of question ID to answer(s)
  /// - SingleChoice: int (selected option ID)
  /// - MultipleChoice: Set<int> (selected option IDs)
  /// - OpenText: String (user's text answer)
  Map<int, dynamic> get answers;
  @override

  /// Remaining time in seconds
  int get remainingSeconds;
  @override

  /// Current quiz status
  QuizStatus get status;
  @override
  @JsonKey(ignore: true)
  _$$QuizSessionStateImplCopyWith<_$QuizSessionStateImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
