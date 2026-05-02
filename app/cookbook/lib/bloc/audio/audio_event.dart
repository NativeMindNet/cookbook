import 'package:equatable/equatable.dart';

abstract class AudioEvent extends Equatable {
  const AudioEvent();

  @override
  List<Object?> get props => [];
}

class AudioLoadRequested extends AudioEvent {
  final String audioUrl;
  final bool autoplay;

  const AudioLoadRequested({
    required this.audioUrl,
    this.autoplay = false,
  });

  @override
  List<Object?> get props => [audioUrl, autoplay];
}

class AudioPlayRequested extends AudioEvent {
  const AudioPlayRequested();
}

class AudioPauseRequested extends AudioEvent {
  const AudioPauseRequested();
}

class AudioStopRequested extends AudioEvent {
  const AudioStopRequested();
}

class AudioSeekRequested extends AudioEvent {
  final Duration position;

  const AudioSeekRequested(this.position);

  @override
  List<Object?> get props => [position];
}

class AudioPositionChanged extends AudioEvent {
  final Duration position;

  const AudioPositionChanged(this.position);

  @override
  List<Object?> get props => [position];
}

class AudioDurationChanged extends AudioEvent {
  final Duration duration;

  const AudioDurationChanged(this.duration);

  @override
  List<Object?> get props => [duration];
}

class AudioVolumeChanged extends AudioEvent {
  final double volume;

  const AudioVolumeChanged(this.volume);

  @override
  List<Object?> get props => [volume];
}

class AudioCompleted extends AudioEvent {
  const AudioCompleted();
}
