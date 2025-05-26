import '../repositories/project_repository.dart';

class DeleteVideoUseCase {
  final ProjectRepository repository;
  DeleteVideoUseCase(this.repository);

  Future<void> call(String projectId, String videoUrl) =>
      repository.deleteVideo(projectId, videoUrl);
}
