import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'difficulty_provider.g.dart';

@riverpod
class DifficultyNotifier extends _$DifficultyNotifier {
  @override
  String build() {
    // 初期値を設定
    return 'Normal';
  }

  void setDifficulty(String difficulty) {
    state = difficulty;
  }
}
