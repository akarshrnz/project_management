import '../repositories/project_repository.dart';

class UploadImageUseCase {
  final ProjectRepository repository;
  UploadImageUseCase(this.repository);

  Future<void> call(String projectId, String filePath) =>
      repository.uploadImage(projectId, filePath);
}
