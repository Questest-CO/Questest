# Architecture Analysis: Quiz Result Screen Implementation

## Executive Summary

The `QuizResultPage` already exists but is **not integrated** into the navigation flow. The current implementation shows a completion dialog instead. To implement the result screen properly, you need to:

1. **Add correct answer tracking** to `QuizQuestion` model or create a scoring utility
2. **Replace the completion dialog** with navigation to `QuizResultPage`
3. **Calculate the score** from `QuizSessionState` answers

---

## 1. State Management

### Current Architecture

**Provider**: `quizControllerProvider` (Riverpod `StateNotifier`)

**Location**: `lib/features/quiz/providers/quiz_controller.dart`

**State Model**: `QuizSessionState` (Freezed immutable class)

**Location**: `lib/features/quiz/domain/quiz_session_state.dart`

### Key Properties

```dart
QuizSessionState {
  List<QuizQuestion> questions,           // All questions in the quiz
  int currentQuestionIndex,                // Current position
  Map<int, dynamic> answers,               // Question ID → User Answer
  int remainingSeconds,                    // Timer
  QuizStatus status,                       // initial | inProgress | paused | completed
}
```

### Answer Storage Format

- **SingleChoice**: `answers[questionId] = int` (selected option ID)
- **MultipleChoice**: `answers[questionId] = Set<int>` (selected option IDs)
- **OpenText**: `answers[questionId] = String` (user's text answer)

### Accessing Final State

```dart
final quizState = ref.watch(quizControllerProvider);
// Or read without watching:
final quizState = ref.read(quizControllerProvider);

// Access answers:
final userAnswer = quizState.answers[questionId];
```

---

## 2. Models

### Current Models

**`QuizQuestion`** (`lib/features/quiz/models/quiz_question.dart`)
```dart
class QuizQuestion {
  final int id;
  final String content;
  final QuestionType type;           // singleChoice | multipleChoice | openText
  final List<AnswerOption>? options; // null for openText
  final String? hint;
}

class AnswerOption {
  final int id;
  final String content;
  // ⚠️ MISSING: isCorrect flag!
}
```

**`QuestionnaireDetailModel`** (`lib/core/models/oracle/questionnaire_detail_model.dart`)
```dart
class QuestionnaireOption {
  required int id,
  required String content,
  @JsonKey(name: 'is_correct') bool? isCorrect,  // ✅ This has correct flag
}
```

### Problem Identified

❌ **Critical Issue**: When mapping `QuestionnaireDetailModel` → `QuizQuestion` in `quiz_questions_provider.dart`, the `isCorrect` flag is **lost**. The `AnswerOption` class doesn't store it.

**Current Mapping** (`lib/features/quiz/providers/quiz_questions_provider.dart:54-57`):
```dart
options: options.map((o) => AnswerOption(
  id: o.id,
  content: o.content,
  // ❌ isCorrect is missing!
)).toList(),
```

### Solution Options

**Option A** (Recommended): Add `isCorrect` to `AnswerOption`
```dart
class AnswerOption {
  final int id;
  final String content;
  final bool? isCorrect;  // Add this
}
```

**Option B**: Create a separate `Map<int, Set<int>>` of correct option IDs per question

**Option C**: Store original `QuestionnaireDetailModel` and use it for scoring

---

## 3. Navigation

### Current Flow

**Location**: `lib/features/quiz/presentation/pages/quiz_solving_page.dart`

**Current Behavior** (line 293-354):
- When quiz completes (`status == QuizStatus.completed`), shows a **dialog** (`_showCompletionDialog`)
- Dialog shows basic summary (questions, answers, time)
- User clicks "Zakończ" → pops dialog and navigates back to home

**`QuizResultPage` Status**:
- ✅ File exists: `lib/features/quiz/presentation/pages/quiz_result_page.dart`
- ❌ **Not used anywhere** in the codebase
- ✅ UI is complete (donut chart, dynamic messages, buttons)

### Required Changes

**Replace dialog with navigation**:

```dart
// In quiz_solving_page.dart, replace _showCompletionDialog with:
void _navigateToResult(QuizSessionState quizState) {
  // Calculate score first
  final score = calculateScore(quizState);
  
  Navigator.of(context).pushReplacement(
    MaterialPageRoute(
      builder: (context) => QuizResultPage(
        scorePercent: score.percentage,
        correctAnswers: score.correctCount,
        totalQuestions: quizState.totalQuestions,
      ),
    ),
  );
}
```

---

## 4. Theme & Colors

### Location
`lib/core/theme/app_theme.dart`

### Available Colors

```dart
AppTheme.primaryColor     // #6C5CE7 (Purple) - Used for correct answers
AppTheme.successColor     // #00B894 (Green) - Success states
AppTheme.errorColor       // #D63031 (Red) - Error/incorrect states
AppTheme.dividerColor     // #DFE6E9 (Light gray) - Used for incorrect in donut
AppTheme.accentColor      // #00D9FF (Cyan) - Accents
```

### Current Usage in `QuizResultPage`

The donut chart uses:
- **Correct**: `AppTheme.primaryColor` (purple)
- **Incorrect**: `AppTheme.dividerColor` (light gray)

**Note**: Consider using `AppTheme.errorColor` or `AppTheme.successColor` for better visual distinction.

---

## 5. Scoring Logic

### What Needs to be Implemented

Create a scoring utility that:
1. Takes `QuizSessionState` (with user answers)
2. Takes original questions with correct answer information
3. Compares answers and calculates:
   - Correct count
   - Percentage score
   - Per-question correctness (optional, for detailed review)

### Suggested Implementation Location

Create: `lib/features/quiz/utils/quiz_scorer.dart`

```dart
class QuizScore {
  final int correctCount;
  final int totalQuestions;
  final double percentage;
  final Map<int, bool> questionResults; // questionId → isCorrect
}

QuizScore calculateScore(
  QuizSessionState quizState,
  QuestionnaireDetailModel originalDetail, // Need to pass this
) {
  // Implementation:
  // 1. For each question, get user answer from quizState.answers
  // 2. Compare with correct answers from originalDetail
  // 3. Return QuizScore
}
```

### Challenge

You'll need access to the **original `QuestionnaireDetailModel`** with `isCorrect` flags. Options:

1. **Store in QuizSessionState**: Add `QuestionnaireDetailModel? originalDetail` field
2. **Store correct answers map**: Create `Map<int, Set<int>> correctAnswersMap` in state
3. **Fetch again**: Re-fetch questionnaire details in result screen (inefficient)

---

## 6. Recommended File Structure

### Current Structure
```
lib/features/quiz/
├── domain/
│   └── quiz_session_state.dart          ✅ State definition
├── models/
│   └── quiz_question.dart                ⚠️ Needs isCorrect
├── presentation/
│   ├── pages/
│   │   ├── quiz_solving_page.dart       ⚠️ Needs navigation update
│   │   └── quiz_result_page.dart        ✅ Already exists
│   └── widgets/
├── providers/
│   ├── quiz_controller.dart              ✅ State management
│   └── quiz_questions_provider.dart      ⚠️ Loses isCorrect data
└── utils/                                ❌ Create this folder
    └── quiz_scorer.dart                  ❌ NEW: Scoring logic
```

---

## 7. Implementation Steps

### Step 1: Fix Data Loss
- Add `isCorrect` to `AnswerOption` model
- Update `quiz_questions_provider.dart` to preserve `isCorrect` flag

### Step 2: Create Scoring Utility
- Create `lib/features/quiz/utils/quiz_scorer.dart`
- Implement `calculateScore()` function

### Step 3: Update Navigation
- Modify `quiz_solving_page.dart`:
  - Replace `_showCompletionDialog` with `_navigateToResult`
  - Calculate score before navigation
  - Navigate to `QuizResultPage`

### Step 4: Update QuizResultPage (if needed)
- Verify it receives correct data
- Ensure donut chart uses appropriate colors
- Test with different score ranges

---

## 8. Key Files to Modify

1. ✅ **`lib/features/quiz/models/quiz_question.dart`**
   - Add `isCorrect` to `AnswerOption`

2. ✅ **`lib/features/quiz/providers/quiz_questions_provider.dart`**
   - Preserve `isCorrect` when mapping

3. ✅ **`lib/features/quiz/presentation/pages/quiz_solving_page.dart`**
   - Replace dialog with navigation
   - Add score calculation

4. ✅ **`lib/features/quiz/utils/quiz_scorer.dart`** (NEW)
   - Scoring logic

5. ✅ **`lib/features/quiz/presentation/pages/quiz_result_page.dart`**
   - May need minor adjustments (colors, data binding)

---

## Summary

✅ **Good News**: The UI for `QuizResultPage` is already implemented with donut chart and dynamic messages.

⚠️ **Issues to Fix**:
1. Correct answer information is lost during data mapping
2. Navigation goes to dialog instead of result screen
3. Scoring logic doesn't exist yet

🎯 **Recommended Approach**:
1. Add `isCorrect` to models
2. Create scoring utility
3. Update navigation flow
4. Test end-to-end

The existing codebase is well-structured and follows good patterns. The main work is connecting the pieces and preserving the correct answer data throughout the quiz flow.

