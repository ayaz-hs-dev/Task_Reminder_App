import 'package:hive/hive.dart';
import 'package:task_reminder/features/task/data/data_sources/task_data_source.dart';
import 'package:task_reminder/features/task/data/model/task_model.dart';
import 'package:task_reminder/features/task/domain/entities/task_entity.dart';

class TaskDataSourceImpl implements TaskDataSource {
  final String boxName = 'taskBox';

  TaskDataSourceImpl();

  /// Add a new task
  @override
  Future<void> addTask(TaskEntity taskEntity) async {
    final taskBox = await Hive.openBox<TaskModel>(boxName);
    final taskModel = TaskModel.fromEntity(taskEntity);

    await taskBox.put(taskModel.taskId, taskModel);
  }

  /// Mark a task as completed
  @override
  Future<void> completeTask(String taskId) async {
    final taskBox = await Hive.openBox<TaskModel>(boxName);

    final task = taskBox.get(taskId);
    if (task != null) {
      task.isCompleted = true;
      await task.save();
    }
  }

  /// Get all tasks
  @override
  Future<List<TaskEntity>> getTasks() async {
    final taskBox = await Hive.openBox<TaskModel>(boxName);

    return taskBox.values.map((task) => task.toEntity()).toList();
  }

  /// Optional: delete a task
  @override
  Future<void> deleteTask(String taskId) async {
    final taskBox = await Hive.openBox<TaskModel>(boxName);
    await taskBox.delete(taskId);
  }
}
