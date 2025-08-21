import 'package:task_reminder/features/task/domain/repository/task_repository.dart';

class DeleteTaskUsecase {
  final TaskRepository taskRepository;

  DeleteTaskUsecase(this.taskRepository);

  Future<void> call(String taskId) async {
    await taskRepository.deleteTask(taskId);
  }
}
