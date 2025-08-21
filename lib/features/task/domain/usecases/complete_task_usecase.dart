import 'package:task_reminder/features/task/domain/repository/task_repository.dart';

class CompleteTaskUsecase {
  final TaskRepository taskRepository;

  CompleteTaskUsecase(this.taskRepository);

  Future<void> call(String taskId) async {
    await taskRepository.completeTask(taskId);
  }
}
