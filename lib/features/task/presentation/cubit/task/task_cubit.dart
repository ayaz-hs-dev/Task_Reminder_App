import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:task_reminder/features/task/domain/entities/task_entity.dart';
import 'package:task_reminder/features/task/domain/usecases/add_task_usecase.dart';
import 'package:task_reminder/features/task/domain/usecases/complete_task_usecase.dart';
import 'package:task_reminder/features/task/domain/usecases/delete_task_usecase.dart';
import 'package:task_reminder/features/task/domain/usecases/get_task_usecase.dart';

part 'task_state.dart';

class TaskCubit extends Cubit<TaskState> {
  final AddTaskUsecase addTaskUsecase;
  final GetTaskUsecase getTaskUsecase;
  final CompleteTaskUsecase completeTaskUsecase;
  final DeleteTaskUsecase deleteTaskUsecase;
  TaskCubit({
    required this.deleteTaskUsecase,
    required this.addTaskUsecase,
    required this.completeTaskUsecase,
    required this.getTaskUsecase,
  }) : super(TaskInitial());

  Future<void> getTasks() async {
    emit(TaskLoading());
    try {
      final tasks = await getTaskUsecase();
      emit(TaskLoaded(tasks));
    } catch (e) {
      emit(TaskError(e.toString()));
    }
  }

  Future<void> addTask(TaskEntity taskEntity) async {
    emit(TaskLoading());
    try {
      await addTaskUsecase(taskEntity);
      await getTasks();
    } catch (e) {
      emit(TaskError(e.toString()));
    }
  }

  Future<void> completeTask(String taskId) async {
    emit(TaskLoading());
    try {
      await completeTaskUsecase(taskId);
      await getTasks();
    } catch (e) {
      emit(TaskError(e.toString()));
    }
  }

  Future<void> deleteTask(String taskId) async {
    emit(TaskLoading());
    try {
      await deleteTaskUsecase(taskId);
      await getTasks();
    } catch (e) {
      emit(TaskError(e.toString()));
    }
  }
}
