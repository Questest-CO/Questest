# Questest 🎯

Nowoczesna aplikacja Flutter do quizów, ankiet i egzaminów z czystą architekturą i skalowalnym designem.

## 📝 O Projekcie

Questest to aplikacja mobilna umożliwiająca użytkownikom:
- Rozwiązywanie quizów z różnych kategorii
- Udział w ankietach i egzaminach
- Śledzenie wyników i statystyk
- Rywalizację z innymi użytkownikami

### Kluczowe Cechy
- 🏗️ Architektura Feature-First
- 🔄 Zarządzanie stanem z Riverpod
- 🎨 Nowoczesny Material Design 3
- 🌐 RESTful API z Retrofit
- ⚡ Wysoką wydajność i płynność

---

## 🏗️ Struktura Projektu

```
questest/
├── lib/
│   ├── core/                          # Funkcjonalność podstawowa (niezależna od frameworka)
│   │   ├── errors/
│   │   │   └── app_exception.dart     # Klasy własnych wyjątków
│   │   ├── models/
│   │   │   ├── auth_response.dart     # Model odpowiedzi autoryzacji
│   │   │   ├── quiz_model.dart        # Model encji quizu
│   │   │   └── user_model.dart        # Model encji użytkownika
│   │   ├── network/
│   │   │   ├── api_client.dart        # Klient API Retrofit
│   │   │   └── dio_client.dart        # Konfiguracja Dio
│   │   ├── providers/
│   │   │   └── dio_provider.dart      # Providery Riverpod dla DI
│   │   ├── theme/
│   │   │   └── app_theme.dart         # Konfiguracja motywu aplikacji
│   │   └── utils/
│   │       ├── app_constants.dart     # Stałe aplikacji
│   │       └── validators.dart        # Narzędzia walidacji inputów
│   │
│   ├── features/                      # Moduły funkcjonalności
│   │   ├── main_screen.dart           # Shell głównej nawigacji
│   │   ├── home/
│   │   │   ├── presentation/
│   │   │   │   └── pages/
│   │   │   │       └── home_page.dart # Strona listy quizów
│   │   │   └── providers/
│   │   │       └── quiz_provider.dart # Providery danych quizów
│   │   └── profile/
│   │       └── presentation/
│   │           └── pages/
│   │               └── profile_page.dart # Strona profilu użytkownika
│   │
│   ├── shared_ui/                     # Komponenty UI wielokrotnego użytku
│   │   └── widgets/
│   │       ├── q_primary_button.dart  # Komponent przycisku głównego
│   │       └── q_quiz_card.dart       # Komponent karty quizu
│   │
│   └── main.dart                      # Punkt wejścia aplikacji
│
├── mock_api/                          # Serwer mock backendu
│   ├── db.json                        # Mock baza danych
│   ├── server.js                      # Własny serwer json-server
│   ├── package.json                   # Zależności Node
│   └── README.md                      # Dokumentacja API
│
├── pubspec.yaml                       # Zależności Flutter
├── README.md                          # Ten plik (główna dokumentacja)
├── CONTRIBUTING.md                    # Przewodnik kontrybutora + Git Strategy
├── SPRINT1_PODSUMOWANIE.md           # Szczegółowe podsumowanie Sprintu 1
├── PRZEGLAD_PROJEKTU.md              # Szybki przegląd i statystyki
└── START_TUTAJ.md                     # Przewodnik dla nowych członków zespołu
```

---

## 🚀 Jak Uruchomić Projekt?

### Wymagania Wstępne

- **Flutter SDK**: wersja **3.9.2** lub nowsza
- **Dart SDK**: dołączony do Flutter
- **Node.js** (v16 lub nowszy) i **npm** - do uruchomienia Mock API
- **IDE**: VS Code lub Android Studio (zalecane)
- Emulator Android/iOS lub fizyczne urządzenie

### Sprawdzenie Wersji Flutter

Upewnij się, że masz odpowiednią wersję Flutter:

```bash
flutter --version
```

Powinieneś zobaczyć Flutter 3.9.2 lub nowszy.

### Instalacja i Uruchomienie

#### Krok 1: Pobierz Zależności Flutter

W katalogu głównym projektu (`questest/`):

```bash
flutter pub get
```

#### Krok 2: Wygeneruj Kod (JSON Serialization)

```bash
dart run build_runner build --delete-conflicting-outputs
```

Ta komenda generuje kod dla serializacji JSON (pliki `*.g.dart`).

#### Krok 3: Uruchom Mock API Server

Mock API znajduje się w katalogu `mock_api/`.

**Instalacja zależności (jednorazowo):**

```bash
cd mock_api
npm install
```

**Uruchomienie serwera:**

```bash
npm start
```

