import 'package:permission_handler/permission_handler.dart';
import 'package:timezone/timezone.dart' as tz;
import 'package:timezone/data/latest.dart' as tz;
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:todo/app/app.dart';
import 'package:todo/services/notification_service.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  tz.initializeTimeZones();

  tz.setLocalLocation(tz.getLocation('Asia/Jakarta'));

  await NotificationService().initialize();

  await requestPermission();

  await initializeDateFormatting('id_ID', null).then((_) => runApp(
        const ProviderScope(
          child: TodoApp(),
        ),
      ));
}

Future<void> requestPermission() async {
  if (await Permission.notification.isDenied ||
      await Permission.notification.isPermanentlyDenied ||
      await Permission.notification.isRestricted) {
    // Meminta izin notifikasi jika belum diberikan
    await Permission.notification.request();
  }

  if (await Permission.scheduleExactAlarm.isDenied ||
      await Permission.scheduleExactAlarm.isPermanentlyDenied ||
      await Permission.scheduleExactAlarm.isRestricted) {
    await Permission.scheduleExactAlarm.request();
  }
}
