import 'package:get_it/get_it.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';

import 'package:project_management/features/auth/data/repositories/auth_repository_impl.dart';
import 'package:project_management/features/auth/domain/repositories/auth_repository.dart';
import 'package:project_management/features/auth/domain/usecases/forgot_password_usecase.dart';
import 'package:project_management/features/auth/domain/usecases/is_user_logged_in_usecase.dart';
import 'package:project_management/features/auth/domain/usecases/login_usecase.dart';
import 'package:project_management/features/auth/domain/usecases/signup_usecase.dart';

import 'package:project_management/features/home/data/datasources/project_remote_data_source.dart';
import 'package:project_management/features/home/data/repositories/project_repository_impl.dart';
import 'package:project_management/features/home/domain/repositories/project_repository.dart';
import 'package:project_management/features/home/domain/usecases/add_project_usecase.dart';
import 'package:project_management/features/home/domain/usecases/delete_image_usecase.dart';
import 'package:project_management/features/home/domain/usecases/delete_video_usecase.dart';
import 'package:project_management/features/home/domain/usecases/get_projects_usecase.dart';
import 'package:project_management/features/home/domain/usecases/upload_image_usecase.dart';
import 'package:project_management/features/home/domain/usecases/upload_video_usecase.dart';

final sl = GetIt.instance;

Future<void> setupLocator() async {
  sl.registerLazySingleton(() => FirebaseFirestore.instance);
  sl.registerLazySingleton(() => FirebaseStorage.instance);

  sl.registerLazySingleton<ProjectRemoteDataSource>(
    () => ProjectRemoteDataSourceImpl(
      firestore: sl(),
      storage: sl(),
    ),
  );

  sl.registerLazySingleton<AuthRepository>(() => AuthRepositoryImpl());
  sl.registerLazySingleton<ProjectRepository>(
    () => ProjectRepositoryImpl( sl()),
  );

  sl.registerLazySingleton(() => LoginUseCase(sl()));
  sl.registerLazySingleton(() => SignupUseCase(sl()));
  sl.registerLazySingleton(() => ForgotPasswordUseCase(sl()));
  sl.registerLazySingleton(() => IsUserLoggedInUseCase(sl()));

  sl.registerLazySingleton(() => GetProjectsUseCase(sl()));
  sl.registerLazySingleton(() => AddProjectUseCase(sl()));
  sl.registerLazySingleton(() => UploadImageUseCase(sl()));
  sl.registerLazySingleton(() => UploadVideoUseCase(sl()));
  sl.registerLazySingleton(() => DeleteImageUseCase(sl()));
  sl.registerLazySingleton(() => DeleteVideoUseCase(sl()));
}
