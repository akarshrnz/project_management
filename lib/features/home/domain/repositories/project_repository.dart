
import 'package:project_management/features/home/domain/entites/project_entity.dart';

abstract class ProjectRepository {
  Future<List<ProjectEntity>> getProjects();
  Future<void> addProject(ProjectEntity project);
  Future<void> deleteImage(String projectId, String imageUrl);
  Future<void> deleteVideo(String projectId, String videoUrl);
  Future<void> uploadImage(String projectId, String filePath);
  Future<void> uploadVideo(String projectId, String filePath);
}
