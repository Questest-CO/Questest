# 🚀 Witaj w Projekcie Questest!

## 📖 Zacznij Tutaj

Jeśli widzisz ten plik po raz pierwszy, przeczytaj poniższe kroki w kolejności:

---

## 1️⃣ Przeczytaj Dokumentację

### Musisz przeczytać (w tej kolejności):

1. **[README.md](README.md)** ⭐ NAJWAŻNIEJSZE
   - Opis projektu
   - **Jak uruchomić projekt** (szczegółowa instrukcja)
   - Struktura folderów
   - Architektura
   - Wszystkie podstawowe informacje

2. **[CONTRIBUTING.md](CONTRIBUTING.md)** ⭐ BARDZO WAŻNE
   - **Git Strategy** - zasady pracy z Git
   - Proces Pull Request
   - Konwencje commitów
   - Standardy kodowania
   - Code review

3. **[PRZEGLAD_PROJEKTU.md](PRZEGLAD_PROJEKTU.md)** 📊
   - Szybki przegląd
   - Lista wszystkich plików
   - Statystyki
   - Szybkie komendy

4. **[SPRINT1_PODSUMOWANIE.md](SPRINT1_PODSUMOWANIE.md)** 📝
   - Szczegółowe podsumowanie Sprintu 1
   - Co zostało zaimplementowane
   - Decyzje architektoniczne

---

## 2️⃣ Szybki Start (5 minut)

### Wymagania
- Flutter SDK 3.9.2+
- Node.js 16+
- IDE (VS Code lub Android Studio)

### Komendy

```bash
# Terminal 1 - Flutter App
cd questest
flutter pub get
dart run build_runner build --delete-conflicting-outputs
flutter run

# Terminal 2 - Mock API
cd questest/mock_api
npm install
npm start
```

**Gotowe!** Aplikacja powinna działać z Mock API pod http://localhost:3000

---

## 3️⃣ Najważniejsze Zasady

### ❌ ZABRONIONE (BARDZO WAŻNE!)

1. **NIE pushuj bezpośrednio do `main`**
   ```bash
   # ❌ NIGDY NIE RÓB TEGO!
   git checkout main
   git push origin main
   ```

2. **NIE używaj force push na `main` lub `develop`**
   ```bash
   # ❌ NIGDY NIE RÓB TEGO!
   git push --force origin main
   git push -f origin develop
   ```

3. **NIE commituj bez opisowej wiadomości**
   ```bash
   # ❌ ŹLE
   git commit -m "fix"
   git commit -m "wip"
   
   # ✅ DOBRZE
   git commit -m "feat(auth): dodaj logowanie przez email"
   ```

### ✅ ZAWSZE

1. **Twórz feature branch z `develop`**
   ```bash
   git checkout develop
   git pull origin develop
   git checkout -b feature/QUEST-123-moja-funkcja
   ```

2. **Wszystkie zmiany przez Pull Request**
   - Minimum 1 approval
   - CI/CD musi przejść
   - Testy muszą przechodzić

3. **Używaj Conventional Commits**
   ```bash
   feat(quiz): dodaj nową funkcjonalność
   fix(auth): napraw błąd logowania
   docs(readme): zaktualizuj dokumentację
   ```

---

## 4️⃣ Struktura Projektu (Uproszczona)

```
questest/
├── lib/
│   ├── core/              # Podstawowe rzeczy (network, theme, models)
│   ├── features/          # Funkcjonalności (home, profile)
│   ├── shared_ui/         # Komponenty UI (przyciski, karty)
│   └── main.dart          # Start aplikacji
│
├── mock_api/              # Mock backend (json-server)
│   ├── db.json           # Dane
│   └── server.js         # Serwer
│
└── [dokumentacja]         # README, CONTRIBUTING, etc.
```

---

## 5️⃣ Najczęstsze Komendy

### Flutter

```bash
# Pobranie zależności
flutter pub get

# Generowanie kodu (JSON serialization, Retrofit)
dart run build_runner build --delete-conflicting-outputs

# Watch mode (automatyczne generowanie)
dart run build_runner watch --delete-conflicting-outputs

# Uruchomienie aplikacji
flutter run

# Analiza kodu
flutter analyze

# Testy
flutter test

# Lista urządzeń
flutter devices
```

### Git (Podstawy)

```bash
# Utworzenie feature branch
git checkout develop
git pull origin develop
git checkout -b feature/QUEST-123-opis

# Commit
git add .
git commit -m "feat(feature): opis zmian"

# Push
git push origin feature/QUEST-123-opis

# Sync z develop
git fetch origin
git rebase origin/develop
```

### Mock API

