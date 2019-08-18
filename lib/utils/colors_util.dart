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
      return Colors.white;
    }

    // Counting the perceptive luminance - human eye favors green color...
    double luminance = (0.299 * dominantColor.red +
            0.587 * dominantColor.green +
            0.114 * dominantColor.blue) /
        255;

    if (luminance > 0.5)
      return Colors.black; // bright colors - black font
    else
      return Colors.white; // dark colors - white font
  }
}
