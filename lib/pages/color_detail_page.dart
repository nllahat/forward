

import 'package:flutter/material.dart';

class ColorDetailPage extends StatelessWidget {
  final MaterialColor color;
  final String title;
  final int materialIndex;
  ColorDetailPage({this.color, this.title, this.materialIndex: 500});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: color,
        title: Text(
          '$title[$materialIndex]',
        ),
      ),
      body: Container(
        // color: color[materialIndex],
      ),
    );
  }
}