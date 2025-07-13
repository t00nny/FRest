// lib/src/utils/duration_formatter.dart

String formatDuration(Duration d) {
  var seconds = d.inSeconds;
  final days = seconds ~/ Duration.secondsPerDay;
  seconds -= days * Duration.secondsPerDay;
  final hours = seconds ~/ Duration.secondsPerHour;
  seconds -= hours * Duration.secondsPerHour;
  final minutes = seconds ~/ Duration.secondsPerMinute;
  seconds -= minutes * Duration.secondsPerMinute;

  final List<String> parts = [];
  if (days > 0) {
    parts.add('${days.toString().padLeft(2, '0')}d');
  }
  parts.add('${hours.toString().padLeft(2, '0')}h');
  parts.add('${minutes.toString().padLeft(2, '0')}m');
  parts.add('${seconds.toString().padLeft(2, '0')}s');

  return parts.join(' : ');
}
