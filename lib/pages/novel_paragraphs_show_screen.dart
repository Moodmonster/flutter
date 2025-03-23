import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:just_audio/just_audio.dart';
import 'package:moodmonster/config/routes/app_router.dart';
import 'package:moodmonster/feature/error/data_null_screen.dart';
import 'package:moodmonster/helpers/constants/app_colors.dart';
import 'package:moodmonster/models/content_episode.model.dart';
import 'package:moodmonster/models/novel_paragraph.model.dart';
import 'package:moodmonster/providers/novel_paragraph_provider.dart';

class NovelParagraphsShowScreen extends ConsumerStatefulWidget {
  const NovelParagraphsShowScreen({super.key});

  @override
  ConsumerState<NovelParagraphsShowScreen> createState() =>
      _NovelParagraphsShowScreenState();
}

class _NovelParagraphsShowScreenState
    extends ConsumerState<NovelParagraphsShowScreen> {
  ContentEpisode? episodeInfo;
  bool _initialized = false;

  //최초로 해당 에피소드의 단락 데이터들 가져오기
  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (_initialized) return;

    //현재 routeing방식은 path파라미터 방식말고 arguments에 보내는 방식 -> 나중에 수정해함
    final args =
        ModalRoute.of(context)?.settings.arguments as Map<String, dynamic>?;
    // arguments에서 episode에 해당하는 데이터 뽑고
    episodeInfo = args?['episode'] as ContentEpisode?;
    // arguments에서 prompt(원하는 음악 분위기)에 해당하는 데이터 뽑는다
    final prompt = args?['prompt'] as String? ?? '';

    print("episodeInfo${episodeInfo}");
    print("prompt:${prompt}");

    if (episodeInfo != null) {
      // 해당 에피소드의 단락 데이터 백엔드로부터 가져오기 실행
      ref
          .read(NovelParagraphProvider.notifier)
          .loadParagraphs(code: episodeInfo!.code, prompt: prompt);
    }

    _initialized = true;
  }

  @override
  Widget build(BuildContext context) {
    final novelParagraphsAsync = ref.watch(NovelParagraphProvider);
    //episodeInfo가 없으면 데이터 없다는 내용의 화면 띄운다
    if (episodeInfo == null) {
      return DataNullScreen();
    }

    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            _MyAppBar(episodeInfo: episodeInfo!),
            Expanded(
              //소설 단락들 담는 프로바이더의 상태에 따라 다른 내용 보이도록
              child: novelParagraphsAsync.when(
                //데이터 정상적으로 있는 상태라면
                data: (paragraphs) {
                  AudioPlayer _audioPlayer = AudioPlayer();
                  return _buildParagraphsScreenUI(paragraphs, _audioPlayer);
                },
                // 로딩중이라면
                loading: () => Center(child: CircularProgressIndicator()),
                // 에러난 상태면
                error: (e, _) => Center(child: Text('오류 발생: $e')),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

//내가 만든 앱바
class _MyAppBar extends StatefulWidget {
  final ContentEpisode episodeInfo;
  _MyAppBar({super.key, required this.episodeInfo});

  @override
  State<_MyAppBar> createState() => __MyAppBarState();
}

class __MyAppBarState extends State<_MyAppBar> {
  //현재 음소거 여부 : 처음에는 false
  bool _isMuted = false;
  //기존 음량크기 정보(일단 1로 설정. 음소거 누르면 업데이트되어 재생중이던 음량 정보로 업데이트됨)
  double _originalVolume = 1;
  @override
  Widget build(BuildContext context) {
    return Container(
      height: 55.h,
      color: AppColors.background,
      padding: EdgeInsets.symmetric(horizontal: 8.w),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          //뒤로 가기 버튼
          IconButton(
            onPressed: () {
              AppRouter.pop();
            },
            icon: Icon(Icons.arrow_back_ios_new),
          ),
          //에피소드 제목
          Expanded(
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: 8.w),
              child: Text(
                widget.episodeInfo.epTitle ?? "예시",
                style: TextStyle(fontSize: 17),
              ),
            ),
          ),
          //우측의 음소거, tts기능 버튼
          Row(
            children: [
              //배경음악 음소거 끄고 키는 버튼
              IconButton(
                onPressed: () async {
                  if (_isMuted) {
                    //음소거 상태였는데  버튼 누른거면=> 소리키기
                    //재생중이던 플레이어가 있다면 소리 다시 켜야됨
                    if (_ParagraphItemState._currentlyPlaying != null) {
                      //이전에 재생중이던 음량으로 소리킨다
                      await _ParagraphItemState._currentlyPlaying!.setVolume(
                        _originalVolume,
                      );
                    }
                  } else {
                    //음소거 상태 아니였는데  버튼 누른거면=>음소거
                    //재생중이던 플레이어가 있다면 음소거
                    if (_ParagraphItemState._currentlyPlaying != null) {
                      //기존에 재생중이던 음량 정보 저장
                      _originalVolume =
                          _ParagraphItemState._currentlyPlaying?.volume ?? 1;
                      print("_originalVolume: ${_originalVolume}");
                      //음소거 실행
                      await _ParagraphItemState._currentlyPlaying!.setVolume(0);
                    }
                  }
                  //화면 업데이트
                  setState(() {
                    //음소거 여부 반전시킴
                    _isMuted = !_isMuted;
                  });
                },
                icon: _isMuted ? Icon(Icons.music_note) : Icon(Icons.music_off),
              ),
              SizedBox(width: 7.w),
              //TTS로 읽어주기 기능 버튼
              IconButton(onPressed: () {}, icon: Icon(Icons.record_voice_over)),
            ],
          ),
        ],
      ),
    );
  }
}

