import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:timezone/timezone.dart' as tz;

class NotificationService {
  static final NotificationService _instance = NotificationService._internal();
  factory NotificationService() => _instance;
  NotificationService._internal();

  final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
      FlutterLocalNotificationsPlugin();

  // Initialize the notification service
  Future<void> init() async {
    try {
      // Set up Android-specific settings
      const AndroidInitializationSettings initializationSettingsAndroid =
          AndroidInitializationSettings('@mipmap/ic_launcher');

      const InitializationSettings initializationSettings =
          InitializationSettings(android: initializationSettingsAndroid);

      // Create notification channel
      const AndroidNotificationChannel channel = AndroidNotificationChannel(
        'tumanina_notifications', // Channel ID
        'Tumanina Notifications', // Channel Name
        importance: Importance.max,
        enableLights: true,
        enableVibration: true,
        playSound: true,
      );

      // Initialize local notifications plugin
      await flutterLocalNotificationsPlugin.initialize(initializationSettings);

      // Register the notification channel
      await flutterLocalNotificationsPlugin
          .resolvePlatformSpecificImplementation<
              AndroidFlutterLocalNotificationsPlugin>()
          ?.createNotificationChannel(channel);
    } catch (e) {
      print("Error initializing notifications: $e");
    }
  }

  // Schedule a notification
  Future<void> scheduleNotification({
    required int id,
    required String title,
    required String body,
    required DateTime scheduledTime,
    required String sound,
  }) async {
    try {
      // Ensure the scheduled time is in the future
      if (scheduledTime.isBefore(DateTime.now())) {
        print("Scheduled time must be in the future");
        return;
      }

      // Convert scheduled time to TZDateTime for time zone support
      final tz.TZDateTime scheduledTZTime = tz.TZDateTime.from(scheduledTime, tz.local);

      // Android-specific notification settings
      final AndroidNotificationDetails androidPlatformChannelSpecifics =
          AndroidNotificationDetails(
        'prayer_notifications', // Channel ID
        'Prayer Notifications', // Channel Name
        importance: Importance.max,
        priority: Priority.high,
        sound: RawResourceAndroidNotificationSound(sound),
        playSound: true,
        enableLights: true,
        enableVibration: true,
      );

      final NotificationDetails platformChannelSpecifics =
          NotificationDetails(android: androidPlatformChannelSpecifics);

      // Schedule the notification
      await flutterLocalNotificationsPlugin.zonedSchedule(
        id,
        title,
        body,
        scheduledTZTime, // Use TZDateTime
        platformChannelSpecifics,
        androidScheduleMode: AndroidScheduleMode.exactAllowWhileIdle, // Allow notification while idle
        uiLocalNotificationDateInterpretation:
            UILocalNotificationDateInterpretation.absoluteTime,
      );
    } catch (e) {
      print("Error scheduling notification: $e");
    }
  }

  // Cancel a notification by ID
  Future<void> cancelNotification(int id) async {
    try {
      await flutterLocalNotificationsPlugin.cancel(id);
    } catch (e) {
      print("Error canceling notification: $e");
    }
  }
}
