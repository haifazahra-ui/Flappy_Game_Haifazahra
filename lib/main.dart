import 'dart:convert';

import 'package:flame/game.dart';
import 'package:flutter/material.dart';
import 'package:flutter_client/flappy_game.dart';
import 'package:web_socket_channel/web_socket_channel.dart';

void main() => runApp(GameWidget(game: FlappyGame()));

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Game PPLG 2',
      theme: ThemeData(colorScheme: .fromSeed(seedColor: Colors.deepPurple)),
      home: const MyHomePage(),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key});

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  final channel = WebSocketChannel.connect(
    Uri.parse('ws://192.168.220.176:8080'),
  );

  Map players = {};

  @override
  void initState() {
    super.initState();
    channel.stream.listen((data) {
      final msg = jsonDecode(data);
      if (msg['type'] == 'state') {
        setState(() {
          players = msg['players'];
        });
      }
    });
  }

  void move(double dx, double dy) {
    channel.sink.add(jsonEncode({'type': 'move', 'dx': dx, 'dy': dy}));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: Text("Game PPLG 2"),
      ),
      body: Stack(
        children: players.values.map((p) {
          return Positioned(
            left: p['x'].toDouble(),
            top: p['y'].toDouble(),
            child: Container(
              width: 20.0,
              height: 20.0,
              decoration: const BoxDecoration(
                color: Colors.blue,
                shape: BoxShape.circle,
              ),
            ),
          );
        }).toList(),
      ),
      floatingActionButton: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          IconButton(
            onPressed: () {
              move(0, -5);
            },
            icon: const Icon(Icons.arrow_upward),
          ),
          IconButton(
            onPressed: () {
              move(0, 5);
            },
            icon: const Icon(Icons.arrow_downward),
          ),
          IconButton(
            onPressed: () {
              move(-5, 0);
            },
            icon: const Icon(Icons.arrow_back),
          ),
          IconButton(
            onPressed: () {
              move(5, 0);
            },
            icon: const Icon(Icons.arrow_forward),
          ),
        ],
      ),
    );
  }
}