Serwer wystartuje pod adresem: **http://localhost:3000**

**Alternatywnie** (prosty tryb bez middleware):
```bash
npm run simple
```

**Sprawdzenie działania API:**
Otwórz w przeglądarce: http://localhost:3000/quizzes

#### Krok 4: Uruchom Aplikację Flutter

W nowym terminalu, z katalogu głównego projektu:

```bash
flutter run
```

**Uruchomienie na konkretnym urządzeniu:**

```bash
# Lista dostępnych urządzeń
flutter devices

# Uruchomienie na konkretnym urządzeniu
flutter run -d chrome              # Przeglądarka
flutter run -d <device-id>         # Konkretne urządzenie
flutter run -d emulator-5554       # Emulator Android
```

### Weryfikacja Instalacji

Po uruchomieniu aplikacji powinieneś zobaczyć:
- ✅ Ekran główny z listą quizów
- ✅ Dolny pasek nawigacji (Start / Profil)
- ✅ Quizy ładowane z Mock API
- ✅ Możliwość przełączania między zakładkami

---

## 🏛️ Architektura Projektu

### Architektura Feature-First

Projekt wykorzystuje podejście **feature-first**, gdzie kod jest organizowany według funkcjonalności zamiast warstw:

**Korzyści:**
- Lepsza skalowalność dla dużych zespołów
- Jasne granice między funkcjonalnościami
- Łatwiejsze zlokalizowanie i modyfikacja kodu
- Wspiera niezależny rozwój funkcjonalności

### Zarządzanie Stanem: Riverpod

Używamy **Riverpod** do zarządzania stanem aplikacji:

**Dlaczego Riverpod?**
- Bezpieczeństwo w czasie kompilacji
- Brak wymagania BuildContext
- Lepsza testowalność
- Doskonała kompozycja providerów
- Silne wsparcie społeczności

**Przykład Providera:**
```dart
final quizzesProvider = FutureProvider<List<QuizModel>>((ref) async {
  final apiClient = ref.watch(apiClientProvider);
  return await apiClient.getQuizzes();
});
```

### Warstwa Sieciowa

**Stack Technologiczny:**
- **Dio**: Klient HTTP z interceptorami
- **Retrofit**: Type-safe REST API client
- **json_serializable**: Serializacja JSON

**Struktura:**
```
core/network/
├── dio_client.dart      # Konfiguracja Dio z logowaniem
└── api_client.dart      # Definicje API Retrofit
```

---

## 🎨 Komponenty UI

### QPrimaryButton

Główny komponent przycisku z konsekwentnym stylem:

```dart
QPrimaryButton(
  text: 'Rozpocznij Quiz',
  icon: Icons.play_arrow,
  onPressed: () {
    // Obsługa kliknięcia
  },
  isLoading: false,
)
```

**Funkcjonalności:**
- Wsparcie dla stanu ładowania
- Opcjonalna ikona
- Konfigurowalne kolory
- Domyślnie pełna szerokość

### QQuizCard

Komponent karty do wyświetlania informacji o quizie:

```dart
QQuizCard(
  title: 'Sonic the Hedgehog Trivia',
  subtitle: 'Eggman',
  thumbnailUrl: 'https://example.com/image.jpg',
  questionCount: 15,
  participantsCount: 12450,
  difficulty: 'medium',
  onTap: () {
    // Nawigacja do quizu
  },
)
```

**Warianty:**
- `QQuizCard`: Pełna karta ze wszystkimi szczegółami
- `QQuizCardCompact`: Kompaktowa wersja do layoutów gridowych

---

## 🌐 Integracja z API

### Konfiguracja Bazowa

Bazowy URL API jest skonfigurowany w `core/network/dio_client.dart`:

```dart
static const String baseUrl = 'http://localhost:3000';
```

### Dostępne Endpointy

#### Quizy
- `GET /quizzes` - Pobierz wszystkie quizy
- `GET /quizzes/{id}` - Pobierz quiz po ID

#### Użytkownicy
- `GET /users/{id}` - Pobierz profil użytkownika

#### Autentykacja
- `POST /auth/login` - Logowanie użytkownika
- `POST /auth/register` - Rejestracja użytkownika

Szczegółowa dokumentacja API znajduje się w `mock_api/README.md`

### Lokalizacja Mock API

Mock API znajduje się w katalogu: **`mock_api/`**

**Zawartość:**
- `db.json` - Baza danych z przykładowymi danymi
- `server.js` - Serwer z customowymi endpointami
- `package.json` - Zależności Node.js
- `README.md` - Dokumentacja API

**Jak uruchomić:**
```bash
cd mock_api
npm install    # Jednorazowo
npm start      # Uruchomienie serwera
```

