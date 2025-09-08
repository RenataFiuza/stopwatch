import 'dart:io';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:timezone/timezone.dart' as tz;

class NotificationService {
  NotificationService._();
  static final instance = NotificationService._();

  final _fln = FlutterLocalNotificationsPlugin();

  static const _channelIdRun = 'lap_timer_running';
  static const _channelIdEvents = 'lap_timer_events';
  static const _ongoingId = 1;
  static const _resumeId = 3;

  Future<void> init() async {
    const androidInit = AndroidInitializationSettings('@mipmap/ic_launcher');
    final darwinInit = DarwinInitializationSettings(
      requestAlertPermission: true,
      requestBadgePermission: false,
      requestSoundPermission: true,
      onDidReceiveLocalNotification: (id, title, body, payload) async {},
    );

    await _fln.initialize(
     InitializationSettings(android: androidInit, iOS: darwinInit),
    );

    if (Platform.isAndroid) {
      // Canais
      const runChannel = AndroidNotificationChannel(
        _channelIdRun,
        'Cronômetro em execução',
        description:
            'Notificação persistente enquanto o cronômetro estiver rodando.',
        importance: Importance.low,
        enableVibration: false,
        playSound: false,
        showBadge: false,
      );

      const eventsChannel = AndroidNotificationChannel(
        _channelIdEvents,
        'Eventos do cronômetro',
        description: 'Voltas, pausas e lembretes.',
        importance: Importance.defaultImportance,
      );

      await _fln
          .resolvePlatformSpecificImplementation<
              AndroidFlutterLocalNotificationsPlugin>()
          ?.createNotificationChannel(runChannel);

      await _fln
          .resolvePlatformSpecificImplementation<
              AndroidFlutterLocalNotificationsPlugin>()
          ?.createNotificationChannel(eventsChannel);
    }
  }

  Future<void> showOngoing(String elapsed) async {
    const android = AndroidNotificationDetails(
      _channelIdRun,
      'Cronômetro em execução',
      channelDescription:
          'Notificação persistente enquanto o cronômetro estiver rodando.',
      ongoing: true,
      onlyAlertOnce: true,
      category: AndroidNotificationCategory.stopwatch,
      priority: Priority.low,
      importance: Importance.low,
      showWhen: false,
    );
    const ios = DarwinNotificationDetails(
      presentAlert: false,
      presentSound: false,
      presentBadge: false,
    );

    await _fln.show(
      _ongoingId,
      'Cronômetro em execução',
      elapsed,
      const NotificationDetails(android: android, iOS: ios),
    );
  }

  Future<void> cancelOngoing() => _fln.cancel(_ongoingId);

  Future<void> showLap(String lap, String total) async {
    const android = AndroidNotificationDetails(
      _channelIdEvents,
      'Eventos do cronômetro',
      channelDescription: 'Voltas, pausas e lembretes.',
      priority: Priority.high,
      importance: Importance.high,
    );
    const ios = DarwinNotificationDetails();

    await _fln.show(
      DateTime.now().millisecondsSinceEpoch ~/ 1000,
      'Volta registrada',
      'Volta: $lap | Total: $total',
      NotificationDetails(android: android, iOS: ios),
    );
  }

  Future<void> scheduleResumeReminder() async {
    const android = AndroidNotificationDetails(
      _channelIdEvents,
      'Eventos do cronômetro',
      channelDescription: 'Voltas, pausas e lembretes.',
      priority: Priority.defaultPriority,
      importance: Importance.defaultImportance,
    );
    const ios = DarwinNotificationDetails();

    // Agenda para 10s
    await _fln.zonedSchedule(
      _resumeId,
      'Cronômetro pausado',
      'Está parado há mais de 10s. Deseja retomar?',
      tz.TZDateTime.now(tz.local).add(const Duration(seconds: 10)),
      NotificationDetails(android: android, iOS: ios),
      androidScheduleMode: AndroidScheduleMode.exactAllowWhileIdle,
      uiLocalNotificationDateInterpretation:
          UILocalNotificationDateInterpretation.absoluteTime,
      payload: 'resume_suggestion',
      matchDateTimeComponents: null,
    );
  }

  Future<void> cancelResumeReminder() => _fln.cancel(_resumeId);
}
