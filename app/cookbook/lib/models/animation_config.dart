import 'package:flutter/material.dart';

enum AnimationTargetType {
  image,
  keyframe,
  video,
}

abstract class AnimationConfig {
  final String name;
  final Offset center;
  final Size size;
  final Duration startDelay;
  final Duration delayBetweenCycles;
  final bool autostart;
  final bool repeat;

  const AnimationConfig({
    required this.name,
    this.center = Offset.zero,
    this.size = Size.zero,
    this.startDelay = Duration.zero,
    this.delayBetweenCycles = Duration.zero,
    this.autostart = false,
    this.repeat = false,
  });
}

class SpriteAnimationConfig extends AnimationConfig {
  final List<String> framePaths;
  final int fps;

  const SpriteAnimationConfig({
    required super.name,
    required this.framePaths,
    this.fps = 24,
    super.center,
    super.size,
    super.startDelay,
    super.delayBetweenCycles,
    super.autostart,
    super.repeat,
  });

  Duration get frameDuration => Duration(milliseconds: (1000 / fps).round());
}

class FadeAnimationConfig extends AnimationConfig {
  final double startAlpha;
  final double endAlpha;
  final Duration duration;

  const FadeAnimationConfig({
    required super.name,
    this.startAlpha = 1.0,
    this.endAlpha = 0.0,
    this.duration = const Duration(seconds: 1),
    super.center,
    super.size,
    super.startDelay,
    super.delayBetweenCycles,
    super.autostart,
    super.repeat,
  });
}

class RotateAnimationConfig extends AnimationConfig {
  final double startAngle;
  final double endAngle;
  final Duration duration;

  const RotateAnimationConfig({
    required super.name,
    this.startAngle = 0.0,
    this.endAngle = 360.0,
    this.duration = const Duration(seconds: 1),
    super.center,
    super.size,
    super.startDelay,
    super.delayBetweenCycles,
    super.autostart,
    super.repeat,
  });
}

class ScaleAnimationConfig extends AnimationConfig {
  final double startScale;
  final double endScale;
  final Duration duration;

  const ScaleAnimationConfig({
    required super.name,
    this.startScale = 1.0,
    this.endScale = 2.0,
    this.duration = const Duration(seconds: 1),
    super.center,
    super.size,
    super.startDelay,
    super.delayBetweenCycles,
    super.autostart,
    super.repeat,
  });
}
