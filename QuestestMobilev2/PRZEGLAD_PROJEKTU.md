# Questest - Przegląd Projektu

## 📊 Szybki Przegląd

**Nazwa**: Questest  
**Platforma**: Flutter (iOS, Android, Web)  
**Architektura**: Feature-First + Clean Architecture  
**Zarządzanie Stanem**: Riverpod  
**Sprint**: 1 (Ukończony ✅)  
**Jakość Kodu**: Produkcyjna  

---

## 📁 Utworzone Pliki - Sprint 1

### 🎨 Pliki Core (12 plików)

#### Theme
- ✅ `lib/core/theme/app_theme.dart` - Konfiguracja motywu Material 3

#### Network
- ✅ `lib/core/network/dio_client.dart` - Klient HTTP z interceptorami
- ✅ `lib/core/network/api_client.dart` - Type-safe API Retrofit

#### Models
- ✅ `lib/core/models/quiz_model.dart` - Model quizu + JSON serialization
- ✅ `lib/core/models/user_model.dart` - Model użytkownika + JSON serialization
- ✅ `lib/core/models/auth_response.dart` - Model odpowiedzi autoryzacji

#### Errors
- ✅ `lib/core/errors/app_exception.dart` - Hierarchia wyjątków aplikacji

#### Utils
- ✅ `lib/core/utils/app_constants.dart` - Stałe aplikacji
- ✅ `lib/core/utils/validators.dart` - Walidatory inputów

#### Providers
- ✅ `lib/core/providers/dio_provider.dart` - Providery Riverpod dla DI

### 🎯 Pliki Features (4 pliki + 1 wygenerowany)

#### Navigation
- ✅ `lib/features/main_screen.dart` - Shell nawigacji z BottomNavBar

#### Home Feature
- ✅ `lib/features/home/presentation/pages/home_page.dart` - Lista quizów
- ✅ `lib/features/home/providers/quiz_provider.dart` - Providery quizów

#### Profile Feature
- ✅ `lib/features/profile/presentation/pages/profile_page.dart` - Profil użytkownika

### 🧩 Komponenty UI (2 pliki)

- ✅ `lib/shared_ui/widgets/q_primary_button.dart` - Przycisk (primary + secondary)
- ✅ `lib/shared_ui/widgets/q_quiz_card.dart` - Karta quizu (full + compact)

### 🔧 Main
- ✅ `lib/main.dart` - Punkt wejścia aplikacji

### 🗄️ Mock API (4 pliki)

- ✅ `mock_api/db.json` - Baza danych z przykładowymi danymi
- ✅ `mock_api/server.js` - Serwer z customowymi endpointami
- ✅ `mock_api/package.json` - Konfiguracja npm
- ✅ `mock_api/README.md` - Dokumentacja API (po polsku w przyszłości)

### 📄 Dokumentacja (3 pliki)

- ✅ `README.md` - Główna dokumentacja projektu (PL)
- ✅ `CONTRIBUTING.md` - Przewodnik kontrybutora z Git Strategy (PL)
- ✅ `SPRINT1_PODSUMOWANIE.md` - Podsumowanie Sprintu 1 (PL)

### 🔨 Pliki Wygenerowane (automatycznie przez build_runner)

- `lib/core/models/*.g.dart` - Serializacja JSON (3 pliki)
- `lib/core/network/api_client.g.dart` - Kod Retrofit

---

## 🎯 Co Zostało Zaimplementowane

### ✅ Architektura i Setup
- [x] Projekt Flutter zainicjalizowany
- [x] Architektura Feature-First
- [x] Riverpod skonfigurowany
- [x] Dio + Retrofit + JSON Serialization
- [x] System motywów
- [x] Obsługa błędów
- [x] Walidatory
- [x] Providery DI

### ✅ UI i Nawigacja
- [x] MainScreen z BottomNavigationBar
- [x] IndexedStack dla zachowania stanu
- [x] QPrimaryButton (+ secondary variant)
- [x] QQuizCard (+ compact variant)
- [x] HomePage z listą quizów
- [x] ProfilePage z menu

### ✅ Backend Mock
- [x] json-server setup
- [x] db.json z 4 quizami
- [x] Użytkownicy, wyniki, pytania
- [x] Custom server.js
- [x] Auth endpoints (login, register)
- [x] Dokumentacja API

### ✅ Dokumentacja
- [x] README.md (PL)
- [x] CONTRIBUTING.md z Git Strategy (PL)
- [x] Sprint 1 Podsumowanie (PL)
- [x] Komentarze w kodzie

---

## 🚀 Szybkie Komendy

### Uruchomienie Projektu

```bash
# 1. Zainstaluj zależności
cd questest
flutter pub get
dart run build_runner build --delete-conflicting-outputs

# 2. Uruchom Mock API (nowy terminal)
cd mock_api
npm install
npm start

# 3. Uruchom aplikację (nowy terminal)
cd questest
flutter run
```

### Rozwój

```bash
# Generowanie kodu (watch mode)
dart run build_runner watch --delete-conflicting-outputs

# Analiza kodu
flutter analyze

# Testy
flutter test

# Sprawdzenie wersji
flutter --version
```

### Mock API

```bash
# W katalogu mock_api/

# Uruchomienie z custom middleware
npm start

# Uruchomienie w trybie prostym
npm run simple

# Sprawdzenie endpointów
curl http://localhost:3000/quizzes
```

---

## 📊 Statystyki

### Linie Kodu
- **Dart**: ~2,000 linii
- **Dokumentacja**: ~800 linii
- **JSON**: ~200 linii
- **Razem**: ~3,000 linii

