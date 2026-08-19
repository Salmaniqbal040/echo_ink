import 'dart:io';
import 'package:path_provider/path_provider.dart';
import 'package:record/record.dart';

class RecordingResult { const RecordingResult({required this.path, required this.duration}); final String path; final Duration duration; }
abstract class RecordingRepository { Future<bool> start(); Future<RecordingResult?> stop(); Future<void> dispose(); }
class LocalRecordingRepository implements RecordingRepository { final AudioRecorder _recorder = AudioRecorder(); DateTime? _startedAt;
  @override Future<bool> start() async { if (!await _recorder.hasPermission()) return false; final directory = await getApplicationDocumentsDirectory(); final audioDirectory = Directory('${directory.path}${Platform.pathSeparator}echoink_audio'); if (!await audioDirectory.exists()) await audioDirectory.create(recursive: true); final path = '${audioDirectory.path}${Platform.pathSeparator}${DateTime.now().microsecondsSinceEpoch}.m4a'; await _recorder.start(const RecordConfig(encoder: AudioEncoder.aacLc), path: path); _startedAt = DateTime.now(); return true; }
  @override Future<RecordingResult?> stop() async { final path = await _recorder.stop(); final startedAt = _startedAt; _startedAt = null; if (path == null || startedAt == null) return null; return RecordingResult(path: path, duration: DateTime.now().difference(startedAt)); }
  @override Future<void> dispose() => _recorder.dispose(); }
