import 'dart:ui';

class Location {
  final double x;
  final double y;

  Location({required this.x, required this.y});

  bool isScreenTouched(
          {required Size maxSize,
          Size minSize = const Size(0, 0),
          required double hitBox}) =>
      (x >= (maxSize.width - hitBox) || x <= minSize.width) ||
      (y >= (maxSize.height - hitBox) || y <= minSize.height);
}
