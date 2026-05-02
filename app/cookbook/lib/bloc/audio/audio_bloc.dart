import 'dart:async';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:just_audio/just_audio.dart';
import 'audio_event.dart';
import 'audio_state.dart';

class AudioBloc extends Bloc<AudioEvent, AudioState> {
  final AudioPlayer _audioPlayer;
  StreamSubscription<Duration>? _positionSubscription;
  StreamSubscription<Duration?>? _durationSubscription;
  StreamSubscription<PlayerState>? _playerStateSubscription;

  AudioBloc({AudioPlayer? audioPlayer})
      : _audioPlayer = audioPlayer ?? AudioPlayer(),
        super(const AudioState()) {
    on<AudioLoadRequested>(_onLoadRequested);
    on<AudioPlayRequested>(_onPlayRequested);
    on<AudioPauseRequested>(_onPauseRequested);
    on<AudioStopRequested>(_onStopRequested);
    on<AudioSeekRequested>(_onSeekRequested);
    on<AudioPositionChanged>(_onPositionChanged);
    on<AudioDurationChanged>(_onDurationChanged);
    on<AudioVolumeChanged>(_onVolumeChanged);
    on<AudioCompleted>(_onCompleted);

    _setupListeners();
  }

  void _setupListeners() {
    _positionSubscription = _audioPlayer.positionStream.listen((position) {
      add(AudioPositionChanged(position));
    });

    _durationSubscription = _audioPlayer.durationStream.listen((duration) {
      if (duration != null) {
        add(AudioDurationChanged(duration));
      }
    });

    _playerStateSubscription = _audioPlayer.playerStateStream.listen((state) {
      if (state.processingState == ProcessingState.completed) {
        add(const AudioCompleted());
      }
    });
  }

  @override
  Future<void> close() async {
    await _positionSubscription?.cancel();
    await _durationSubscription?.cancel();
    await _playerStateSubscription?.cancel();
    await _audioPlayer.dispose();
    return super.close();
  }

  Future<void> _onLoadRequested(
    AudioLoadRequested event,
    Emitter<AudioState> emit,
  ) async {
    emit(state.copyWith(
      status: AudioStatus.loading,
      currentUrl: event.audioUrl,
    ));

    try {
      await _audioPlayer.setUrl(event.audioUrl);

      emit(state.copyWith(status: AudioStatus.stopped));

      if (event.autoplay) {
        add(const AudioPlayRequested());
      }
    } catch (e) {
      emit(state.copyWith(
        status: AudioStatus.error,
        errorMessage: e.toString(),
      ));
    }
  }

  Future<void> _onPlayRequested(
    AudioPlayRequested event,
    Emitter<AudioState> emit,
  ) async {
    if (!state.hasAudio) return;

    try {
      await _audioPlayer.play();
      emit(state.copyWith(status: AudioStatus.playing));
    } catch (e) {
      emit(state.copyWith(
        status: AudioStatus.error,
        errorMessage: e.toString(),
      ));
    }
  }

  Future<void> _onPauseRequested(
    AudioPauseRequested event,
    Emitter<AudioState> emit,
  ) async {
    await _audioPlayer.pause();
    emit(state.copyWith(status: AudioStatus.paused));
  }

  Future<void> _onStopRequested(
    AudioStopRequested event,
    Emitter<AudioState> emit,
  ) async {
    await _audioPlayer.stop();
    await _audioPlayer.seek(Duration.zero);
    emit(state.copyWith(
      status: AudioStatus.stopped,
      position: Duration.zero,
    ));
  }

  Future<void> _onSeekRequested(
    AudioSeekRequested event,
    Emitter<AudioState> emit,
  ) async {
    await _audioPlayer.seek(event.position);
  }

  void _onPositionChanged(
    AudioPositionChanged event,
    Emitter<AudioState> emit,
  ) {
    emit(state.copyWith(position: event.position));
  }

  void _onDurationChanged(
    AudioDurationChanged event,
    Emitter<AudioState> emit,
  ) {
    emit(state.copyWith(duration: event.duration));
  }

  Future<void> _onVolumeChanged(
    AudioVolumeChanged event,
    Emitter<AudioState> emit,
  ) async {
    await _audioPlayer.setVolume(event.volume);
    emit(state.copyWith(volume: event.volume));
  }

  void _onCompleted(
    AudioCompleted event,
    Emitter<AudioState> emit,
  ) {
    emit(state.copyWith(
      status: AudioStatus.stopped,
      position: Duration.zero,
    ));
  }
}
