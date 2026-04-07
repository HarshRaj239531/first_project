import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../config/app_config.dart';
import '../services/api_client.dart';
import '../../features/auth/repositories/auth_repository.dart';
import '../../features/devices/repositories/device_repository.dart';

/// Provider for ApiClient
final apiClientProvider = Provider<ApiClient>((ref) {
  final client = ApiClient();
  ref.onDispose(() => client.dispose());
  return client;
});

/// Provider for AuthRepository
final authRepositoryProvider = Provider<IAuthRepository>((ref) {
  if (AppConfig.useMockBackend) {
    return MockAuthRepository();
  } else {
    return RealAuthRepository(ref.watch(apiClientProvider));
  }
});

/// Provider for DeviceRepository
final deviceRepositoryProvider = Provider<IDeviceRepository>((ref) {
  if (AppConfig.useMockBackend) {
    return MockDeviceRepository();
  } else {
    return RealDeviceRepository(ref.watch(apiClientProvider));
  }
});
