import 'package:task_reminder/features/task/data/data_sources/task_data_source.dart';
import 'package:task_reminder/features/task/domain/entities/task_entity.dart';
import 'package:task_reminder/features/task/domain/repository/task_repository.dart';

class TaskRepositoryImpl implements TaskRepository {
  final TaskDataSource taskDataSource;

  TaskRepositoryImpl(this.taskDataSource);
  @override
  Future<void> addTask(TaskEntity taskEntity) async {
    taskDataSource.addTask(taskEntity);
  }

  @override
  Future<void> completeTask(String taskId) async {
    taskDataSource.completeTask(taskId);
  }

  @override
  Future<List<TaskEntity>> getTasks() async {
    return taskDataSource.getTasks();
  }

  @override
  Future<void> deleteTask(String taskId) async {
    return taskDataSource.deleteTask(taskId);
  }
}
