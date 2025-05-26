part of 'home_bloc.dart';

abstract class HomeEvent extends Equatable {
  const HomeEvent();
  @override
  List<Object?> get props => [];
}

class FetchProjectsEvent extends HomeEvent {}

class AddProjectEvent extends HomeEvent {
  final ProjectEntity project;
  const AddProjectEvent(this.project);
  @override
  List<Object?> get props => [project];
}

class UploadProjectImageEvent extends HomeEvent {
  final String projectId;
  final String filePath;
  const UploadProjectImageEvent(this.projectId, this.filePath);
  @override
  List<Object?> get props => [projectId, filePath];
}

class UploadProjectVideoEvent extends HomeEvent {
  final String projectId;
  final String filePath;
  const UploadProjectVideoEvent(this.projectId, this.filePath);
  @override
  List<Object?> get props => [projectId, filePath];
}

class DeleteProjectImageEvent extends HomeEvent {
  final String projectId;
  final String imageUrl;
  const DeleteProjectImageEvent(this.projectId, this.imageUrl);
  @override
  List<Object?> get props => [projectId, imageUrl];
}

class DeleteProjectVideoEvent extends HomeEvent {
  final String projectId;
  final String videoUrl;
  const DeleteProjectVideoEvent(this.projectId, this.videoUrl);
  @override
  List<Object?> get props => [projectId, videoUrl];
}
