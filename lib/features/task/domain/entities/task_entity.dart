// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:flutter/material.dart';

class TaskEntity {
  String taskId;
  String title;
  TimeOfDay scheduleTime;
  DateTime scheduleDate;
  bool isCompleted;

  TaskEntity({
    required this.taskId,
    required this.title,
    required this.scheduleTime,
    required this.scheduleDate,
    this.isCompleted = false,
  });
}
