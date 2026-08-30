import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/material.dart';

import '../../../utility/colors_data.dart';

class AudioPlayerWidget extends StatefulWidget {
  final String audioUrl;

  AudioPlayerWidget({required this.audioUrl});

  @override
  _AudioPlayerWidgetState createState() => _AudioPlayerWidgetState();
}

class _AudioPlayerWidgetState extends State<AudioPlayerWidget> {
  late AudioPlayer _audioPlayer;
  double _currentPosition = 0.0;
  double _duration =
      1.0; // Initialize with a non-zero value to prevent division by zero

  @override
  void initState() {
    super.initState();
    _audioPlayer = AudioPlayer();

    _audioPlayer.onDurationChanged.listen((duration) {
      setState(() {
        _duration = duration.inMilliseconds.toDouble();
      });
    });
    _audioPlayer.onPositionChanged.listen((position) {
      setState(() {
        _currentPosition = position.inMilliseconds.toDouble();
      });
    });
  }

  @override
  void dispose() {
    _audioPlayer.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        // Indication bar (progress slider)
        Slider(
          value: _currentPosition,
          onChanged: (value) {
            final duration = Duration(milliseconds: value.round());
            _audioPlayer.seek(duration);
          },
          max: _duration,
        ),
        // Play and pause buttons
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            IconButton(
              color: ColorsData.themeColor,
              icon: const Icon(Icons.play_arrow),
              onPressed: () async {
                await _audioPlayer.play(UrlSource(widget.audioUrl));
              },
            ),
            IconButton(
              color: ColorsData.themeColor,
              icon: const Icon(Icons.pause),
              onPressed: () async {
                await _audioPlayer.pause();
              },
            ),
          ],
        ),
      ],
    );
  }
}
