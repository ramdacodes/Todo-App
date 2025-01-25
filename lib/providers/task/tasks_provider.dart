import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:todo/data/data.dart';
import 'package:todo/providers/notification_service_provider.dart';
import 'package:todo/providers/providers.dart';

final tasksProvider = StateNotifierProvider<TaskNotifier, TaskState>((ref) {
  final repository = ref.watch(taskRepositoryProvider);
  final notificationService = ref.watch(notificationServiceProvider);
  return TaskNotifier(repository, notificationService);
});
