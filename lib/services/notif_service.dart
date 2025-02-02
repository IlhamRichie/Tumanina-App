import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:timezone/timezone.dart' as tz;
import 'package:timezone/data/latest.dart' as tz;

class NotificationService {
  static final NotificationService _instance = NotificationService._internal();
  factory NotificationService() => _instance;
  NotificationService._internal();

  final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
      FlutterLocalNotificationsPlugin();

  bool _isInitialized = false;

  // Initialize the notification service
  Future<void> init() async {
    if (_isInitialized) return;

    try {
      tz.initializeTimeZones();

      const AndroidInitializationSettings initializationSettingsAndroid =
          AndroidInitializationSettings('@mipmap/ic_launcher');

      const InitializationSettings initializationSettings =
          InitializationSettings(android: initializationSettingsAndroid);

      // Buat channel notification dengan suara default
      const AndroidNotificationChannel channel = AndroidNotificationChannel(
        'tumanina_notifications', // Channel ID
        'Tumanina Notifications', // Channel Name
        importance: Importance.max,
        playSound: true,
        sound: RawResourceAndroidNotificationSound(
            'notification'), // Suara default
      );

      await flutterLocalNotificationsPlugin.initialize(initializationSettings);

      await flutterLocalNotificationsPlugin
          .resolvePlatformSpecificImplementation<
              AndroidFlutterLocalNotificationsPlugin>()
          ?.createNotificationChannel(channel);

      _isInitialized = true;
      print("Notification service initialized successfully");
    } catch (e) {
      print("Error initializing notifications: $e");
      _isInitialized = false;
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
    if (!_isInitialized) {
      print("Notification service is not initialized");
      return;
    }

    try {
      if (scheduledTime.isBefore(DateTime.now())) {
        print("Scheduled time must be in the future");
        return;
      }

      final tz.TZDateTime scheduledTZTime =
          tz.TZDateTime.from(scheduledTime, tz.local);

      // Gunakan suara yang dipilih
      final AndroidNotificationDetails androidPlatformChannelSpecifics =
          AndroidNotificationDetails(
        'prayer_notifications', // Channel ID
        'Prayer Notifications', // Channel Name
        importance: Importance.max,
        priority: Priority.high,
        sound: RawResourceAndroidNotificationSound(
            sound), // Gunakan suara yang dipilih
        playSound: true,
        enableLights: true,
        enableVibration: true,
      );

      final NotificationDetails platformChannelSpecifics =
          NotificationDetails(android: androidPlatformChannelSpecifics);

      await flutterLocalNotificationsPlugin.zonedSchedule(
        id,
        title,
        body,
        scheduledTZTime,
        platformChannelSpecifics,
        androidScheduleMode: AndroidScheduleMode.exactAllowWhileIdle,
        uiLocalNotificationDateInterpretation:
            UILocalNotificationDateInterpretation.absoluteTime,
      );

      print(
          "Notification scheduled successfully for $scheduledTZTime with sound: $sound");
    } catch (e) {
      print("Error scheduling notification: $e");
    }
  }

  // Cancel a notification by ID
  Future<void> cancelNotification(int id) async {
    if (!_isInitialized) {
      print("Notification service is not initialized");
      return;
    }

    try {
      await flutterLocalNotificationsPlugin.cancel(id);
      print("Notification with id $id canceled successfully");
    } catch (e) {
      print("Error canceling notification: $e");
    }
  }
}
