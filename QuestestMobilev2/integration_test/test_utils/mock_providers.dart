import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:mocktail/mocktail.dart';
import 'package:questest/core/models/quiz_model.dart';
import 'package:questest/features/auth/presentation/controllers/login_controller.dart';
import 'package:questest/features/auth/presentation/controllers/register_controller.dart';
import 'package:questest/features/auth/presentation/providers/auth_providers.dart';
import 'package:questest/features/home/providers/quiz_provider.dart';
import 'package:questest/features/quiz/models/quiz_question.dart';
import 'package:questest/features/quiz/providers/quiz_questions_provider.dart';
import 'package:questest/features/ranking/models/ranking_entry.dart';
import 'package:questest/features/ranking/providers/ranking_providers.dart';

// === Mock Classes ===

class MockFirebaseAuth extends Mock implements FirebaseAuth {}

class MockGoogleSignIn extends Mock implements GoogleSignIn {}

class MockUser extends Mock implements User {
  @override
  String get uid => 'test-user-id';

  @override
  String? get email => 'test@example.com';

  @override
  String? get displayName => 'Test User';

  @override
  bool get emailVerified => true;
}

class MockUserCredential extends Mock implements UserCredential {}

// === Mock Data ===

/// Mock quiz list for testing
List<QuizModel> get mockQuizzes => [
      const QuizModel(
        id: '1',
        title: 'Test Quiz: Podstawy Fluttera',
        subtitle: 'Sprawdź swoją wiedzę o Flutterze',
        thumbnailUrl: 'https://images.unsplash.com/photo-1555949963-ff9fe0c870eb?w=800',
        questionCount: 5,
        participantsCount: 120,
        difficulty: 'Średni',
        category: 'Programowanie',
        timeLimit: 300,
      ),
      const QuizModel(
        id: '2',
        title: 'Test Quiz: Dart Fundamentals',
        subtitle: 'Podstawy języka Dart',
        thumbnailUrl: 'https://images.unsplash.com/photo-1516116216624-53e697fedbea?w=800',
        questionCount: 3,
        participantsCount: 85,
        difficulty: 'Łatwy',
        category: 'Programowanie',
        timeLimit: 180,
      ),
    ];

/// Mock questions for quiz ID "1"
List<QuizQuestion> get mockQuestionsForQuiz1 => [
      const QuizQuestion(
        id: 101,
        content: 'Co to jest Widget w Flutterze?',
        type: QuestionType.singleChoice,
        options: [
          AnswerOption(
            id: 1,
            content: 'Element interfejsu użytkownika',
            isCorrect: true,
          ),
          AnswerOption(
            id: 2,
            content: 'Typ bazy danych',
            isCorrect: false,
          ),
          AnswerOption(
            id: 3,
            content: 'Protokół sieciowy',
            isCorrect: false,
          ),
          AnswerOption(
            id: 4,
            content: 'System plików',
            isCorrect: false,
          ),
        ],
      ),
      const QuizQuestion(
        id: 102,
        content: 'Które z poniższych są typami Widgetów? (wybierz wszystkie)',
        type: QuestionType.multipleChoice,
        options: [
          AnswerOption(
            id: 5,
            content: 'StatelessWidget',
            isCorrect: true,
          ),
          AnswerOption(
            id: 6,
            content: 'StatefulWidget',
            isCorrect: true,
          ),
          AnswerOption(
            id: 7,
            content: 'DynamicWidget',
            isCorrect: false,
          ),
          AnswerOption(
            id: 8,
            content: 'InheritedWidget',
            isCorrect: true,
          ),
        ],
      ),
      const QuizQuestion(
        id: 103,
        content: 'Jaki jest główny język programowania używany we Flutterze?',
        type: QuestionType.singleChoice,
        options: [
          AnswerOption(
            id: 9,
            content: 'Dart',
            isCorrect: true,
          ),
          AnswerOption(
            id: 10,
            content: 'JavaScript',
            isCorrect: false,
          ),
          AnswerOption(
            id: 11,
            content: 'Kotlin',
            isCorrect: false,
          ),
          AnswerOption(
            id: 12,
            content: 'Swift',
            isCorrect: false,
          ),
        ],
      ),
      const QuizQuestion(
        id: 104,
        content: 'Do czego służy metoda setState()?',
        type: QuestionType.singleChoice,
        options: [
          AnswerOption(
            id: 13,
            content: 'Do odświeżenia interfejsu po zmianie stanu',
            isCorrect: true,
          ),
          AnswerOption(
            id: 14,
            content: 'Do tworzenia nowego widgetu',
            isCorrect: false,
          ),
          AnswerOption(
            id: 15,
            content: 'Do nawigacji między ekranami',
            isCorrect: false,
          ),
          AnswerOption(
            id: 16,
            content: 'Do zapisu danych w bazie',
            isCorrect: false,
          ),
        ],
      ),
      const QuizQuestion(
        id: 105,
        content: 'Opisz własnymi słowami, czym jest hot reload we Flutterze.',
        type: QuestionType.openText,
        options: null,
        hint: 'Podaj krótką definicję i korzyści',
      ),
    ];

/// Mock ranking entries for testing
List<RankingEntry> get mockRankingEntries => [
      const RankingEntry(
        position: 1,
        displayName: 'TopPlayer',
        points: 9850,
        quizzesPlayed: 42,
        avatarUrl: 'https://i.pravatar.cc/150?u=1',
        userEmail: 'top@example.com',
      ),
      const RankingEntry(
        position: 2,
        displayName: 'TestUser',
        points: 7500,
        quizzesPlayed: 35,
        avatarUrl: 'https://i.pravatar.cc/150?u=2',
        userEmail: 'test@example.com',
      ),
      const RankingEntry(
        position: 3,
        displayName: 'QuizMaster',
        points: 5200,
        quizzesPlayed: 28,
        avatarUrl: 'https://i.pravatar.cc/150?u=3',
        userEmail: 'master@example.com',
      ),
    ];

