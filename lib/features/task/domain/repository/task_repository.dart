import 'package:task_reminder/features/task/domain/entities/task_entity.dart';

abstract class TaskRepository {
  Future<void> addTask(TaskEntity taskEntity);
  Future<List<TaskEntity>> getTasks();
  Future<void> completeTask(String taskId);
  Future<void> deleteTask(String taskId);
}
