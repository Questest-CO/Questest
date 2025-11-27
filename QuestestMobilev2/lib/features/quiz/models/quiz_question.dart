/// Question type enum for quiz questions
enum QuestionType {
  singleChoice,
  multipleChoice,
  openText,
}

/// Model representing a single answer option
class AnswerOption {
  final int id;
  final String content;

  const AnswerOption({
    required this.id,
    required this.content,
  });
}

/// Model representing a quiz question
class QuizQuestion {
  final int id;
  final String content;
  final QuestionType type;
  final List<AnswerOption>? options; // null for openText type
  final String? hint; // Optional hint for the question

  const QuizQuestion({
    required this.id,
    required this.content,
    required this.type,
    this.options,
    this.hint,
  });
}

/// Mock data for testing the quiz solving UI
class MockQuizData {
  static const String quizTitle = 'Historia Polski';
  static const int timeLimit = 899; // 14:59 in seconds

  static const List<QuizQuestion> questions = [
    // Question 1: Single Choice
    QuizQuestion(
      id: 1,
      content: 'W którym roku odbyła się Bitwa pod Grunwaldem?',
      type: QuestionType.singleChoice,
      options: [
        AnswerOption(id: 1, content: '1385'),
        AnswerOption(id: 2, content: '1410'),
        AnswerOption(id: 3, content: '1466'),
        AnswerOption(id: 4, content: '1525'),
      ],
    ),

    // Question 2: Multiple Choice
    QuizQuestion(
      id: 2,
      content: 'Które z poniższych państw graniczyły z Polską w okresie międzywojennym (1918-1939)?',
      type: QuestionType.multipleChoice,
      hint: 'Wybierz wszystkie poprawne odpowiedzi',
      options: [
        AnswerOption(id: 1, content: 'Niemcy'),
        AnswerOption(id: 2, content: 'Czechosłowacja'),
        AnswerOption(id: 3, content: 'ZSRR'),
        AnswerOption(id: 4, content: 'Węgry'),
        AnswerOption(id: 5, content: 'Litwa'),
        AnswerOption(id: 6, content: 'Austria'),
      ],
    ),

    // Question 3: Open Text
    QuizQuestion(
      id: 3,
      content: 'Wymień trzech królów z dynastii Jagiellonów.',
      type: QuestionType.openText,
      hint: 'Oddziel imiona przecinkami',
    ),

    // Question 4: Single Choice
    QuizQuestion(
      id: 4,
      content: 'Kto był pierwszym królem Polski?',
      type: QuestionType.singleChoice,
      options: [
        AnswerOption(id: 1, content: 'Mieszko I'),
        AnswerOption(id: 2, content: 'Bolesław Chrobry'),
        AnswerOption(id: 3, content: 'Kazimierz Wielki'),
        AnswerOption(id: 4, content: 'Władysław Łokietek'),
      ],
    ),

    // Question 5: Multiple Choice
    QuizQuestion(
      id: 5,
      content: 'Które wydarzenia miały miejsce w XX wieku?',
      type: QuestionType.multipleChoice,
      options: [
        AnswerOption(id: 1, content: 'Odzyskanie niepodległości'),
        AnswerOption(id: 2, content: 'Bitwa Warszawska 1920'),
        AnswerOption(id: 3, content: 'Powstanie Styczniowe'),
        AnswerOption(id: 4, content: 'Wstąpienie do NATO'),
        AnswerOption(id: 5, content: 'Rozbiory Polski'),
      ],
    ),
  ];
}

