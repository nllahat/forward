import 'package:flutter/material.dart';
import 'package:palette_generator/palette_generator.dart';

class ColorsUtil {
  Future<Color> getTextColor(String imageUrl) async {
    PaletteGenerator paletteGenerator =
        await PaletteGenerator.fromImageProvider(
      NetworkImage(imageUrl),

      // Images are square
      size: Size(300, 300),

      // I want the dominant color of the top left section of the image
      region: Offset.zero & Size(40, 40),
    );

    Color dominantColor = paletteGenerator.dominantColor?.color;

    // Here's the problem
    // Sometimes dominantColor returns null
    // With black and white background colors in my tests
    if (dominantColor == null) {
      print('Dominant Color null');
      return Colors.white;
    }

    int d = 0;

// Counting the perceptive luminance - human eye favors green color...
    double luminance = (0.299 * dominantColor.red +
            0.587 * dominantColor.green +
            0.114 * dominantColor.blue) /
        255;

    if (luminance > 0.5)
      d = 0; // bright colors - black font
    else
      d = 255; // dark colors - white font

    return Color.fromARGB(dominantColor.alpha, d, d, d);
  }
}
