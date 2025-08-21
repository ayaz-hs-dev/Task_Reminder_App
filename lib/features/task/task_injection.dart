import 'package:task_reminder/features/task/data/data_sources/task_data_resource_impl.dart';
import 'package:task_reminder/features/task/data/data_sources/task_data_source.dart';
import 'package:task_reminder/features/task/data/repository/task_repository_impl.dart';
import 'package:task_reminder/features/task/domain/repository/task_repository.dart';
import 'package:task_reminder/features/task/domain/usecases/add_task_usecase.dart';
import 'package:task_reminder/features/task/domain/usecases/complete_task_usecase.dart';
import 'package:task_reminder/features/task/domain/usecases/delete_task_usecase.dart';
import 'package:task_reminder/features/task/domain/usecases/get_task_usecase.dart';
import 'package:task_reminder/features/task/presentation/cubit/task/task_cubit.dart';
import 'package:task_reminder/main_injection.dart';

Future<void> taskInjection() async {
  // *CUBITS

  s1.registerFactory<TaskCubit>(
    () => TaskCubit(
      addTaskUsecase: s1.call(),
      getTaskUsecase: s1.call(),
      completeTaskUsecase: s1.call(),
      deleteTaskUsecase: s1.call(),
    ),
  );

  // *USECASES
  s1.registerLazySingleton<AddTaskUsecase>(() => AddTaskUsecase(s1.call()));

  s1.registerLazySingleton<GetTaskUsecase>(() => GetTaskUsecase(s1.call()));

  s1.registerLazySingleton<CompleteTaskUsecase>(
    () => CompleteTaskUsecase(s1.call()),
  );
  s1.registerLazySingleton<DeleteTaskUsecase>(
    () => DeleteTaskUsecase(s1.call()),
  );

  // *REPOSITORY

  s1.registerLazySingleton<TaskRepository>(() => TaskRepositoryImpl(s1.call()));

  // *DATA SOURCE
  s1.registerLazySingleton<TaskDataSource>(() => TaskDataSourceImpl());
}
