import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../features/auth/repositories/auth_repository.dart';
import '../../features/devices/repositories/device_repository.dart';

// ─────────────────────────────────────────────────────────────────────────────
// TODO: BACKEND INTEGRATION POINT
// When your backend is ready:
// 1. Create an ApiClient class (using dio or http package)
// 2. Uncomment the apiClientProvider below
// 3. Switch the repository providers to return Real implementations
//
// final apiClientProvider = Provider<ApiClient>((ref) {
//   final client = ApiClient();
//   ref.onDispose(() => client.dispose());
//   return client;
// });
// ─────────────────────────────────────────────────────────────────────────────

/// Provider for AuthRepository — currently returns Mock
final authRepositoryProvider = Provider<IAuthRepository>((ref) {
  // TODO: Replace with RealAuthRepository(ref.watch(apiClientProvider))
  //       when backend is ready
  return MockAuthRepository();
});

/// Provider for DeviceRepository — currently returns Mock
final deviceRepositoryProvider = Provider<IDeviceRepository>((ref) {
  // TODO: Replace with RealDeviceRepository(ref.watch(apiClientProvider))
  //       when backend is ready
  return MockDeviceRepository();
});
