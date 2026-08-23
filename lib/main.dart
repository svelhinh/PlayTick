import 'package:flutter/material.dart';

void main() {
  runApp(const PlayTick());
}

class PlayTick extends StatelessWidget {
  const PlayTick({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(title: 'Play Tick', debugShowCheckedModeBanner: false);
  }
}
