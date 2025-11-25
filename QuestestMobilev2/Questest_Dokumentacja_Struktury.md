# Questest Mobile v2 - Dokumentacja Struktury Projektu

![Architektura projektu](C:/Users/askik/.gemini/antigravity/brain/5b6369dc-2c00-4df3-80ac-0a2952d41e7d/project_structure_diagram_1764103455453.png)

## 1. 📁 Struktura Plików (Drzewo Projektu)

Projekt używa **Feature-First Architecture** z podziałem na:

```
lib/
├── core/                          # Wspólne elementy dla całej aplikacji
│   ├── errors/                    # Obsługa błędów
│   ├── models/                    # Modele danych (User, Quiz, Auth)
│   │   ├── user_model.dart        # ⭐ Model użytkownika
│   │   ├── user_model.g.dart      # Wygenerowany kod JSON
│   │   ├── quiz_model.dart
│   │   ├── quiz_model.g.dart
│   │   ├── auth_response.dart
│   │   └── auth_response.g.dart
│   ├── network/                   # Konfiguracja sieciowa (Dio, Retrofit)
│   ├── providers/                 # Globalne providery
│   │   └── dio_provider.dart
│   ├── theme/                     # ⭐ Konfiguracja motywu
│   │   └── app_theme.dart
│   └── utils/                     # Narzędzia pomocnicze
│       └── validators.dart
│
├── features/                      # Funkcjonalności aplikacji
│   ├── auth/                      # ⭐ Autoryzacja (Sprint 2)
│   │   └── presentation/
│   │       ├── controllers/
│   │       │   └── login_controller.dart  # ⭐ Logika logowania
│   │       ├── pages/
│   │       │   ├── login_page.dart
│   │       │   └── auth_gate.dart
│   │       └── providers/
│   │           └── auth_providers.dart    # ⭐ Firebase Auth Provider
│   │
│   ├── home/                      # Ekran główny
│   │   ├── presentation/
│   │   └── providers/
│   │       └── quiz_provider.dart
│   │
│   ├── profile/                   # Profil użytkownika
│   │   └── presentation/
│   │
│   └── main_screen.dart           # Główny ekran z nawigacją
│
├── shared_ui/                     # ⭐ Wspólne komponenty UI
│   └── widgets/
│       ├── q_primary_button.dart  # ⭐ Przyciski (Primary & Secondary)
│       └── q_quiz_card.dart       # Karta quizu
│
└── main.dart                      # Punkt wejścia aplikacji
```

### Architektura
- **Feature-First**: Każda funkcjonalność (auth, home, profile) ma własny folder
- **Presentation Layer**: Kontrolery, strony, widgety dla każdej funkcjonalności
- **Core**: Wspólne modele, providery, motywy
- **Shared UI**: Reużywalne komponenty UI

---

## 2. 👤 Model Użytkownika i Auth Provider

### Model Użytkownika (`user_model.dart`)

```dart
@JsonSerializable()
class UserModel {
  final String id;
  final String email;
  final String name;              // ⭐ Imię do wyświetlenia "Cześć, Jan!"
  final String? avatarUrl;
  final int? totalQuizzesTaken;
  final int? totalPoints;
  final String? bio;
  final DateTime createdAt;

  // Konstruktor, fromJson, toJson, copyWith...
}
```

**Kluczowe pola:**
- `name` - Imię użytkownika (np. "Jan Kowalski")
- `email` - Email użytkownika
- `totalQuizzesTaken` - Liczba rozwiązanych quizów
- `totalPoints` - Suma punktów

### Auth Provider (`auth_providers.dart`)

```dart
// Provider dla Firebase Auth
final firebaseAuthProvider = Provider<FirebaseAuth>((ref) {
  return FirebaseAuth.instance;
});

// Stream provider dla stanu autoryzacji
final authStateChangesProvider = StreamProvider<User?>((ref) {
  final firebaseAuth = ref.watch(firebaseAuthProvider);
  return firebaseAuth.authStateChanges();
});
```

