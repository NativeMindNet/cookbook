import 'package:equatable/equatable.dart';

enum AudioStatus { idle, loading, playing, paused, stopped, error }

class AudioState extends Equatable {
  final AudioStatus status;
  final String? currentUrl;
  final Duration position;
  final Duration duration;
  final double volume;
  final String? errorMessage;

  const AudioState({
    this.status = AudioStatus.idle,
    this.currentUrl,
    this.position = Duration.zero,
    this.duration = Duration.zero,
    this.volume = 1.0,
    this.errorMessage,
  });

  bool get isPlaying => status == AudioStatus.playing;

  bool get isPaused => status == AudioStatus.paused;

  bool get hasAudio => currentUrl != null && currentUrl!.isNotEmpty;

  double get progress {
    if (duration.inMilliseconds == 0) return 0;
    return position.inMilliseconds / duration.inMilliseconds;
  }

  String get positionText => _formatDuration(position);

  String get durationText => _formatDuration(duration);

  String get remainingText => _formatDuration(duration - position);

  String _formatDuration(Duration d) {
    final minutes = d.inMinutes.remainder(60).toString().padLeft(2, '0');
    final seconds = d.inSeconds.remainder(60).toString().padLeft(2, '0');
    return '$minutes:$seconds';
  }

  AudioState copyWith({
    AudioStatus? status,
    String? currentUrl,
    Duration? position,
    Duration? duration,
    double? volume,
    String? errorMessage,
  }) {
    return AudioState(
      status: status ?? this.status,
      currentUrl: currentUrl ?? this.currentUrl,
      position: position ?? this.position,
      duration: duration ?? this.duration,
      volume: volume ?? this.volume,
      errorMessage: errorMessage ?? this.errorMessage,
    );
  }

  @override
  List<Object?> get props => [
        status,
        currentUrl,
        position,
        duration,
        volume,
        errorMessage,
      ];
}
