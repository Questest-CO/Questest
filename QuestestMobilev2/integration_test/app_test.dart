/// Entry point for running all E2E integration tests.
///
/// Run with:
/// ```bash
/// flutter test integration_test/app_test.dart
/// ```
///
/// Or for specific test files:
/// ```bash
/// flutter test integration_test/registration_flow_test.dart
/// flutter test integration_test/quiz_solving_flow_test.dart
/// flutter test integration_test/result_checking_flow_test.dart
/// flutter test integration_test/complete_user_journey_test.dart
/// ```
library;

// Export all test files for easy import
export 'registration_flow_test.dart';
export 'quiz_solving_flow_test.dart';
export 'result_checking_flow_test.dart';
export 'complete_user_journey_test.dart';

