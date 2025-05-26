import '../repositories/project_repository.dart';

class DeleteImageUseCase {
  final ProjectRepository repository;
  DeleteImageUseCase(this.repository);

  Future<void> call(String projectId, String imageUrl) =>
      repository.deleteImage(projectId, imageUrl);
}
