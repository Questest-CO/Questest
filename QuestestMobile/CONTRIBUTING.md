# Przewodnik Kontrybutora - Questest

Dziękujemy za zainteresowanie wkładem w projekt Questest! Ten dokument zawiera wytyczne dotyczące procesu rozwoju, strategii Git oraz standardów kodowania.

---

## 📋 Spis Treści

1. [Git Strategy](#git-strategy)
2. [Proces Pull Request](#proces-pull-request)
3. [Standardy Kodowania](#standardy-kodowania)
4. [Code Review](#code-review)
5. [Testowanie](#testowanie)
6. [Komunikacja](#komunikacja)

---

## 🔀 Git Strategy

### Struktura Branchy

Projekt wykorzystuje **Git Flow** z następującymi głównymi gałęziami:

#### Główne Gałęzie

- **`main`** (lub `master`)
  - Zawiera stabilny, produkcyjny kod
  - **BEZWZGLĘDNY ZAKAZ** bezpośredniego pushowania
  - **ZAKAZ** force push (`git push --force`)
  - Zmiany tylko przez zatwierdzone Pull Requesty
  - Każdy commit = potencjalny release

- **`develop`**
  - Główna gałąź rozwojowa
  - Integracja wszystkich feature'ów
  - Zawsze w stanie "gotowym do testowania"
  - Baza dla wszystkich feature branches

#### Gałęzie Robocze

##### Feature Branches
- **Nazwa**: `feature/<ticket-id>-<krotki-opis>`
- **Przykłady**: 
  - `feature/QUEST-123-user-authentication`
  - `feature/QUEST-456-quiz-timer`
- **Baza**: `develop`
- **Merge do**: `develop`
- **Cykl życia**: Usuwane po zmergowaniu

```bash
# Tworzenie feature branch
git checkout develop
git pull origin develop
git checkout -b feature/QUEST-123-user-authentication
```

##### Bugfix Branches
- **Nazwa**: `bugfix/<ticket-id>-<krotki-opis>`
- **Przykłady**: 
  - `bugfix/QUEST-789-fix-login-crash`
  - `bugfix/QUEST-234-correct-score-calculation`
- **Baza**: `develop`
- **Merge do**: `develop`

```bash
# Tworzenie bugfix branch
git checkout develop
git pull origin develop
git checkout -b bugfix/QUEST-789-fix-login-crash
```

##### Hotfix Branches
- **Nazwa**: `hotfix/<wersja>-<krotki-opis>`
- **Przykłady**: `hotfix/1.0.1-critical-security-fix`
- **Baza**: `main`
- **Merge do**: `main` **i** `develop`
- **Użycie**: Tylko krytyczne błędy w produkcji

```bash
# Tworzenie hotfix branch
git checkout main
git pull origin main
git checkout -b hotfix/1.0.1-critical-security-fix
```

##### Release Branches
- **Nazwa**: `release/<wersja>`
- **Przykłady**: `release/1.0.0`, `release/1.1.0`
- **Baza**: `develop`
- **Merge do**: `main` **i** `develop`
- **Użycie**: Przygotowanie do wydania

```bash
# Tworzenie release branch
git checkout develop
git pull origin develop
git checkout -b release/1.0.0
```

### Konwencje Commitów

Używamy **Conventional Commits** dla czytelnej historii:

#### Format

```
<typ>(<zakres>): <krótki opis>

<dłuższy opis - opcjonalny>

<footer - opcjonalny>
```

#### Typy Commitów

| Typ | Opis | Przykład |
|-----|------|----------|
| `feat` | Nowa funkcjonalność | `feat(auth): dodaj logowanie przez Google` |
| `fix` | Naprawa błędu | `fix(quiz): popraw liczenie punktów` |
| `docs` | Zmiany w dokumentacji | `docs(readme): zaktualizuj instrukcję instalacji` |
| `style` | Formatowanie kodu (bez zmian logiki) | `style(button): popraw wcięcia` |
| `refactor` | Refaktoryzacja (bez nowych funkcji ani fixów) | `refactor(api): uprość klienta HTTP` |
| `test` | Dodanie lub modyfikacja testów | `test(quiz): dodaj testy jednostkowe` |
| `chore` | Zmiany w procesie buildu, zależnościach | `chore(deps): zaktualizuj riverpod do 2.5.1` |
| `perf` | Poprawa wydajności | `perf(home): zoptymalizuj renderowanie listy` |

#### Przykłady Dobrych Commitów

```bash
feat(auth): implementuj logowanie z email i hasłem

Dodano:
- Formularz logowania
- Walidację inputów
- Obsługę błędów sieciowych
- Provider do zarządzania stanem auth

Closes QUEST-123
```

```bash
fix(quiz): napraw crash przy pustej liście pytań

Problem występował gdy quiz nie miał przypisanych pytań.
Dodano sprawdzenie przed próbą dostępu do pierwszego elementu.

Fixes QUEST-456
```

```bash
docs(contributing): dodaj Git Strategy do przewodnika

Opisano:
- Strukturę branchy
- Konwencje nazewnictwa
- Proces pull request
```

#### Złe Praktyki ❌

```bash
# ZA MAŁO OPISOWE
git commit -m "fix"
git commit -m "zmiany"
git commit -m "wip"

# ZBYT DUŻE COMMITY
git commit -m "dodaj auth, quiz, profile i settings"

# BRAK TYPU
git commit -m "naprawiono bug"
```

### Proces Pracy z Git

#### 1. Przed Rozpoczęciem Pracy

```bash
# Upewnij się, że masz najnowszą wersję develop
git checkout develop
git pull origin develop

# Stwórz nowy branch
git checkout -b feature/QUEST-123-moja-funkcja
```

#### 2. Podczas Pracy

```bash
# Commituj często, małe logiczne zmiany
git add <pliki>
git commit -m "feat(feature): dodaj część 1"

# Regularnie synchronizuj z develop
git fetch origin
git rebase origin/develop
```

#### 3. Przed Pull Requestem

```bash
# Zaktualizuj z develop
git checkout develop
git pull origin develop
git checkout feature/QUEST-123-moja-funkcja
git rebase develop

# Sprawdź czy wszystko działa
flutter test
flutter analyze

# Push do remote
git push origin feature/QUEST-123-moja-funkcja
```

### Zasady Bezpieczeństwa Git

#### ✅ DOZWOLONE

- Feature branches z `develop`
- Pull Requesty do `develop`
- Rebase lokalnie przed pushem
- Squash commitów w feature branches
- Cherry-pick dla hotfixów

#### ❌ ZABRONIONE

- **Bezpośredni push do `main`/`master`**
  ```bash
  # NIE RÓB TEGO!
  git push origin main
  ```

- **Force push do `main`/`develop`**
  ```bash
  # NIE RÓB TEGO!
  git push --force origin main
  git push -f origin develop
  ```

- **Pomijanie hooków**
  ```bash
  # NIE RÓB TEGO!
  git commit --no-verify
  git push --no-verify
  ```

- **Commit bezpośrednio na `main`/`develop`**
  ```bash
  # NIE RÓB TEGO!
  git checkout main
  git commit -m "quick fix"
  ```

- **Merge `main` do `develop` (odwrotnie niż powinno być)**

#### Ochrona Gałęzi

Gałęzie `main` i `develop` są chronione przez:
- Wymagany Pull Request z minimum 1 approval
- Wymagane przejście CI/CD
- Zakaz force push
- Zakaz usuwania
- Wymagane testy jednostkowe

---

## 🔄 Proces Pull Request

### 1. Tworzenie Pull Requesta

#### Przed Utworzeniem PR

```bash
# Checklist
☐ Kod skompilowany bez błędów
☐ Wszystkie testy przechodzą (flutter test)
☐ Brak błędów w analizie (flutter analyze)
☐ Zaktualizowano z develop
☐ Zaktualizowano dokumentację (jeśli potrzebne)
☐ Dodano/zaktualizowano testy
```

#### Tytuł PR

Format: `[TYP] QUEST-XXX: Krótki opis`

Przykłady:
```
[FEATURE] QUEST-123: Dodaj autentykację użytkownika
[BUGFIX] QUEST-456: Napraw crash w quizie
[REFACTOR] QUEST-789: Uprość strukturę providerów
```

#### Opis PR (Template)

```markdown
## Opis Zmian
Krótki opis tego, co zostało zrobione.

## Typ Zmiany
- [ ] Nowa funkcjonalność (feature)
- [ ] Naprawa błędu (bugfix)
- [ ] Refaktoryzacja (refactor)
- [ ] Dokumentacja (docs)
- [ ] Wydajność (perf)

## Powiązane Ticket
- Closes QUEST-XXX
- Related to QUEST-YYY

## Jak Przetestować
1. Uruchom aplikację
2. Przejdź do ekranu X
3. Kliknij przycisk Y
4. Sprawdź czy Z działa poprawnie

## Zrzuty Ekranu (jeśli dotyczy UI)
[Dodaj zrzuty ekranu]

## Checklist
- [ ] Kod jest zgodny ze standardami projektu
- [ ] Dodano testy jednostkowe/widgetowe
- [ ] Zaktualizowano dokumentację
- [ ] Wszystkie testy przechodzą
- [ ] Brak konfliktów z develop
- [ ] Code review przez siebie wykonany
```

### 2. Code Review

#### Dla Autora PR

- Odpowiadaj na komentarze w ciągu 24h
- Bądź otwarty na feedback
- Wyjaśniaj decyzje projektowe
- Nie bierz krytyki osobiście
- Aktualizuj PR zgodnie z uwagami

#### Dla Reviewera

- Review w ciągu 24-48h
- Bądź konstruktywny i profesjonalny
- Sprawdź:
  - Poprawność logiki
  - Zgodność z architekturą
  - Testy
  - Wydajność
  - Bezpieczeństwo
  - Czytelność kodu

#### Komentarze w Review

Używaj prefiksów:
- **MUST**: Wymagana zmiana przed merge
- **SHOULD**: Zalecana zmiana
- **OPTIONAL**: Sugestia, nie blokuje merge
- **QUESTION**: Pytanie o decyzję/implementację
- **PRAISE**: Pochwała dobrej praktyki

Przykłady:
```
MUST: Ten kod nie obsługuje przypadku gdy lista jest pusta

SHOULD: Rozważ użycie const constructor dla wydajności

OPTIONAL: Można by wydzielić to do osobnego widgetu

QUESTION: Czy ten timeout nie jest za krótki?

PRAISE: Świetne pokrycie testami!
```

### 3. Merge do Develop

#### Strategie Merge

**Dla Feature Branches:**
- Używamy **Squash and Merge**
- Wszystkie commity z brancha łączone w jeden czytelny commit
- Trzyma historię `develop` czystą

**Dla Release/Hotfix:**
- Używamy **Regular Merge**
- Zachowuje pełną historię
- Ważne dla śledzenia wersji

#### Po Zmergowaniu

```bash
# Usuń lokalny branch
git branch -d feature/QUEST-123-moja-funkcja

# Usuń remote branch (jeśli nie zrobiono przez GitHub)
git push origin --delete feature/QUEST-123-moja-funkcja

# Zaktualizuj develop
git checkout develop
git pull origin develop
```

---

## 💻 Standardy Kodowania

### Struktura Plików

```dart
// 1. Importy Dart
import 'dart:async';
import 'dart:convert';

// 2. Importy Flutter
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

// 3. Importy pakietów (alfabetycznie)
import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

// 4. Importy projektowe (alfabetycznie)
import '../models/quiz_model.dart';
import '../providers/quiz_provider.dart';
```

### Nazewnictwo

```dart
// Pliki: snake_case
quiz_card.dart
user_repository.dart

// Klasy: PascalCase
class QuizCard extends StatelessWidget {}
class UserRepository {}

// Zmienne i funkcje: camelCase
final quizList = [];
void fetchQuizzes() {}

// Stałe: camelCase lub SCREAMING_SNAKE_CASE
const defaultTimeout = 30;
const API_BASE_URL = 'https://api.example.com';

// Prywatne: prefix _
class _QuizCardState {}
void _handleSubmit() {}
```

### Dokumentacja Kodu

```dart
/// Pobiera listę quizów z API.
/// 
/// Zwraca [List<QuizModel>] z aktywnych quizów.
/// Rzuca [NetworkException] gdy brak połączenia.
/// 
/// Przykład użycia:
/// ```dart
/// final quizzes = await fetchQuizzes();
/// ```
Future<List<QuizModel>> fetchQuizzes() async {
  // Implementacja
}
```

### Clean Code

```dart
// ✅ DOBRZE: Znaczące nazwy
final activeQuizzes = quizzes.where((q) => q.isActive);

// ❌ ŹLE: Niejasne nazwy
final list = data.where((x) => x.flag);

// ✅ DOBRZE: Funkcje małe i konkretne
void submitQuiz() {
  validateAnswers();
  calculateScore();
  saveResult();
}

// ❌ ŹLE: Funkcja robi zbyt wiele
void doEverything() {
  // 200 linii kodu...
}
```

---

## 🧪 Testowanie

### Wymagania

- **Feature**: Minimum 70% pokrycia testami
- **Bugfix**: Test reprodukujący bug + test po naprawie
- **Refactor**: Wszystkie istniejące testy muszą przechodzić

### Uruchamianie Testów

```bash
# Wszystkie testy
flutter test

# Konkretny plik
flutter test test/unit/quiz_test.dart

# Z pokryciem
flutter test --coverage
```

### Typy Testów

```dart
// Test jednostkowy
test('calculateScore zwraca poprawny wynik', () {
  final score = calculateScore(correctAnswers: 8, total: 10);
  expect(score, 80);
});

// Test widgetu
testWidgets('QPrimaryButton wyświetla tekst', (tester) async {
  await tester.pumpWidget(
    MaterialApp(
      home: QPrimaryButton(text: 'Test', onPressed: () {}),
    ),
  );
  expect(find.text('Test'), findsOneWidget);
});
```

---

## 📝 Komunikacja

### Kanały

- **Daily Standup**: Codziennie 9:00
- **Slack**: Dla pilnych spraw
- **GitHub Issues**: Śledzenie tasków
- **PR Comments**: Dyskusje o kodzie

### Zgłaszanie Problemów

1. Sprawdź czy issue już nie istnieje
2. Użyj szablonu issue
3. Dodaj odpowiednie labele
4. Przypisz do milestone (jeśli wiesz)

---

## ❓ FAQ

**Q: Czy mogę pushować bezpośrednio do develop?**  
A: NIE. Wszystkie zmiany przez Pull Request.

**Q: Jak długo czekać na review?**  
A: Standardowo 24-48h. Jeśli pilne, oznacz jako urgent.

**Q: Czy mogę mergować swój własny PR?**  
A: NIE. Wymagane approval od innego dewelopera.

**Q: Co jeśli mój branch jest bardzo za develop?**  
A: Zrób rebase: `git rebase develop`, rozwiąż konflikty, force push do swojego brancha.

**Q: Czy mogę force push do mojego feature brancha?**  
A: TAK, ale tylko jeśli nikt inny na nim nie pracuje.

---

## 📚 Dodatkowe Zasoby

- [Git Flow Cheatsheet](https://danielkummer.github.io/git-flow-cheatsheet/)
- [Conventional Commits](https://www.conventionalcommits.org/)
- [Effective Dart](https://dart.dev/guides/language/effective-dart)
- [Flutter Best Practices](https://docs.flutter.dev/perf/best-practices)

---

## 🎯 Podsumowanie Najważniejszych Zasad

1. ✅ Wszystkie zmiany przez Pull Request
2. ❌ Bezpośredni push do `main`/`develop` ZABRONIONY
3. ❌ Force push do `main`/`develop` ZABRONIONY  
4. ✅ Feature branches z `develop`
5. ✅ Squash and merge dla features
6. ✅ Conventional commits
7. ✅ Code review obowiązkowy
8. ✅ Testy przed merge
9. ✅ Dokumentacja aktualizowana
10. ✅ Branch usuwany po merge

---

**Pytania? Skontaktuj się z Lead Architect!**

*Ostatnia aktualizacja: Sprint 1 - Listopad 2024*