```bash
cd mock_api

# Instalacja (raz)
npm install

# Uruchomienie
npm start

# Sprawdzenie
curl http://localhost:3000/quizzes
```

---

## 6️⃣ Typowy Workflow

### Praca nad nową funkcjonalnością

```bash
# 1. Stwórz branch
git checkout develop
git pull origin develop
git checkout -b feature/QUEST-123-moja-funkcja

# 2. Pracuj na kodzie...
# ... edytuj pliki ...

# 3. Testuj
flutter analyze
flutter test

# 4. Commit
git add .
git commit -m "feat(quiz): dodaj funkcjonalność X"

# 5. Push
git push origin feature/QUEST-123-moja-funkcja

# 6. Stwórz Pull Request na GitHub
# 7. Poczekaj na approval
# 8. Merge przez GitHub (Squash and Merge)

# 9. Posprzątaj lokalnie
git checkout develop
git pull origin develop
git branch -d feature/QUEST-123-moja-funkcja
```

---

## 7️⃣ Pomoc i Wsparcie

### Mam Problem!

1. **Sprawdź dokumentację** - większość odpowiedzi jest w README.md
2. **Sprawdź GitHub Issues** - może ktoś już zgłosił podobny problem
3. **Zapytaj na Slack/Discord** - zespół pomoże
4. **Skontaktuj się z Lead Architect** - w ostateczności

### Przydatne Linki

- 📚 [README.md](README.md) - Główna dokumentacja
- 🤝 [CONTRIBUTING.md](CONTRIBUTING.md) - Git Strategy
- 📊 [PRZEGLAD_PROJEKTU.md](PRZEGLAD_PROJEKTU.md) - Przegląd
- 📝 [SPRINT1_PODSUMOWANIE.md](SPRINT1_PODSUMOWANIE.md) - Sprint 1

### Dokumentacja Externa

- [Flutter Docs](https://docs.flutter.dev/)
- [Riverpod](https://riverpod.dev/)
- [Dio](https://pub.dev/packages/dio)
- [Retrofit](https://pub.dev/packages/retrofit)

---

## 8️⃣ Checklist Pierwszego Dnia

Zaznacz gdy ukończysz:

- [ ] Przeczytałem README.md
- [ ] Przeczytałem CONTRIBUTING.md (szczególnie Git Strategy)
- [ ] Zainstalowałem Flutter SDK 3.9.2+
- [ ] Zainstalowałem Node.js
- [ ] Sklonowałem repozytorium
- [ ] Uruchomiłem `flutter pub get`
- [ ] Uruchomiłem `dart run build_runner build`
- [ ] Uruchomiłem Mock API pomyślnie
- [ ] Uruchomiłem aplikację pomyślnie
- [ ] Widzę listę quizów w aplikacji
- [ ] Mogę przełączać się między zakładkami Start/Profil
- [ ] Stworzyłem testowy feature branch
- [ ] Wykonałem testowy commit z Conventional Commits
- [ ] Zapoznałem się ze strukturą folderów
- [ ] Dołączyłem do kanału zespołu (Slack/Discord)

---

## 9️⃣ Szybkie FAQ

**Q: Nie mogę uruchomić aplikacji**
```bash
# Spróbuj:
flutter clean
flutter pub get
dart run build_runner build --delete-conflicting-outputs
flutter run
```

**Q: Mock API nie startuje**
```bash
# Sprawdź czy masz Node.js:
node --version  # Powinno pokazać v16+

# Reinstaluj zależności:
cd mock_api
rm -rf node_modules package-lock.json
npm install
npm start
```

**Q: Błędy w build_runner**
```bash
# Użyj --delete-conflicting-outputs:
dart run build_runner build --delete-conflicting-outputs
```

**Q: Gdzie mogę pushować kod?**
- ✅ Do swojego feature brancha
- ❌ NIE do main
- ❌ NIE do develop (tylko przez PR)

**Q: Jak długo czekać na code review?**
- Standardowo: 24-48h
- Pilne sprawy: oznacz jako urgent

---

## 🎯 Co Dalej?

Po przeczytaniu tej dokumentacji i uruchomieniu projektu:

1. ✅ Zapoznaj się z kodem w `lib/`
2. ✅ Zobacz komponenty w `lib/shared_ui/`
3. ✅ Sprawdź Mock API w `mock_api/`
4. ✅ Poczekaj na zadania ze Sprintu 2
5. ✅ Rozpocznij swoją pierwszą funkcjonalność!

---

## 🎉 Gotowe!

Jesteś gotowy do pracy! W razie pytań - pytaj zespół.

**Powodzenia w kodowaniu! 🚀**

---

*Ten plik możesz usunąć po zapoznaniu się z projektem*

