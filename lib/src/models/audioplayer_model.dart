import 'package:flutter/material.dart';

class AudioPlayerModel with ChangeNotifier {
  bool _isPlaying = false;
  Duration _songDuration = const Duration(milliseconds: 0);
  Duration _currentSecond = const Duration(milliseconds: 0);
  late AnimationController _controller;

  double get percentage => (_songDuration.inSeconds > 0)
      ? _currentSecond.inSeconds / _songDuration.inSeconds
      : 0;

  String get songTotalDuration => printDuration(_songDuration);
  String get currentSecond => printDuration(_currentSecond);

  AnimationController get controller => _controller;
  set controller(AnimationController value) {
    _controller = value;
  }

  bool get isPlaying => _isPlaying;
  set isPlaying(bool value) {
    _isPlaying = value;
    notifyListeners();
  }

  Duration get songDuration => _songDuration;
  set songDuration(Duration value) {
    _songDuration = value;
    notifyListeners();
  }

  Duration get current => _currentSecond;
  set current(Duration value) {
    _currentSecond = value;
    notifyListeners();
  }

  String printDuration(Duration duration) {
    String twoDigits(int n) {
      if (n >= 10) return "$n";

      return "0$n";
    }

    String twoDigitMinutes = twoDigits(duration.inMinutes.remainder(60));
    String twoDigitSeconds = twoDigits(duration.inSeconds.remainder(60));

    return "$twoDigitMinutes:$twoDigitSeconds";
  }
}
