import 'dart:io';

import 'package:project_management/features/home/domain/entites/project_entity.dart';

import '../../domain/repositories/project_repository.dart';
import '../datasources/project_remote_data_source.dart';
import '../models/project_model.dart';

class ProjectRepositoryImpl implements ProjectRepository {
  final ProjectRemoteDataSource remoteDataSource;

  ProjectRepositoryImpl(this.remoteDataSource);

  @override
  Future<List<ProjectEntity>> getProjects() async {
    return await remoteDataSource.fetchProjects();
  }

  @override
  Future<void> addProject(ProjectEntity project) async {
    await remoteDataSource.addProject(ProjectModel(
      id: project.id,
      title: project.title,
      description: project.description,
      imageUrls: project.imageUrls,
      videoUrls: project.videoUrls,
      latitude: project.latitude,
      longitude: project.longitude,
    ));
  }

  @override
  Future<void> uploadImage(String projectId, String filePath) async {
    await remoteDataSource.uploadImage(projectId, File(filePath));
  }

  @override
  Future<void> uploadVideo(String projectId, String filePath) async {
    await remoteDataSource.uploadVideo(projectId, File(filePath));
  }

  @override
  Future<void> deleteImage(String projectId, String imageUrl) async {
    await remoteDataSource.deleteImage(projectId, imageUrl);
  }

  @override
  Future<void> deleteVideo(String projectId, String videoUrl) async {
    await remoteDataSource.deleteVideo(projectId, videoUrl);
  }
}