### Login Controller (`login_controller.dart`)

```dart
// Provider kontrolera logowania
final loginControllerProvider =
    StateNotifierProvider<LoginController, LoginState>((ref) {
  final firebaseAuth = ref.watch(firebaseAuthProvider);
  return LoginController(firebaseAuth);
});

// Metody:
// - signIn(email, password)
// - sendPasswordReset(email)
// - togglePasswordVisibility()
```

### 🎯 Jak pobrać dane użytkownika?

**WAŻNE**: Obecnie używasz **Firebase Authentication**, która zwraca obiekt `User` (z Firebase), a nie `UserModel`.

Aby pobrać imię użytkownika:

```dart
// 1. Pobierz Firebase User
final authState = ref.watch(authStateChangesProvider);

authState.when(
  data: (user) {
    if (user != null) {
      final userName = user.displayName ?? 'Użytkowniku'; // Firebase User
      // Wyświetl: "Cześć, $userName!"
    }
  },
  loading: () => CircularProgressIndicator(),
  error: (err, stack) => Text('Błąd'),
);
```

**Uwaga**: `UserModel` jest używany do danych z backendu (quizy, punkty), ale do autoryzacji używasz Firebase `User`.

---

## 3. 🎨 Istniejące Widgety UI (UI Kit)

### Przyciski

#### QPrimaryButton (`q_primary_button.dart`)
```dart
QPrimaryButton(
  text: 'Zaloguj się',
  onPressed: () {},
  icon: Icons.login,              // Opcjonalna ikona
  isLoading: false,               // Stan ładowania
  backgroundColor: Colors.purple, // Opcjonalny kolor
  textColor: Colors.white,        // Opcjonalny kolor tekstu
  width: double.infinity,         // Domyślnie pełna szerokość
  height: 56,                     // Domyślna wysokość
)
```

#### QSecondaryButton (`q_primary_button.dart`)
```dart
QSecondaryButton(
  text: 'Anuluj',
  onPressed: () {},
  icon: Icons.cancel,
  isLoading: false,
)
```

### Karty Quizów

#### QQuizCard (`q_quiz_card.dart`)
- Wyświetla kartę quizu z obrazkiem, tytułem, opisem
- Obsługuje stan (dostępny, zablokowany, ukończony)

### Pola Tekstowe

**Nie ma dedykowanego widgetu** - używany jest standardowy `TextFormField` z motywem z `app_theme.dart`:

```dart
TextFormField(
  decoration: const InputDecoration(
    labelText: 'Adres email',
    hintText: 'np. jan.kowalski@example.com',
    prefixIcon: Icon(Icons.alternate_email_rounded),
  ),
  validator: Validators.validateEmail,
)
```

Styl jest automatycznie aplikowany przez `inputDecorationTheme` w `AppTheme`.

---

## 4. 🎨 Motyw Aplikacji (`app_theme.dart`)

### Kolory Brandowe

```dart
// Brand Colors
primaryColor:   #6C5CE7  // Fioletowy
secondaryColor: #FF6B9D  // Różowy
accentColor:    #00D9FF  // Cyjan

// Neutral Colors
backgroundColor:      #F8F9FA  // Jasne tło
surfaceColor:         #FFFFFF  // Białe powierzchnie
textPrimaryColor:     #2D3436  // Ciemny tekst
textSecondaryColor:   #636E72  // Szary tekst
dividerColor:         #DFE6E9  // Linie podziału

// Semantic Colors
successColor: #00B894  // Zielony
warningColor: #FDCB6E  // Żółty
errorColor:   #D63031  // Czerwony
infoColor:    #74B9FF  // Niebieski

// Gradienty
primaryGradient: LinearGradient(
  colors: [primaryColor, secondaryColor],
  begin: Alignment.topLeft,
  end: Alignment.bottomRight,
)
```

### Typografia

