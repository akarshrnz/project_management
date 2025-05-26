import '../entities/user_entity.dart';

abstract class AuthRepository {
  Future<UserEntity> login(String email, String password);
  Future<UserEntity> signup(String email, String password);
  Future<void> forgotPassword(String email);
  Future<bool> isUserLoggedIn();
  UserEntity? getCurrentUser();
  Future<void> logout();
}
