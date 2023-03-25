import 'package:flutter/material.dart';

import 'package:music_player/src/widgets/widgets.dart';

class MusicPlayerPage extends StatelessWidget {
  const MusicPlayerPage({super.key});

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: Column(children: [
        CustomAppBar(),
      ],),
    );
  }
}
