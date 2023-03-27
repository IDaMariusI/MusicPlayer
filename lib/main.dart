import 'package:flutter/material.dart';

import 'package:provider/provider.dart';

import 'package:music_player/src/models/models.dart';
import 'package:music_player/src/pages/pages.dart';
import 'package:music_player/src/theme/theme.dart';

void main() => runApp(const MyApp());

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => AudioPlayerModel()),
      ],
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'Music Player',
        theme: myTheme,
        home: const MusicPlayerPage(),
      ),
    );
  }
}
