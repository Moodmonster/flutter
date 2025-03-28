import 'package:just_audio/just_audio.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'audio.viewmodel.g.dart';

class AudioState {
  AudioState({
    required this.isPlaying,
    required this.audioPlayer,
    required this.title,
    required this.coverImg,
    required this.ttsUrl
  });

  bool isPlaying;
  AudioPlayer audioPlayer;
  String title;
  String coverImg;
  String ttsUrl;
}

@Riverpod(keepAlive: true)
class AudioController extends _$AudioController {
  @override
  AudioState build() {
    return AudioState(
      isPlaying: false,
      audioPlayer: AudioPlayer(),
      title: '',
      coverImg: '',
      ttsUrl: ''
    );
  }

  void setState() {
    state = AudioState(
      isPlaying: state.isPlaying,
      audioPlayer: state.audioPlayer,
      title: state.title,
      coverImg: state.coverImg,
      ttsUrl: state.ttsUrl
    );
  }

  void initScreen({
    required String title,
    required String coverImg,
    required String ttsUrl
  }) {
    state.title = title;
    state.coverImg = coverImg;
    state.ttsUrl = ttsUrl;
    setState();
  }

  void audioDispose() {
    state.audioPlayer.dispose();
    state.isPlaying = false;
    setState();
  }

  Future<void> togglePlayPause() async {
    state.isPlaying = !state.isPlaying;

    if (state.isPlaying) {
      state.audioPlayer.play();
    } else {
      state.audioPlayer.pause();
    }
    setState();
  }

  Future<void> reset() async {
    await state.audioPlayer.seek(Duration.zero);
    await state.audioPlayer.pause();
    state.isPlaying = false;
    setState();
  }

  Future<void> seekTo(double value) async {
    await state.audioPlayer.seek(
      Duration(
        milliseconds: (value * state.audioPlayer.duration!.inMilliseconds).toInt(),
      ),
    );
    setState();
  }
}