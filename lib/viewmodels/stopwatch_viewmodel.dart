import 'dart:async';
import 'package:flutter/foundation.dart';
import 'package:lap_timer_mvvm/models/lap.dart';
import 'package:lap_timer_mvvm/services/notification_service.dart';
import 'package:lap_timer_mvvm/utils/time_format.dart';

class StopwatchViewModel extends ChangeNotifier {
  final _stopwatch = Stopwatch();
  Timer? _ticker;
  Timer? _pauseReminderTimer;

  Duration _lastLapMark = Duration.zero;
  final List<Lap> _laps = [];

  List<Lap> get laps => List.unmodifiable(_laps);
  Duration get elapsed => _stopwatch.elapsed;
  bool get isRunning => _stopwatch.isRunning;

  String get elapsedLabel => TimeFormat.mmssSSS(elapsed);

  void _startTicker() {
    _ticker?.cancel();
    _ticker = Timer.periodic(const Duration(milliseconds: 30), (_) async {
      notifyListeners();
   
      await NotificationService.instance.showOngoing(elapsedLabel);
    });
  }

  Future<void> start() async {
    if (_stopwatch.isRunning) return;
    _stopwatch.start();
    _startTicker();
    _cancelPauseReminder();
    await NotificationService.instance.showOngoing(elapsedLabel);
    notifyListeners();
  }

  Future<void> pause() async {
    if (!_stopwatch.isRunning) return;
    _stopwatch.stop();
    _ticker?.cancel();
    notifyListeners();

    // Inicia lembrete após 10s parado
    _pauseReminderTimer?.cancel();
    _pauseReminderTimer = Timer(const Duration(seconds: 10), () {
      NotificationService.instance.showOngoing(elapsedLabel);
    });
  }

  Future<void> reset() async {
    _stopwatch.reset();
    _lastLapMark = Duration.zero;
    _laps.clear();
    _ticker?.cancel();
    await NotificationService.instance.cancelOngoing();
    _cancelPauseReminder();
    notifyListeners();
  }

  Future<void> toggle() async => isRunning ? pause() : start();

  Future<void> addLap() async {
    final total = elapsed;
    final lapDuration = total - _lastLapMark;
    _lastLapMark = total;

    final lap = Lap(lapDuration: lapDuration, totalElapsed: total);
    _laps.insert(0, lap); // mais recente no topo
    notifyListeners();

    await NotificationService.instance
        .showLap(TimeFormat.mmssSSS(lapDuration), TimeFormat.mmssSSS(total));
  }

  void _cancelPauseReminder() {
    _pauseReminderTimer?.cancel();
    NotificationService.instance.cancelOngoing();
  }

  @override
  void dispose() {
    _ticker?.cancel();
    _pauseReminderTimer?.cancel();
    super.dispose();
  }
}
