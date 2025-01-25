import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:todo/data/data.dart';
import 'package:todo/providers/providers.dart';
import 'package:todo/services/notification_service.dart';
import 'package:timezone/timezone.dart' as tz;

class TaskNotifier extends StateNotifier<TaskState> {
  final TaskRepository _repository;
  final NotificationService _notificationService;

  TaskNotifier(this._repository, this._notificationService)
      : super(const TaskState.initial()) {
    getTasks();
  }

  Future<void> createTask(Task task) async {
    try {
      await _repository.addTask(task);
      getTasks();

      if (task.isCompleted == false) {
        final taskDateTime = parseDateTime(task.date, task.time);

        final scheduledDate =
            tz.TZDateTime.parse(tz.local, taskDateTime.toString());
        final now = tz.TZDateTime.now(tz.local);

        if (scheduledDate.isAfter(now)) {
          final lastId = await _repository.getLastId();

          _notificationService.scheduleNotification(
            id: lastId,
            title: 'Pengingat Tugas',
            body: 'Ada tugas ${task.title} yang harus kamu selesaikan sekarang',
            scheduledDate: taskDateTime,
          );
        }
      }
    } catch (e) {
      debugPrint(e.toString());
    }
  }

  Future<void> deleteTask(Task task) async {
    try {
      await _repository.deleteTask(task);
      getTasks();

      _notificationService.cancelNotification(task.id ?? 0);
    } catch (e) {
      debugPrint(e.toString());
    }
  }

  Future<void> updateTask(Task task) async {
    try {
      final isCompleted = !task.isCompleted;
      final updatedTask = task.copyWith(isCompleted: isCompleted);
      await _repository.updateTask(updatedTask);
      getTasks();

      if (isCompleted) {
        _notificationService.cancelNotification(task.id ?? 0);
      } else {
        // Jika status tugas belum selesai, jadwalkan kembali notifikasi
        final taskDateTime = parseDateTime(task.date, task.time);

        final scheduledDate =
            tz.TZDateTime.parse(tz.local, taskDateTime.toString());
        final now = tz.TZDateTime.now(tz.local);

        if (scheduledDate.isAfter(now)) {
          final lastId = await _repository.getLastId();

          _notificationService.scheduleNotification(
            id: lastId,
            title: 'Pengingat Tugas',
            body: 'Ada tugas ${task.title} yang harus kamu selesaikan sekarang',
            scheduledDate: taskDateTime,
          );
        }
      }
    } catch (e) {
      debugPrint(e.toString());
    }
  }

  void getTasks() async {
    try {
      final tasks = await _repository.getAllTasks();
      state = state.copyWith(tasks: tasks);
    } catch (e) {
      debugPrint(e.toString());
    }
  }

  DateTime parseDateTime(String date, String time) {
    final timeParts = time.split('.');
    final hour = int.parse(timeParts[0]);
    final minute = int.parse(timeParts[1]);

    final dateFormat = DateFormat("d MMM yyyy", 'id_ID');

    final parsedDate = dateFormat.parse(date);

    final parsedDateTime = DateTime(
        parsedDate.year, parsedDate.month, parsedDate.day, hour, minute);

    return parsedDateTime;
  }
}
