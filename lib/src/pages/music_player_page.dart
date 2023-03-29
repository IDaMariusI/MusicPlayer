import 'package:flutter/material.dart';

import 'package:animate_do/animate_do.dart';
import 'package:assets_audio_player/assets_audio_player.dart';
import 'package:provider/provider.dart';

import 'package:music_player/src/helpers/helpers.dart';
import 'package:music_player/src/models/models.dart';
import 'package:music_player/src/widgets/widgets.dart';

class MusicPlayerPage extends StatelessWidget {
  const MusicPlayerPage({super.key});

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: Stack(
        children: [
          Background(),
          Column(
            children: [
              CustomAppBar(),
              ImageDiscDuration(),
              PlayingTitle(),
              Expanded(
                child: Lyrics(),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class Background extends StatelessWidget {
  const Background({super.key});

  @override
  Widget build(BuildContext context) {
    final screenSize = MediaQuery.of(context).size;

    return Container(
      height: screenSize.height * 0.8,
      width: double.infinity,
      decoration: const BoxDecoration(
        borderRadius: BorderRadius.only(bottomLeft: Radius.circular(60)),
        gradient: LinearGradient(
          begin: Alignment.centerLeft,
          end: Alignment.center,
          colors: [
            Color(0xff33333E),
            Color(0xff201E28),
          ],
        ),
      ),
    );
  }
}

class ImageDiscDuration extends StatelessWidget {
  const ImageDiscDuration({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(top: 70),
      padding: const EdgeInsets.symmetric(horizontal: 22),
      child: Row(
        children: [
          _DiscImage(),
          const SizedBox(width: 40),
          _ProgressBar(),
          const SizedBox(width: 20),
        ],
      ),
    );
  }
}

class _DiscImage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final audioPlayModel = Provider.of<AudioPlayerModel>(context);

    return Container(
      height: 250,
      padding: const EdgeInsets.all(20),
      width: 250,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(200),
        gradient: const LinearGradient(
          begin: Alignment.topLeft,
          colors: [
            Color(0xff484750),
            Color(0xff1E1C24),
          ],
        ),
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(200),
        child: Stack(
          alignment: Alignment.center,
          children: [
            SpinPerfect(
              duration: const Duration(seconds: 10),
              infinite: true,
              manualTrigger: true,
              controller: (animationController) =>
                  audioPlayModel.controller = animationController,
              child: const Image(image: AssetImage('assets/aurora.jpg')),
            ),
            Container(
              height: 25,
              width: 25,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(100),
                color: Colors.black38,
              ),
            ),
            Container(
              height: 18,
              width: 18,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(100),
                color: const Color(0xff1C1C25),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _ProgressBar extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final style = TextStyle(color: Colors.white.withOpacity(0.4));

    final audioPlayerModel = Provider.of<AudioPlayerModel>(context);
    final percentage = audioPlayerModel.percentage;

    return Column(
      children: [
        Text(audioPlayerModel.songTotalDuration, style: style),
        const SizedBox(height: 10),
        Stack(
          children: [
            Container(
              height: 230,
              width: 3,
              color: Colors.white.withOpacity(0.1),
            ),
            Positioned(
              bottom: 0,
              child: Container(
                height: 230 * percentage,
                width: 3,
                color: Colors.white.withOpacity(0.8),
              ),
            ),
          ],
        ),
        const SizedBox(height: 10),
        Text(audioPlayerModel.currentSecond, style: style),
      ],
    );
  }
}

class PlayingTitle extends StatefulWidget {
  const PlayingTitle({super.key});

  @override
  State<PlayingTitle> createState() => _PlayingTitleState();
}

class _PlayingTitleState extends State<PlayingTitle>
    with SingleTickerProviderStateMixin {
  bool isPlaying = false;
  bool firstTime = true;
  final assetAudioPlayer = AssetsAudioPlayer();
  late AnimationController playAnimation;

  @override
  void initState() {
    playAnimation = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 500),
    );
    super.initState();
  }

  @override
  void dispose() {
    playAnimation.dispose();
    super.dispose();
  }

  void open() {
    final audioPlayerModel =
        Provider.of<AudioPlayerModel>(context, listen: false);

    assetAudioPlayer.open(
      autoStart: true,
      Audio('assets/Breaking-Benjamin-Far-Away.mp3'),
      showNotification: true,
    );

    assetAudioPlayer.currentPosition.listen((duration) {
      audioPlayerModel.current = duration;
    });

    assetAudioPlayer.current.listen((playingAudio) {
      audioPlayerModel.songDuration =
          playingAudio?.audio.duration ?? const Duration(seconds: 0);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(top: 40),
      padding: const EdgeInsets.symmetric(horizontal: 50),
      child: Row(
        children: [
          Column(
            children: [
              Text(
                'Far away',
                style: TextStyle(
                  color: Colors.white.withOpacity(0.8),
                  fontSize: 30,
                ),
              ),
              Text(
                '-Breaking Benjamin-',
                style: TextStyle(
                  color: Colors.white.withOpacity(0.5),
                  fontSize: 15,
                ),
              ),
            ],
          ),
          const Spacer(),
          FloatingActionButton(
            backgroundColor: const Color(0xffF8CB51),
            elevation: 0,
            highlightElevation: 0,
            onPressed: () {
              final audioPlayerModel = Provider.of<AudioPlayerModel>(
                context,
                listen: false,
              );

              if (isPlaying) {
                isPlaying = false;
                playAnimation.reverse();
                audioPlayerModel.controller.stop();
              } else {
                isPlaying = true;
                playAnimation.forward();
                audioPlayerModel.controller.repeat();
              }

              if (firstTime) {
                open();
                firstTime = false;
              } else {
                assetAudioPlayer.playOrPause();
              }
            },
            child: AnimatedIcon(
              icon: AnimatedIcons.play_pause,
              progress: playAnimation,
            ),
          ),
        ],
      ),
    );
  }
}

class Lyrics extends StatelessWidget {
  const Lyrics({super.key});

  @override
  Widget build(BuildContext context) {
    final lyrics = getLyrics();

    return ListWheelScrollView(
      diameterRatio: 1.5,
      itemExtent: 42,
      physics: const BouncingScrollPhysics(),
      children: lyrics
          .map((line) => Text(
                line,
                style: TextStyle(
                  fontSize: 20,
                  color: Colors.white.withOpacity(0.6),
                ),
              ))
          .toList(),
    );
  }
}
