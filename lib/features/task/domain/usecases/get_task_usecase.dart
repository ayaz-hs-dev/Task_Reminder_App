import 'package:task_reminder/features/task/domain/entities/task_entity.dart';
import 'package:task_reminder/features/task/domain/repository/task_repository.dart';

class GetTaskUsecase {
  final TaskRepository taskRepository;

  GetTaskUsecase(this.taskRepository);

  Future<List<TaskEntity>> call() async {
    return await taskRepository.getTasks();
  }
}
