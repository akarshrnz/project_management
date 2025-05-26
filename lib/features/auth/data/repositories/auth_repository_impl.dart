import 'package:firebase_auth/firebase_auth.dart' as fb;
import '../../domain/entities/user_entity.dart';
import '../../domain/repositories/auth_repository.dart';
import '../models/firebase_user_mapper.dart';

class AuthRepositoryImpl implements AuthRepository {
  final fb.FirebaseAuth firebaseAuth;

  AuthRepositoryImpl({fb.FirebaseAuth? firebaseAuth})
      : firebaseAuth = firebaseAuth ?? fb.FirebaseAuth.instance;

  @override
  Future<UserEntity> login(String email, String password) async {
    final userCredential = await firebaseAuth.signInWithEmailAndPassword(
      email: email,
      password: password,
    );
    final user = mapFirebaseUserToEntity(userCredential.user);
    if (user == null) {
      throw Exception('Login failed: User not found');
    }
    return user;
  }

  @override
  Future<UserEntity> signup(String email, String password) async {
    final userCredential = await firebaseAuth.createUserWithEmailAndPassword(
      email: email,
      password: password,
    );
    final user = mapFirebaseUserToEntity(userCredential.user);
    if (user == null) {
      throw Exception('Signup failed: User not found');
    }
    return user;
  }

  @override
  Future<void> forgotPassword(String email) async {
    await firebaseAuth.sendPasswordResetEmail(email: email);
  }

  @override
  Future<bool> isUserLoggedIn() async {
    return firebaseAuth.currentUser != null;
  }

  @override
  UserEntity? getCurrentUser() {
    return mapFirebaseUserToEntity(firebaseAuth.currentUser);
  }

  @override
  Future<void> logout() async {
    await firebaseAuth.signOut();
  }
}
