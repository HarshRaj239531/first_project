import '../core/services/api_client.dart';
import '../core/services/storage_service.dart';
import '../features/auth/models/user_model.dart';

class AuthApi {
  final ApiClient _apiClient;

  AuthApi(this._apiClient);

  /// Authenticate user and save token/user info
  Future<User?> login(String email, String password) async {
    try {
      final response = await _apiClient.post('/auth/login', {
        'email': email,
        'password': password,
      });

      if (response['success'] == true) {
        // In a real app, the token and user data would come from the API
        // For now, we simulate the logic since ApiClient is simulated
        final userData = response['data'];
        
        // Simulate a token if none exists in response
        final token = userData['token'] ?? 'simulated_jwt_token_${DateTime.now().millisecondsSinceEpoch}';
        
        // Save to storage
        await StorageService.setToken(token);
        await StorageService.setUserEmail(email);
        await StorageService.setUserName(userData['name'] ?? email.split('@')[0]);

        return User.fromJson({
          'id': userData['id'] ?? 'user_123',
          'name': userData['name'] ?? email.split('@')[0],
          'email': email,
          'token': token,
        });
      }
      return null;
    } catch (e) {
      return null;
    }
  }

  /// Register a new user
  Future<User?> register(String name, String email, String password) async {
    try {
      final response = await _apiClient.post('/auth/register', {
        'name': name,
        'email': email,
        'password': password,
      });

      if (response['success'] == true) {
        final userData = response['data'];
        final token = userData['token'] ?? 'simulated_jwt_token_${DateTime.now().millisecondsSinceEpoch}';

        // Save to storage
        await StorageService.setToken(token);
        await StorageService.setUserEmail(email);
        await StorageService.setUserName(name);

        return User.fromJson({
          'id': userData['id'] ?? 'user_123',
          'name': name,
          'email': email,
          'token': token,
        });
      }
      return null;
    } catch (e) {
      return null;
    }
  }

  /// Clear session and local data
  Future<void> logout() async {
    await StorageService.clearAll();
  }
}
