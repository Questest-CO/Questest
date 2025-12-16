// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'quiz_controller.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

String _$quizControllerHash() => r'1ec2abdfb447efa1414a907dc355ffe5341d7292';

/// Controller for managing quiz session state and logic
/// Handles timer, answer selection, and navigation between questions
///
/// Copied from [QuizController].
@ProviderFor(QuizController)
final quizControllerProvider =
    AutoDisposeNotifierProvider<QuizController, QuizSessionState>.internal(
  QuizController.new,
  name: r'quizControllerProvider',
  debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
      ? null
      : _$quizControllerHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

typedef _$QuizController = AutoDisposeNotifier<QuizSessionState>;
// ignore_for_file: type=lint
// ignore_for_file: subtype_of_sealed_class, invalid_use_of_internal_member, invalid_use_of_visible_for_testing_member
