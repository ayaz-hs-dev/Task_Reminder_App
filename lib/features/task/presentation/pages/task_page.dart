import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:task_reminder/features/task/domain/entities/task_entity.dart';
import 'package:task_reminder/features/task/presentation/cubit/task/task_cubit.dart';
import 'package:timezone/timezone.dart' as tz;
import 'package:uuid/uuid.dart';

class TaskPage extends StatefulWidget {
  const TaskPage({super.key});

  @override
  State<TaskPage> createState() => _TaskPageState();
}

class _TaskPageState extends State<TaskPage> {
  FlutterLocalNotificationsPlugin notificationsPlugin =
      FlutterLocalNotificationsPlugin();
  TextEditingController taskNameController = TextEditingController();
  DateTime selectedDate = DateTime.now();
  TimeOfDay selectedTime = TimeOfDay.now();
  @override
  void initState() {
    super.initState();
    initFlutterNotification();
  }

  @override
  void dispose() {
    taskNameController.dispose();
    super.dispose();
  }

  Future<void> initFlutterNotification() async {
    const androidSettings = AndroidInitializationSettings(
      '@mipmap/ic_launcher',
    );
    const DarwinInitializationSettings iosSettings =
        DarwinInitializationSettings();
    const InitializationSettings initializationSettings =
        InitializationSettings(android: androidSettings, iOS: iosSettings);
    await notificationsPlugin.initialize(initializationSettings);
  }

  Future<void> scheduleNotification({
    required int id,
    required String title,
    required String body,
    required DateTime scheduledTime,
  }) async {
    await notificationsPlugin.zonedSchedule(
      id,
      title,
      body,
      tz.TZDateTime.from(scheduledTime, tz.local), // <-- timezone aware
      NotificationDetails(
        android: AndroidNotificationDetails(
          'task_channel_id',
          'Task Notifications',
          channelDescription: 'Reminders for your tasks',
          importance: Importance.max,
          priority: Priority.high,
          ongoing: true,
          autoCancel: false,
        ),
        iOS: DarwinNotificationDetails(),
      ),
      androidScheduleMode: AndroidScheduleMode.exact,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Create a Task")),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            SizedBox(
              width: MediaQuery.of(context).size.width * 0.8,
              child: TextField(
                textAlign: TextAlign.center,
                controller: taskNameController,
                style: TextStyle(fontSize: 30),
                decoration: InputDecoration(
                  border: InputBorder.none,
                  labelText: "Task Name",
                  hintText: "Enter Task Name",
                  hintStyle: TextStyle(fontSize: 25),
                  suffixIcon: Icon(Icons.edit),
                ),
              ),
            ),

            SizedBox(height: 10),
            InkWell(
              onTap: () {
                showTimePicker(
                  context: context,
                  initialTime: TimeOfDay(hour: 0, minute: 0),
                ).then((value) {
                  if (value != null) {
                    setState(() {
                      selectedTime = value;
                    });
                  }
                });
              },
              child: Container(
                width: 150,
                height: 50,
                padding: EdgeInsets.all(10),
                decoration: BoxDecoration(
                  border: Border.all(color: Colors.blue, width: 2),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Center(
                  child: Text(
                    selectedTime.format(context),
                    style: TextStyle(fontSize: 20),
                  ),
                ),
              ),
            ),
            SizedBox(height: 10),
            InkWell(
              onTap: () {
                showDatePicker(
                  initialDate: DateTime.now(),
                  firstDate: DateTime.now(),
                  lastDate: DateTime(2030, 12),
                  context: context,
                ).then((value) {
                  setState(() {
                    selectedDate = value!;
                  });
                });
              },
              child: Container(
                width: 150,
                height: 50,
                padding: EdgeInsets.all(10),
                decoration: BoxDecoration(
                  border: Border.all(color: Colors.blue, width: 2),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Center(
                  child: Text(
                    selectedDate.toLocal().toString().split(' ')[0],
                    style: TextStyle(fontSize: 20),
                  ),
                ),
              ),
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: () async {
                if (taskNameController.text.isNotEmpty) {
                  final task = TaskEntity(
                    title: taskNameController.text,
                    scheduleTime: selectedTime,
                    scheduleDate: selectedDate,
                    taskId: Uuid().v4(),
                  );
                  context.read<TaskCubit>().addTask(task);
                  final scheduledDateTime = DateTime(
                    task.scheduleDate.year,
                    task.scheduleDate.month,
                    task.scheduleDate.day,
                    task.scheduleTime.hour,
                    task.scheduleTime.minute,
                  );
                  final reminderDateTime = scheduledDateTime.subtract(
                    Duration(seconds: 30),
                  );
                  await scheduleNotification(
                    id: task.taskId.hashCode,
                    title: task.title,
                    body:
                        "Task reminder at ${task.scheduleTime.format(context)}",
                    scheduledTime: reminderDateTime,
                  );

                  Navigator.pop(context);
                } else {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text("Please enter a task name")),
                  );
                }
              },
              style: ElevatedButton.styleFrom(
                padding: EdgeInsets.symmetric(horizontal: 50, vertical: 15),
                backgroundColor: Colors.blue,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
              child: Text(
                "Save Task",
                style: TextStyle(color: Colors.white, fontSize: 20),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
