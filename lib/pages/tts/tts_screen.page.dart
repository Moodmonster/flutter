import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:moodmonster/config/routes/app_router.dart';
import 'package:moodmonster/pages/tts/widgets/custom_cover.dart';
import 'package:moodmonster/pages/tts/widgets/playback_controller.dart';
import 'package:moodmonster/pages/tts/widgets/progress_controller.dart';
import 'package:moodmonster/providers/audio.viewmodel.dart';

class TTSPage extends ConsumerStatefulWidget {
  const TTSPage({
    super.key,
  });

  @override
  ConsumerState<TTSPage> createState() => _TTSPageState();
}

class _TTSPageState extends ConsumerState<TTSPage> {
  @override
  Widget build(BuildContext context) {
    final ttsView = ref.watch(audioControllerProvider);
    final ttsController = ref.read(audioControllerProvider.notifier);

    return PopScope(
      onPopInvokedWithResult: (didPop, result) {
        ttsController.audioDispose();
      },
      child: Scaffold(
        body: Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: const [
                Color(0xFF000000),
                Color.fromARGB(255, 0, 105, 32),
                Color(0xFF00C73C),
              ],
              begin: Alignment.center,
              end: Alignment.bottomCenter,
              stops: const [0.4, 0.8, 1.0],
            ),
          ),
          child: SafeArea(
            child: Column(
              children: [
                Row(
                  children: [
                    IconButton(
                      onPressed: () {
                        AppRouter.pop();
                      }, 
                      icon: Icon(Icons.arrow_back_ios_new_rounded, color: Colors.grey,),
                    )
                  ],
                ),
                customCover(
                  title: ttsView.title,
                  coverImg: ttsView.coverImg,
                ),
                ProgressController(),
                SizedBox(height: 64.h),
                PlaybackController(
                  onPrevTap: () {
                    setState(() {
                      // if (currentAlbumIndex == 0) return;
                      // currentAlbumIndex = (currentAlbumIndex + 3) % 4;
    
                      // (() async {
                      //   try {
                      //     await audioProvider.reset();
    
                      //     await audioProvider.audioPlayer.setAudioSource(
                      //       AudioSource.uri(Uri.parse(ALBUM_LIST[currentAlbumIndex].audioPath)),
                      //     );
    
                      //     audioProvider.audioPlayer.playerStateStream
                      //         .listen((state) {
                      //       if (state.processingState ==
                      //           ProcessingState.completed) {
                      //         audioProvider.reset();
                      //       }
                      //     });
                      //   } catch (e) {}
                      // })();
                    });
                  },
                  onNextTap: () {
                    setState(() {
                      // if (currentAlbumIndex == 3) return;
                      // currentAlbumIndex = (currentAlbumIndex + 1) % 4;
                      // (() async {
                      //   try {
                      //     audioProvider.reset();
    
                      //     await audioProvider.audioPlayer.setAudioSource(
                      //       AudioSource.uri(Uri.parse(ALBUM_LIST[currentAlbumIndex].audioPath)),
                      //     );
    
                      //     audioProvider.audioPlayer.playerStateStream
                      //         .listen((state) {
                      //       if (state.processingState ==
                      //           ProcessingState.completed) {
                      //         audioProvider.reset();
                      //       }
                      //     });
                      //   } catch (e) {}
                      // })();
                    });
                  },
                ),
                SizedBox(height: 100.h),
              ],
            ),
          ),
        ),
      ),
    );
  }
}