//단락들 쭉 나오게 하는 listView
Widget _buildParagraphsScreenUI(
  List<NovelParagraph> paragraphs,
  AudioPlayer _audioPlayer,
) {
  return ListView.builder(
    padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 10.h),
    itemCount: paragraphs.length,
    itemBuilder: (context, index) {
      return ParagraphItem(paragraph: paragraphs[index]);
    },
  );
}

//단락 하나하나에 해당하는 위젯
class ParagraphItem extends StatefulWidget {
  final NovelParagraph paragraph;

  const ParagraphItem({super.key, required this.paragraph});

  @override
  State<ParagraphItem> createState() => _ParagraphItemState();
}

class _ParagraphItemState extends State<ParagraphItem> {
  // 내 플레이어
  late final AudioPlayer _player;

  // static변수로 현재 재생중인 플레이어 정보 담는다
  // 모든 ParagraphItem 인스턴스에서 동일한 _currentlyPlaying변수에 접근 가능(static이기 때문)
  static AudioPlayer? _currentlyPlaying;

  @override
  void initState() {
    super.initState();
    _player = AudioPlayer();
  }

  @override
  void dispose() {
    //플레이어 해제 -> 음악 자동 중지 되긴 하는데... 화면에서 사라져도 displose되지 않는 것들이 있음
    _player.dispose();
    print("player dispose :${widget.paragraph.text.substring(0, 4)}");
    super.dispose();
  }

  //노래 재생시키는 함수
  Future<void> _playAudio() async {
    // 기존에 재생 중인 플레이어가 있고 재생중인게 내 플레이어가 아니라면 멈춤
    if (_currentlyPlaying != null && _currentlyPlaying != _player) {
      await _currentlyPlaying!.stop();
    }

    try {
      //url과 연결된 음악 재생 시도
      await _player.setUrl(widget.paragraph.music_url);
    } catch (e) {
      //url음악은 실패했다면
      print("Azure URL로 노래 재생 실패: $e");
      try {
        //default mp3재생되도록
        await _player.setAsset('assets/audio/default.mp3');
      } catch (err) {
        print("기본 오디오도 실패: $err");
        //아무노래도 재생하지 않는다
        return;
      }
    }

    //현재 재생중인 플레이어 정보(static)를 내 플레이어로 설정
    _currentlyPlaying = _player;
    _player.play();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            //누르면 노래 재생 버튼
            IconButton(
              icon: Icon(Icons.play_circle_fill_outlined),
              onPressed: _playAudio,
            ),
            //단락 내용(text) 보여준다
            Expanded(
              child: Text(
                widget.paragraph.music_url,
                overflow: TextOverflow.ellipsis,
              ),
            ),
          ],
        ),
        SizedBox(height: 8.h),
        Text(widget.paragraph.text),
        //구분선
        const Divider(),
      ],
    );
  }
}
