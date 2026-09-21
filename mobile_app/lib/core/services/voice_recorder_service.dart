// lib/core/services/voice_recorder_service.dart
import 'dart:async';
import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:record/record.dart';
import 'package:audioplayers/audioplayers.dart';

class VoiceRecorderService {
  static final VoiceRecorderService _instance = VoiceRecorderService._internal();
  factory VoiceRecorderService() => _instance;
  VoiceRecorderService._internal();

  AudioRecorder? _audioRecorder;
  AudioPlayer? _audioPlayer;

  bool _isRecording = false;
  bool _isPlaying = false;
  String? _lastRecordedFilePath;
  int _recordingSeconds = 0;
  Timer? _recordingTimer;

  // Callbacks / Listeners
  final ValueNotifier<bool> isRecordingNotifier = ValueNotifier<bool>(false);
  final ValueNotifier<bool> isPlayingNotifier = ValueNotifier<bool>(false);
  final ValueNotifier<int> recordingDurationNotifier = ValueNotifier<int>(0);
  final ValueNotifier<String?> lastRecordedPathNotifier = ValueNotifier<String?>(null);

  bool get isRecording => _isRecording;
  bool get isPlaying => _isPlaying;
  String? get lastRecordedFilePath => _lastRecordedFilePath;
  int get recordingSeconds => _recordingSeconds;

  AudioRecorder get _recorder {
    _audioRecorder ??= AudioRecorder();
    return _audioRecorder!;
  }

  AudioPlayer get _player {
    if (_audioPlayer == null) {
      _audioPlayer = AudioPlayer();
      _audioPlayer!.onPlayerStateChanged.listen((state) {
        _isPlaying = (state == PlayerState.playing);
        isPlayingNotifier.value = _isPlaying;
      });
    }
    return _audioPlayer!;
  }

  /// Request microphone permission
  Future<bool> requestPermission() async {
    try {
      final status = await Permission.microphone.request();
      if (status.isGranted) return true;

      final hasRecordPerm = await _recorder.hasPermission();
      return hasRecordPerm;
    } catch (e) {
      debugPrint('Permission check error: $e');
      return true; // Fallback so app doesn't crash on desktop/web
    }
  }

  /// Start recording voice to local file
  Future<bool> startRecording() async {
    try {
      final hasPerm = await requestPermission();
      if (!hasPerm) {
        debugPrint('Microphone permission denied');
        return false;
      }

      // Stop any existing playback
      await stopPlayback();

      // Determine output file path
      final tempDir = await getTemporaryDirectory();
      final fileName = 'voice_craft_${DateTime.now().millisecondsSinceEpoch}.m4a';
      final filePath = '${tempDir.path}${Platform.pathSeparator}$fileName';

      // Start recorder with M4A/AAC config
      const config = RecordConfig(
        encoder: AudioEncoder.aacLc,
        bitRate: 128000,
        sampleRate: 44100,
      );

      await _recorder.start(config, path: filePath);

      _isRecording = true;
      _recordingSeconds = 0;
      _lastRecordedFilePath = filePath;
      isRecordingNotifier.value = true;
      recordingDurationNotifier.value = 0;
      lastRecordedPathNotifier.value = filePath;

      // Timer for recording duration
      _recordingTimer?.cancel();
      _recordingTimer = Timer.periodic(const Duration(seconds: 1), (timer) {
        _recordingSeconds++;
        recordingDurationNotifier.value = _recordingSeconds;
      });

      debugPrint('Voice recording started at: $filePath');
      return true;
    } catch (e) {
      debugPrint('Failed to start recording: $e');
      _isRecording = false;
      isRecordingNotifier.value = false;
      _recordingTimer?.cancel();
      return false;
    }
  }

  /// Stop recording voice and return saved audio file path
  Future<String?> stopRecording() async {
    try {
      _recordingTimer?.cancel();

      if (!_isRecording) {
        return _lastRecordedFilePath;
      }

      final recordedPath = await _recorder.stop();
      _isRecording = false;
      isRecordingNotifier.value = false;

      if (recordedPath != null && recordedPath.isNotEmpty) {
        _lastRecordedFilePath = recordedPath;
      }
      lastRecordedPathNotifier.value = _lastRecordedFilePath;

      debugPrint('Voice recording stopped. File: $_lastRecordedFilePath (Duration: ${_recordingSeconds}s)');
      return _lastRecordedFilePath;
    } catch (e) {
      debugPrint('Failed to stop recording: $e');
      _isRecording = false;
      isRecordingNotifier.value = false;
      _recordingTimer?.cancel();
      return _lastRecordedFilePath;
    }
  }

  /// Play the last recorded audio file
  Future<void> playRecording([String? customPath]) async {
    final path = customPath ?? _lastRecordedFilePath;
    if (path == null || path.isEmpty) return;

    try {
      final file = File(path);
      if (!file.existsSync()) {
        debugPrint('Recorded file does not exist at: $path');
        return;
      }

      await _player.stop();
      await _player.play(DeviceFileSource(path));
      _isPlaying = true;
      isPlayingNotifier.value = true;
    } catch (e) {
      debugPrint('Audio playback error: $e');
      _isPlaying = false;
      isPlayingNotifier.value = false;
    }
  }

  /// Pause current playback
  Future<void> pausePlayback() async {
    try {
      await _player.pause();
      _isPlaying = false;
      isPlayingNotifier.value = false;
    } catch (e) {
      debugPrint('Audio pause error: $e');
    }
  }

  /// Stop audio playback
  Future<void> stopPlayback() async {
    try {
      await _player.stop();
      _isPlaying = false;
      isPlayingNotifier.value = false;
    } catch (e) {
      debugPrint('Audio stop error: $e');
    }
  }

  /// Clean up resources
  void dispose() {
    _recordingTimer?.cancel();
    _audioRecorder?.dispose();
    _audioPlayer?.dispose();
    isRecordingNotifier.dispose();
    isPlayingNotifier.dispose();
    recordingDurationNotifier.dispose();
    lastRecordedPathNotifier.dispose();
  }
}