/// Mock questions for quiz ID "2"
List<QuizQuestion> get mockQuestionsForQuiz2 => [
      const QuizQuestion(
        id: 201,
        content: 'Jaki jest typ zmiennej var w Dart?',
        type: QuestionType.singleChoice,
        options: [
          AnswerOption(
            id: 17,
            content: 'Inferowany na podstawie wartości',
            isCorrect: true,
          ),
          AnswerOption(
            id: 18,
            content: 'Zawsze String',
            isCorrect: false,
          ),
          AnswerOption(
            id: 19,
            content: 'Zawsze dynamic',
            isCorrect: false,
          ),
        ],
      ),
      const QuizQuestion(
        id: 202,
        content: 'Czym różni się final od const w Dart?',
        type: QuestionType.singleChoice,
        options: [
          AnswerOption(
            id: 20,
            content: 'final jest ustalany w runtime, const w compile-time',
            isCorrect: true,
          ),
          AnswerOption(
            id: 21,
            content: 'Nie ma różnicy',
            isCorrect: false,
          ),
          AnswerOption(
            id: 22,
            content: 'const można zmieniać',
            isCorrect: false,
          ),
        ],
      ),
      const QuizQuestion(
        id: 203,
        content: 'Co zwraca funkcja async w Dart?',
        type: QuestionType.singleChoice,
        options: [
          AnswerOption(
            id: 23,
            content: 'Future',
            isCorrect: true,
          ),
          AnswerOption(
            id: 24,
            content: 'Stream',
            isCorrect: false,
          ),
          AnswerOption(
            id: 25,
            content: 'void',
            isCorrect: false,
          ),
        ],
      ),
    ];

// === Provider Overrides ===

/// Creates mock FirebaseAuth that simulates logged-in user
MockFirebaseAuth _createMockFirebaseAuth({User? currentUser}) {
  final mockAuth = MockFirebaseAuth();

  when(() => mockAuth.currentUser).thenReturn(currentUser);
  when(() => mockAuth.authStateChanges()).thenAnswer((_) => Stream.value(currentUser));

  if (currentUser != null) {
    // Mock sign in methods
    when(() => mockAuth.signInWithEmailAndPassword(
          email: any(named: 'email'),
          password: any(named: 'password'),
        )).thenAnswer((_) async {
      final cred = MockUserCredential();
      when(() => cred.user).thenReturn(currentUser);
      return cred;
    });
  }

  return mockAuth;
}

/// Creates mock GoogleSignIn
MockGoogleSignIn _createMockGoogleSignIn() {
  final mockGoogleSignIn = MockGoogleSignIn();
  when(() => mockGoogleSignIn.signIn()).thenAnswer((_) async => null);
  return mockGoogleSignIn;
}

/// Creates provider overrides for testing with a logged-in user
List<Override> createAuthenticatedOverrides() {
  final mockUser = MockUser();
  final mockAuth = _createMockFirebaseAuth(currentUser: mockUser);
  final mockGoogleSignIn = _createMockGoogleSignIn();

  return [
    // Override Firebase providers
    firebaseAuthProvider.overrideWithValue(mockAuth),
    googleSignInProvider.overrideWithValue(mockGoogleSignIn),

    // Override auth state to return a logged-in user
    authStateChangesProvider.overrideWith((ref) {
      return Stream.value(mockUser);
    }),

    // Override quizzes provider with mock data
    quizzesProvider.overrideWith((ref) async {
      await Future.delayed(const Duration(milliseconds: 100));
      return mockQuizzes;
    }),

    // Override quiz questions provider
    quizQuestionsProvider.overrideWith((ref, quizId) async {
      await Future.delayed(const Duration(milliseconds: 100));
      switch (quizId) {
        case '1':
          return mockQuestionsForQuiz1;
        case '2':
          return mockQuestionsForQuiz2;
        default:
          return [];
      }
    }),

    // Override ranking provider with mock data
    rankingProvider.overrideWith((ref) async {
      await Future.delayed(const Duration(milliseconds: 100));
      return mockRankingEntries;
    }),
  ];
}

/// Creates provider overrides for testing unauthenticated state
List<Override> createUnauthenticatedOverrides() {
  final mockAuth = _createMockFirebaseAuth(currentUser: null);
  final mockGoogleSignIn = _createMockGoogleSignIn();

  return [
    firebaseAuthProvider.overrideWithValue(mockAuth),
    googleSignInProvider.overrideWithValue(mockGoogleSignIn),
    authStateChangesProvider.overrideWith((ref) {
      return Stream.value(null);
    }),
  ];
}

/// Creates provider overrides for testing registration flow
List<Override> createRegistrationTestOverrides() {
  final mockAuth = _createMockFirebaseAuth(currentUser: null);
  final mockGoogleSignIn = _createMockGoogleSignIn();

  // Setup mock for createUserWithEmailAndPassword
  when(() => mockAuth.createUserWithEmailAndPassword(
        email: any(named: 'email'),
        password: any(named: 'password'),
      )).thenAnswer((_) async {
    final mockUser = MockUser();
    final cred = MockUserCredential();
    when(() => cred.user).thenReturn(mockUser);
    return cred;
  });

  return [
    firebaseAuthProvider.overrideWithValue(mockAuth),
    googleSignInProvider.overrideWithValue(mockGoogleSignIn),
    authStateChangesProvider.overrideWith((ref) {
      // Start with unauthenticated state
      return Stream.value(null);
    }),
  ];
}