Serwer będzie dostępny pod: **http://localhost:3000**

---

## 🧪 Testowanie

### Uruchamianie Testów

```bash
flutter test
```

### Struktura Testów

```
test/
├── unit/           # Testy jednostkowe
├── widget/         # Testy widgetów
└── integration/    # Testy integracyjne
```

---

## 🔧 Proces Deweloperski

### Generowanie Kodu

Gdy modyfikujesz modele z `@JsonSerializable`:

```bash
dart run build_runner build --delete-conflicting-outputs
```

Dla ciągłego monitorowania zmian:
```bash
dart run build_runner watch --delete-conflicting-outputs
```

### Dodawanie Nowych Funkcjonalności

1. Stwórz katalog funkcjonalności w `lib/features/`
2. Organizuj według warstw:
   - `data/`: Źródła danych, repozytoria
   - `domain/`: Logika biznesowa, encje
   - `presentation/`: UI, strony, widgety
   - `providers/`: Providery Riverpod
3. Dodaj modele specyficzne dla funkcjonalności
4. Wykorzystuj narzędzia core i współdzielone komponenty UI

### Dodawanie Nowych Endpointów API

1. Dodaj endpoint do `core/network/api_client.dart`
2. Uruchom generowanie kodu
3. Stwórz provider w odpowiedniej funkcjonalności
4. Użyj w UI z `ref.watch(yourProvider)`

---

## 📦 Zależności

### Zależności Produkcyjne

| Pakiet | Wersja | Przeznaczenie |
|---------|---------|---------|
| flutter_riverpod | ^2.5.1 | Zarządzanie stanem |
| dio | ^5.4.1 | Klient HTTP |
| retrofit | ^4.1.0 | Type-safe klient API |
| go_router | ^14.0.2 | Nawigacja |
| json_annotation | ^4.8.1 | Serializacja JSON |
| logger | ^2.0.2+1 | Logowanie |

### Zależności Deweloperskie

| Pakiet | Wersja | Przeznaczenie |
|---------|---------|---------|
| build_runner | ^2.4.8 | Generowanie kodu |
| json_serializable | ^6.7.1 | Generator serializacji JSON |
| retrofit_generator | ^8.1.0 | Generowanie kodu Retrofit |
| riverpod_generator | ^2.4.0 | Generowanie kodu Riverpod |

---

## 🎯 Następne Kroki (Sprint 2)

- [ ] Implementacja przepływu autentykacji
- [ ] Strona szczegółów quizu z pytaniami
- [ ] Funkcjonalność rozwiązywania quizu z timerem
- [ ] Ekran wyników z podsumowaniem
- [ ] Statystyki i historia użytkownika
- [ ] Funkcjonalność ulubionych
- [ ] Wyszukiwanie i filtrowanie
- [ ] Testy jednostkowe i widgetów

---

## 📝 Standardy Jakości Kodu

### Zasady Clean Code

1. **Znaczące nazwy**: Używaj opisowych nazw zmiennych i funkcji
2. **Single Responsibility**: Każda klasa/funkcja robi jedną rzecz
3. **DRY**: Don't Repeat Yourself (nie powtarzaj się)
4. **Komentarze**: Kod powinien być samodokumentujący
5. **Obsługa błędów**: Właściwa obsługa wyjątków
6. **Testowanie**: Pisz testy dla logiki biznesowej

### Konwencje Nazewnictwa Plików

- Pliki: `snake_case.dart`
- Klasy: `PascalCase`
- Zmienne/Funkcje: `camelCase`
- Stałe: `camelCase` lub `SCREAMING_SNAKE_CASE`

### Organizacja Importów

```dart
// Importy Dart
import 'dart:async';

// Importy Flutter
import 'package:flutter/material.dart';

// Importy pakietów
import 'package:flutter_riverpod/flutter_riverpod.dart';

// Importy projektowe
import '../models/quiz_model.dart';
```

---

## 🤝 Wkład w Projekt

Zobacz [CONTRIBUTING.md](CONTRIBUTING.md) dla szczegółowych informacji o:
- Strategii Git
- Procesie Code Review
- Standardach kodowania
- Procesie Pull Request

---

## 📄 Licencja

Ten projekt jest własnością Questest. Wszelkie prawa zastrzeżone.

---

## 👥 Zespół

- **Osoba 1**: Architektura & Integracja Backend
- **Osoba 2**: UI/UX & Komponenty
- **Osoba 3**: API & Warstwa Danych
- **Lead Architect**: Kierownictwo Techniczne

---

## 📞 Wsparcie

W przypadku pytań lub problemów, skontaktuj się z zespołem deweloperskim.

---

**Zbudowane z ❤️ przez Zespół Questest**
