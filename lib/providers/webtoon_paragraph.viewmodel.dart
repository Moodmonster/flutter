import 'package:just_audio/just_audio.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'webtoon_paragraph.viewmodel.g.dart';

class WebtoonParagraphViewModelState {
  WebtoonParagraphViewModelState({required this.player, required this.isMuted});

  AudioPlayer player;
  bool isMuted;
}

@riverpod
class WebtoonParagraphViewModelController
    extends _$WebtoonParagraphViewModelController {
  @override
  WebtoonParagraphViewModelState build() {
    return WebtoonParagraphViewModelState(
      player: AudioPlayer(),
      isMuted: false,
    );
  }

  void setState() {
    state = WebtoonParagraphViewModelState(
      player: state.player,
      isMuted: state.isMuted,
    );
  }

  Future<void> playAudio(String musicUrl) async {
    if (state.player.playing) {
      for (double volume = 1.0; volume >= 0.0; volume -= 0.1) {
        await Future.delayed(const Duration(milliseconds: 100));
        await state.player.setVolume(volume);
      }
      await state.player.stop();
      await state.player.setVolume(1);
    }

    try {
      await state.player.setUrl(musicUrl);
    } catch (e) {
      print("Azure URL로 노래 재생 실패: \$e");
      return;
    }
    if (state.isMuted) {
      state.player.setVolume(0);
    }
    state.player.play();
  }

  void handleMute() {
    if (state.isMuted) {
      state.player.setVolume(1);
    } else {
      state.player.setVolume(0);
    }
    state.isMuted = !state.isMuted;
    setState();
  }

  void audioDispose() {
    state.player.dispose();
  }
}
