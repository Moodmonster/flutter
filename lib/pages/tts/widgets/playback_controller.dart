import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:moodmonster/providers/audio.viewmodel.dart';

class PlaybackController extends ConsumerWidget {
  final void Function() onPrevTap;
  final void Function() onNextTap;

  const PlaybackController({
    super.key,
    required this.onPrevTap,
    required this.onNextTap,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final audioState = ref.watch(audioControllerProvider);
    final audioController = ref.read(audioControllerProvider.notifier);

    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.end,
      children: [
        InkWell(
          onTap: onPrevTap,
          child: Container(
            padding: EdgeInsets.all(18),
            decoration: BoxDecoration(
              color: Color(0xFF141927),
              borderRadius: BorderRadius.circular(999),
            ),
            child: Icon(Icons.skip_previous, size: 24, color: Colors.white),
          ),
        ),
        SizedBox(width: 32),
        InkWell(
          onTap: () => audioController.togglePlayPause(),
          child: Container(
            padding: EdgeInsets.all(18),
            decoration: BoxDecoration(
              color: Color(0xFF141927),
              borderRadius: BorderRadius.circular(999),
            ),
            child: Icon(
              audioState.isPlaying ? Icons.pause : Icons.play_arrow,
              size: 60,
              color: Colors.white,
            ),
          ),
        ),
        SizedBox(width: 32),
        InkWell(
          onTap: onNextTap,
          child: Container(
            padding: EdgeInsets.all(18),
            decoration: BoxDecoration(
              color: Color(0xFF141927),
              shape: BoxShape.circle
            ),
            child: Icon(Icons.skip_next, size: 24, color: Colors.white),
          ),
        ),
      ],
    );
  }
}