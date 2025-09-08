class Lap {
  final Duration lapDuration;
  final Duration totalElapsed;
  final DateTime createdAt;

  Lap({
    required this.lapDuration,
    required this.totalElapsed,
    DateTime? createdAt,
  }) : createdAt = createdAt ?? DateTime.now();
}
