import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:lottie/lottie.dart';
import 'package:task_reminder/features/task/presentation/cubit/task/task_cubit.dart';
import 'package:task_reminder/features/task/presentation/pages/task_page.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> with WidgetsBindingObserver {
  FlutterLocalNotificationsPlugin notificationsPlugin =
      FlutterLocalNotificationsPlugin();
  // Timer? _timer;
  // @override
  // void initState() {
  //   super.initState();
  //   WidgetsBinding.instance.addObserver(this); // 👈 register lifecycle observer
  //   // _startTimer();
  //   // // Keep foreground service running for reliability
  //   // _startService("Task Reminder Running", "Checking your tasks...");
  // }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    // _timer?.cancel();
    super.dispose();
  }

  // @override
  // void didChangeAppLifecycleState(AppLifecycleState state) {
  //   if (state == AppLifecycleState.paused) {
  //     _startService("Task Reminder Active", "Running in background...");
  //   } else if (state == AppLifecycleState.inactive) {
  //     _startService("Task Reminder Active", "Running in background...");
  //   } else if (state == AppLifecycleState.resumed) {
  //     _stopService();
  //   }
  // }
  // Future<void> showInstantNotification({
  //   required int id,
  //   required String title,
  //   required String body,
  // }) async {
  //   await notificationsPlugin.show(
  //     id,
  //     title,
  //     body,
  //     NotificationDetails(
  //       android: AndroidNotificationDetails(
  //         'instant_notification_channel_id',
  //         'Instant Notification',
  //         channelDescription: 'Instant Notification Description',
  //         importance: Importance.max,
  //         priority: Priority.high,
  //         ongoing: true,
  //         autoCancel: false,
  //       ),
  //       iOS: DarwinNotificationDetails(),
  //     ),
  //   );
  // }
  // void _startTimer() {
  //   // Check every minute
  //   _timer = Timer.periodic(Duration(seconds: 30), (timer) {
  //     _checkScheduledTasks();
  //   });
  // }
  // void _checkScheduledTasks() {
  //   final taskCubit = context.read<TaskCubit>();
  //   final state = taskCubit.state;
  //   if (state is TaskLoaded) {
  //     final now = DateTime.now();
  //     for (var task in state.tasks) {
  //       final taskDateTime = DateTime(
  //         task.scheduleDate.year,
  //         task.scheduleDate.month,
  //         task.scheduleDate.day,
  //         task.scheduleTime.hour,
  //         task.scheduleTime.minute,
  //       );
  //       // Check if task time matches current time (within 30 seconds window)
  //       if (!task.isCompleted &&
  //           now.isAfter(taskDateTime.subtract(const Duration(seconds: 30))) &&
  //           now.isBefore(taskDateTime.add(const Duration(seconds: 30)))) {
  //         // Show a unique notification for each task
  //         showInstantNotification(
  //           id: task.taskId.hashCode, // unique per task
  //           title: task.title, // task name
  //           body:
  //               "${task.scheduleDate.year}-${task.scheduleDate.month}-${task.scheduleDate.day} - ${task.scheduleTime.format(context)}",
  //         );
  //       }
  //     }
  //   }
  // }
  // Future<ServiceRequestResult> _startService(
  //   dynamic taskTitle,
  //   dynamic taskSchedule,
  // ) async {
  //   if (await FlutterForegroundTask.isRunningService) {
  //     return FlutterForegroundTask.restartService();
  //   } else {
  //     return FlutterForegroundTask.startService(
  //       serviceId: 256,
  //       notificationTitle: taskTitle,
  //       notificationText: taskSchedule,
  //       notificationIcon: null,
  //       notificationInitialRoute: '/',
  //       callback: startCallback,
  //     );
  //   }
  // }
  // Future<ServiceRequestResult> _stopService() {
  //   return FlutterForegroundTask.stopService();
  // }

  Future<void> cancelNotification(String taskId) async {
    await notificationsPlugin.cancel(taskId.hashCode);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Task Reminder"),
        actions: [IconButton(onPressed: () {}, icon: Icon(Icons.menu))],
      ),
      body: BlocBuilder<TaskCubit, TaskState>(
        builder: (context, state) {
          if (state is TaskLoading) {
            return Center(child: CircularProgressIndicator());
          } else if (state is TaskLoaded) {
            return Container(
              margin: EdgeInsets.all(10),
              child: state.tasks.isNotEmpty
                  ? ListView.builder(
                      itemCount: state.tasks.length,
                      itemBuilder: (context, index) {
                        final task = state.tasks[index];
                        return ListTile(
                          minTileHeight: 80,
                          leading: Checkbox(
                            value: task.isCompleted,
                            onChanged: (_) {
                              context.read<TaskCubit>().completeTask(
                                task.taskId,
                              );
                              notificationsPlugin.cancel(task.taskId.hashCode);
                              // _stopService();
                              cancelNotification(task.taskId);
                            },
                          ),
                          title: Text(task.title),
                          subtitle: Text(
                            "${task.scheduleDate.year}-${task.scheduleDate.month}-${task.scheduleDate.day} - ${task.scheduleTime.format(context)}",
                          ),
                          trailing: IconButton(
                            onPressed: () {
                              context.read<TaskCubit>().deleteTask(task.taskId);
                              cancelNotification(task.taskId);
                            },
                            icon: Icon(Icons.delete),
                          ),
                        );
                      },
                    )
                  : Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Lottie.asset(
                            'assets/lottie/1.json',
                            width: 200,
                            height: 200,
                          ),
                          SizedBox(height: 10),
                          Text("Create task to be reminded for it!"),
                        ],
                      ),
                    ),
            );
          } else if (state is TaskError) {
            return Center(child: Text("Error loading tasks"));
          }
          return Lottie.asset('assets/lottie/1.json', width: 200, height: 200);
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => TaskPage()),
          );
        },
        child: Icon(Icons.add),
      ),
    );
  }
}
