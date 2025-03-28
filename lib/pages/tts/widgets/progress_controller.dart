import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:moodmonster/providers/audio.viewmodel.dart';

class ProgressController extends ConsumerWidget {
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final audioState = ref.watch(audioControllerProvider);
    
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Column(
        children: [
          SizedBox(
            width: double.infinity,
            height: 8,
            child: StreamBuilder(
              stream: audioState.audioPlayer.positionStream,
              builder: (context, snapshot) {
                double sliderValue = 0;
                final position = snapshot.data;
                final duration = audioState.audioPlayer.duration;

                if (snapshot.connectionState == ConnectionState.active &&
                    duration != null &&
                    position != null) {
                  sliderValue = max(0, min(1, position.inMilliseconds / duration.inMilliseconds));
                }

                return Slider(
                  value: sliderValue,
                  thumbColor: Color(0xFF00C73C),
                  onChanged: (_) {},
                  onChangeEnd: (value) => ref.read(audioControllerProvider.notifier).seekTo(value),
                );
              },
            ),
          ),
          SizedBox(height: 6),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 4),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(_formatDuration(audioState.audioPlayer.position), style: TextStyle(color: Colors.white),),
                Text("04:28", style: TextStyle(color: Colors.white),),
              ],
            ),
          ),
        ],
      ),
    );
  }

  String _formatDuration(Duration duration) {
    return '${duration.inMinutes.toString().padLeft(2, '0')}:${(duration.inSeconds % 60).toString().padLeft(2, '0')}';
  }
}
