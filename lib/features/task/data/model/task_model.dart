// lib/features/task/data/models/task_model.dart
import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import '../../domain/entities/task_entity.dart';

part 'task_model.g.dart';

@HiveType(typeId: 0)
class TaskModel extends HiveObject {
  @HiveField(0)
  final String taskId;

  @HiveField(1)
  final String title;

  @HiveField(2)
  final String scheduleTime; // store as "HH:mm" in Hive

  @HiveField(3)
  final DateTime scheduleDate;

  @HiveField(4)
  bool isCompleted;

  TaskModel({
    required this.taskId,
    required this.title,
    required this.scheduleTime,
    required this.scheduleDate,
    this.isCompleted = false,
  });

  /// Convert Entity → Model
  factory TaskModel.fromEntity(TaskEntity taskEntity) {
    return TaskModel(
      taskId: taskEntity.taskId,
      title: taskEntity.title,
      // store TimeOfDay as String
      scheduleTime:
          "${taskEntity.scheduleTime.hour.toString().padLeft(2, '0')}:${taskEntity.scheduleTime.minute.toString().padLeft(2, '0')}",
      scheduleDate: taskEntity.scheduleDate,
      isCompleted: taskEntity.isCompleted,
    );
  }

  /// Convert Model → Entity
  TaskEntity toEntity() {
    // convert "HH:mm" back into TimeOfDay
    final parts = scheduleTime.split(":");
    final hour = int.parse(parts[0]);
    final minute = int.parse(parts[1]);

    return TaskEntity(
      taskId: taskId,
      title: title,
      scheduleTime: TimeOfDay(hour: hour, minute: minute),
      scheduleDate: scheduleDate,
      isCompleted: isCompleted,
    );
  }
}
