import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../network/oracle/oracle_dio_client.dart';
import '../network/oracle/oracle_api_client.dart';
import '../repositories/oracle_repository.dart';

/// Provider for Oracle Dio Client
/// Creates a singleton instance of OracleDioClient
final oracleDioClientProvider = Provider<OracleDioClient>((ref) {
  return OracleDioClient();
});

/// Provider for Oracle API Client
/// Uses the Oracle Dio instance for API calls
final oracleApiClientProvider = Provider<OracleApiClient>((ref) {
  final dioClient = ref.watch(oracleDioClientProvider);
  return OracleApiClient(dioClient.dio);
});

/// Provider for Oracle Repository
/// Main entry point for Oracle DB data operations
final oracleRepositoryProvider = Provider<OracleRepository>((ref) {
  final apiClient = ref.watch(oracleApiClientProvider);
  return OracleRepository(apiClient);
});

