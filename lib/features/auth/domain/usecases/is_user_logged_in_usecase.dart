import '../repositories/auth_repository.dart';

class IsUserLoggedInUseCase {
  final AuthRepository repository;

  IsUserLoggedInUseCase(this.repository);

  Future<bool> call() {
    return repository.isUserLoggedIn();
  }
}