```dart
fontFamily: 'Inter'  // Domyślna czcionka

// Rozmiary:
displayLarge:   32px, bold
displayMedium:  28px, bold
displaySmall:   24px, bold
headlineMedium: 20px, w600
titleLarge:     18px, w600
titleMedium:    16px, w600
bodyLarge:      16px, normal
bodyMedium:     14px, normal
bodySmall:      12px, normal
labelLarge:     16px, w600 (dla przycisków)
```

### Style Komponentów

- **Przyciski**: Zaokrąglone rogi (12px), bez cienia
- **Karty**: Zaokrąglone rogi (16px), lekki cień
- **Inputy**: Zaokrąglone rogi (12px), wypełnione białym tłem
- **AppBar**: Bez cienia, wyśrodkowany tytuł

---

## 5. 📦 Zależności (`pubspec.yaml`)

### State Management
```yaml
flutter_riverpod: ^2.5.1      # ⭐ Riverpod (nie provider!)
riverpod_annotation: ^2.3.5
riverpod_generator: ^2.4.0    # Code generation
```

### Nawigacja
```yaml
go_router: ^14.0.2            # ⭐ GoRouter (nie auto_route!)
```

### Sieć
```yaml
dio: ^5.4.1                   # ⭐ Dio (nie http!)
retrofit: ^4.1.0
retrofit_generator: ^8.1.0
json_annotation: ^4.8.1
json_serializable: ^6.7.1
```

### Code Generation
```yaml
freezed: ^2.4.7               # ⭐ Freezed (dla modeli)
freezed_annotation: ^2.4.1
build_runner: ^2.4.8
```

### Firebase
```yaml
firebase_core: ^3.6.0
firebase_auth: ^5.3.1         # ⭐ Firebase Authentication
```

### Narzędzia
```yaml
logger: ^2.0.2+1              # Logowanie
cupertino_icons: ^1.0.8       # Ikony iOS
```

---

## 📝 Podsumowanie dla AI Promptów

### ✅ Używaj:
- **State Management**: `flutter_riverpod` (nie `provider`)
- **Nawigacja**: `go_router`
- **HTTP**: `dio` (nie `http`)
- **Modele**: `freezed` + `json_serializable`
- **Auth**: `FirebaseAuth` (zwraca `User`, nie `UserModel`)

### ✅ Istniejące komponenty:
- `QPrimaryButton` / `QSecondaryButton` - przyciski
- `QQuizCard` - karty quizów
- `AppTheme` - kolory i style
- `TextFormField` - pola tekstowe (bez dedykowanego widgetu)

### ✅ Providery:
- `authStateChangesProvider` - stream stanu autoryzacji
- `firebaseAuthProvider` - instancja Firebase Auth
- `loginControllerProvider` - kontroler logowania

### ✅ Modele:
- `UserModel` - dane użytkownika z backendu
- `QuizModel` - dane quizu
- `AuthResponse` - odpowiedź autoryzacji

### 🎯 Przykład: Wyświetl "Cześć, Jan!"

```dart
class HomeScreen extends ConsumerWidget {
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final authState = ref.watch(authStateChangesProvider);
    
    return authState.when(
      data: (user) {
        if (user == null) return LoginPage();
        
        final userName = user.displayName ?? 'Użytkowniku';
        
        return Scaffold(
          body: Column(
            children: [
              Text(
                'Cześć, $userName! 👋',
                style: Theme.of(context).textTheme.displaySmall,
              ),
              // Reszta UI...
            ],
          ),
        );
      },
      loading: () => CircularProgressIndicator(),
      error: (err, stack) => Text('Błąd: $err'),
    );
  }
}
```

---

## 🚀 Następne Kroki

Teraz możesz używać tej dokumentacji do tworzenia promptów dla AI:

**Przykład promptu:**
> "Stwórz ekran startowy używając istniejącego `QPrimaryButton`, `AppTheme.primaryColor`, i pobierz imię użytkownika z `authStateChangesProvider`. Użyj `go_router` do nawigacji."

Wszystkie informacje są gotowe! 🎉
