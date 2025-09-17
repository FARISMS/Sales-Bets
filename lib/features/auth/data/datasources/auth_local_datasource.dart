import '../../../../core/di/modules/storage_module.dart';
import '../../../../core/errors/exceptions.dart';
import '../models/user_model.dart';

abstract class AuthLocalDataSource {
  Future<void> cacheUser(UserModel user);
  Future<UserModel?> getCachedUser();
  Future<void> clearUserCache();
  Future<void> cacheToken(String token);
  Future<String?> getCachedToken();
  Future<void> clearToken();
}

class AuthLocalDataSourceImpl implements AuthLocalDataSource {
  final StorageModule storage;

  AuthLocalDataSourceImpl({required this.storage});

  @override
  Future<void> cacheUser(UserModel user) async {
    try {
      final userJson = user.toJson();
      await storage.setString('cached_user', userJson.toString());
    } catch (e) {
      throw CacheException('Failed to cache user: $e');
    }
  }

  @override
  Future<UserModel?> getCachedUser() async {
    try {
      final userJsonString = storage.getString('cached_user');
      if (userJsonString != null) {
        // In a real app, you'd parse the JSON string back to a map
        // For now, returning null as we need proper JSON parsing
        return null;
      }
      return null;
    } catch (e) {
      throw CacheException('Failed to get cached user: $e');
    }
  }

  @override
  Future<void> clearUserCache() async {
    try {
      await storage.remove('cached_user');
    } catch (e) {
      throw CacheException('Failed to clear user cache: $e');
    }
  }

  @override
  Future<void> cacheToken(String token) async {
    try {
      await storage.setString('auth_token', token);
    } catch (e) {
      throw CacheException('Failed to cache token: $e');
    }
  }

  @override
  Future<String?> getCachedToken() async {
    try {
      return storage.getString('auth_token');
    } catch (e) {
      throw CacheException('Failed to get cached token: $e');
    }
  }

  @override
  Future<void> clearToken() async {
    try {
      await storage.remove('auth_token');
    } catch (e) {
      throw CacheException('Failed to clear token: $e');
    }
  }
}
