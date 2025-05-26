import '../repositories/project_repository.dart';

class UploadVideoUseCase {
  final ProjectRepository repository;
  UploadVideoUseCase(this.repository);

  Future<void> call(String projectId, String filePath) =>
      repository.uploadVideo(projectId, filePath);
}
