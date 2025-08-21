import 'package:task_reminder/features/task/domain/entities/task_entity.dart';
import 'package:task_reminder/features/task/domain/repository/task_repository.dart';

class AddTaskUsecase {
  final TaskRepository taskRepository;
  AddTaskUsecase(this.taskRepository);

  Future<void> call(TaskEntity taskEntity) async {
    await taskRepository.addTask(taskEntity);
  }
}
