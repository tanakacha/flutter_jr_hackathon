import 'dart:async';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'wake_up_time_provider.g.dart';

@riverpod
class WakeUpTimeNotifier extends _$WakeUpTimeNotifier {
  Timer? _timer;

  @override
  int build() {
    return 0;
  }

  void startTimer() {
    _timer?.cancel();
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      state++;
    });
  }

  void stopTimer() {
    _timer?.cancel();
    _timer = null;
  }

  void resetTimer() {
    stopTimer();
    state = 0;
  }

  int get minutes => state ~/ 60;
  int get seconds => (state % 60);
}
