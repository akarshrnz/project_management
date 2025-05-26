import 'package:project_management/features/home/domain/entites/project_entity.dart';

import '../repositories/project_repository.dart';

class AddProjectUseCase {
  final ProjectRepository repository;
  AddProjectUseCase(this.repository);

  Future<void> call(ProjectEntity project) => repository.addProject(project);
}
