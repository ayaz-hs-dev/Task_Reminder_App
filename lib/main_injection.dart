import 'package:get_it/get_it.dart';
import 'package:task_reminder/features/task/task_injection.dart';

final s1 = GetIt.instance;

Future<void> init() async {
  await taskInjection();
}
