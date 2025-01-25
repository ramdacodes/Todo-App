import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:todo/services/notification_service.dart';

final notificationServiceProvider = Provider<NotificationService>((ref) {
  final notificationService = NotificationService();
  notificationService
      .initialize(); // Pastikan untuk menginisialisasi notifikasi saat aplikasi dimulai
  return notificationService;
});