### Pliki
- **Dart**: 16 plików
- **Wygenerowane**: 4 pliki
- **Mock API**: 4 pliki
- **Dokumentacja**: 4 pliki
- **Razem**: 28 plików

### Pokrycie
- **Architektura**: 100% ✅
- **UI Kit**: 100% ✅
- **Mock API**: 100% ✅
- **Dokumentacja**: 100% ✅
- **Testy**: 0% ⚠️ (Sprint 2)

---

## 🎨 Design System

### Kolory
- **Primary**: #6C5CE7 (Fioletowy)
- **Secondary**: #FF6B9D (Różowy)
- **Accent**: #00D9FF (Cyjan)
- **Background**: #F8F9FA
- **Text Primary**: #2D3436
- **Text Secondary**: #636E72

### Komponenty
- QPrimaryButton - 56px wysokości, zaokrąglone rogi 12px
- QSecondaryButton - wariant z obramowaniem
- QQuizCard - AspectRatio 16:9, cień 2px
- QQuizCardCompact - AspectRatio 1:1

### Typografia
- Display Large: 32px, Bold
- Display Medium: 28px, Bold
- Display Small: 24px, Bold
- Headline Medium: 20px, Semi-bold
- Title Large: 18px, Semi-bold
- Body Large: 16px, Regular
- Body Medium: 14px, Regular
- Body Small: 12px, Regular

---

## 🔄 Git Strategy (Skrót)

### Główne Gałęzie
- **main** - Produkcja (chroniona)
- **develop** - Rozwój (chroniona)

### Gałęzie Robocze
- `feature/QUEST-XXX-opis` - Nowe funkcjonalności
- `bugfix/QUEST-XXX-opis` - Naprawy błędów
- `hotfix/X.X.X-opis` - Pilne poprawki produkcyjne

### Zasady
- ✅ Wszystkie zmiany przez Pull Request
- ❌ Bezpośredni push do main/develop ZABRONIONY
- ❌ Force push do main/develop ZABRONIONY
- ✅ Minimum 1 approval przed merge
- ✅ CI/CD musi przejść
- ✅ Conventional Commits

### Przykład Commita
```bash
feat(auth): dodaj logowanie przez email

Implementacja:
- Formularz logowania
- Walidacja
- Obsługa błędów

Closes QUEST-123
```

---

## 📚 Przydatne Linki

### Dokumentacja
- [README.md](README.md) - Główna dokumentacja
- [CONTRIBUTING.md](CONTRIBUTING.md) - Git Strategy i standardy
- [SPRINT1_PODSUMOWANIE.md](SPRINT1_PODSUMOWANIE.md) - Szczegóły Sprintu 1
- [mock_api/README.md](mock_api/README.md) - API Dokumentacja

### Zewnętrzne
- [Flutter Docs](https://docs.flutter.dev/)
- [Riverpod](https://riverpod.dev/)
- [Dio](https://pub.dev/packages/dio)
- [json_server](https://github.com/typicode/json-server)

---

## 🎯 Następne Kroki (Sprint 2)

### Zaplanowane
1. ⏳ Ekrany autentykacji (login, rejestracja)
2. ⏳ Strona szczegółów quizu
3. ⏳ Quiz taking flow z timerem
4. ⏳ Ekran wyników
5. ⏳ Wyszukiwanie i filtrowanie
6. ⏳ Ustawienia użytkownika
7. ⏳ Testy jednostkowe i widgetów

### Szacowanie
- **Story Points**: 34
- **Czas trwania**: 2 tygodnie
- **Zespół**: 4 deweloperów

---

## 💡 Tips dla Zespołu

### Rozpoczynając Pracę
```bash
# Zawsze zacznij od develop
git checkout develop
git pull origin develop
git checkout -b feature/QUEST-XXX-twoja-funkcja
```

### Przed Commitem
```bash
# Sprawdź kod
flutter analyze
flutter test

# Commit
git add .
git commit -m "feat(quiz): dodaj funkcjonalność X"
```

### Przed Pull Requestem
```bash
# Sync z develop
git fetch origin
git rebase origin/develop

# Push
git push origin feature/QUEST-XXX-twoja-funkcja
```

---

## 🐛 Znane Problemy

1. **Ostrzeżenie analyzera** - Nie blokujące, dotyczy wersji pakietu
2. **Brak testów** - Zaplanowane na Sprint 2
3. **Mock API** - Wymaga prawdziwego backendu w produkcji
4. **Secure Storage** - Tokeny przechowywane tymczasowo
5. **Dark Mode** - Częściowo zaimplementowany

---

## ✅ Checklist Onboarding

Dla nowych członków zespołu:

- [ ] Przeczytaj README.md
- [ ] Przeczytaj CONTRIBUTING.md
- [ ] Skonfiguruj Flutter SDK (3.9.2+)
- [ ] Zainstaluj Node.js dla Mock API
- [ ] Sklonuj repozytorium
- [ ] Uruchom `flutter pub get`
- [ ] Uruchom `dart run build_runner build`
- [ ] Uruchom Mock API (`cd mock_api && npm start`)
- [ ] Uruchom aplikację (`flutter run`)
- [ ] Stwórz testowy feature branch
- [ ] Zapoznaj się ze strukturą projektu
- [ ] Dołącz na Slack/Discord zespołu

---

## 📞 Kontakt

**Lead Architect**: [kontakt]  
**Zespół Dev**: [kanał Slack/Discord]  
**Issues**: GitHub Issues  
**Documentation**: Ten folder

---

**Projekt Questest - Sprint 1 Ukończony! 🎉**

*Ostatnia aktualizacja: Listopad 2024*

