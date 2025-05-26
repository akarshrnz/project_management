import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:project_management/features/home/domain/usecases/add_project_usecase.dart';
import 'package:project_management/features/home/domain/usecases/delete_image_usecase.dart';
import 'package:project_management/features/home/domain/usecases/delete_video_usecase.dart';
import 'package:project_management/features/home/domain/usecases/get_projects_usecase.dart';
import 'package:project_management/features/home/domain/usecases/upload_image_usecase.dart';
import 'package:project_management/features/home/domain/usecases/upload_video_usecase.dart';
import '../../domain/entites/project_entity.dart';

part 'home_event.dart';
part 'home_state.dart';

class HomeBloc extends Bloc<HomeEvent, HomeState> {
  final GetProjectsUseCase getProjects;
  final AddProjectUseCase addProject;
  final UploadImageUseCase uploadImage;
  final UploadVideoUseCase uploadVideo;
  final DeleteImageUseCase deleteImage;
  final DeleteVideoUseCase deleteVideo;

  HomeBloc({
    required this.getProjects,
    required this.addProject,
    required this.uploadImage,
    required this.uploadVideo,
    required this.deleteImage,
    required this.deleteVideo,
  }) : super(HomeInitial()) {
    on<FetchProjectsEvent>(_onFetchProjects);
    on<AddProjectEvent>(_onAddProject);
    on<UploadProjectImageEvent>(_onUploadImage);
    on<UploadProjectVideoEvent>(_onUploadVideo);
    on<DeleteProjectImageEvent>(_onDeleteImage);
    on<DeleteProjectVideoEvent>(_onDeleteVideo);
  }

  Future<void> _onFetchProjects(FetchProjectsEvent event, Emitter<HomeState> emit) async {
    emit(HomeLoading());
    try {
      final projects = await getProjects();
      emit(HomeLoaded(projects));
    } catch (e) {
      emit(HomeError("Failed to fetch projects: $e"));
    }
  }

  Future<void> _onAddProject(AddProjectEvent event, Emitter<HomeState> emit) async {
    try {
      await addProject(event.project);
      add(FetchProjectsEvent());
    } catch (e) {
      emit(HomeError("Failed to add project: $e"));
    }
  }

  Future<void> _onUploadImage(UploadProjectImageEvent event, Emitter<HomeState> emit) async {
    try {
      await uploadImage(event.projectId, event.filePath);
      add(FetchProjectsEvent());
    } catch (e) {
      emit(HomeError("Failed to upload image: $e"));
    }
  }

  Future<void> _onUploadVideo(UploadProjectVideoEvent event, Emitter<HomeState> emit) async {
    try {
      await uploadVideo(event.projectId, event.filePath);
      add(FetchProjectsEvent());
    } catch (e) {
      emit(HomeError("Failed to upload video: $e"));
    }
  }

  Future<void> _onDeleteImage(DeleteProjectImageEvent event, Emitter<HomeState> emit) async {
    try {
      await deleteImage(event.projectId, event.imageUrl);
      add(FetchProjectsEvent());
    } catch (e) {
      emit(HomeError("Failed to delete image: $e"));
    }
  }

  Future<void> _onDeleteVideo(DeleteProjectVideoEvent event, Emitter<HomeState> emit) async {
    try {
      await deleteVideo(event.projectId, event.videoUrl);
      add(FetchProjectsEvent());
    } catch (e) {
      emit(HomeError("Failed to delete video: $e"));
    }
  }
}
