import 'package:just_audio/just_audio.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'novel_paragraph.viewmodel.g.dart';

class NovelParagraphViewModelState {
  NovelParagraphViewModelState({
    required this.player,
    required this.isMuted,
  });

  AudioPlayer player;
  bool isMuted;
}

@riverpod
class NovelParagraphViewModelController extends _$NovelParagraphViewModelController {
  @override
  NovelParagraphViewModelState build() {
    return NovelParagraphViewModelState(
      player: AudioPlayer(),
      isMuted: false,
    );
  }

  void setState() {
    state = NovelParagraphViewModelState(
      player: state.player,
      isMuted: state.isMuted,
    );
  }

  //노래 재생시키는 함수
  Future<void> playAudio(String musicUrl) async {
    // 기존에 재생 중인 플레이어가 있고 재생중인게 내 플레이어가 아니라면 멈춤
    if (state.player.playing) {
      for (double volume = 1.0; volume >= 0.0; volume -= 0.1) {
        await Future.delayed(const Duration(milliseconds: 100));
        await state.player.setVolume(volume);
      }
      await state.player.stop();
      await state.player.setVolume(1);
    }

    try {
      //url과 연결된 음악 재생 시도
      await state.player.setUrl(musicUrl);
    } catch (e) {
      //url음악은 실패했다면
      print("Azure URL로 노래 재생 실패: $e");
      //아무노래도 재생하지 않는다
      return;
    }
    //만약 현재 음소거 상태라면 소리 0으로 세팅
    if (state.isMuted) {
      state.player.setVolume(0);
    }
    //음악 재생
    state.player.play();
  }

  //음소거 컨트롤 버튼
  void handleMute() {
    if(state.isMuted) {
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