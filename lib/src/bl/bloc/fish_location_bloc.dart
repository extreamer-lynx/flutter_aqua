import 'dart:async';
import 'dart:math';
import 'dart:ui';

import 'package:flutter_aqua/src/bl/models/location.dart';

class FishLocationBloc {
  final Size screenSize;
  final double hitBox;

  late final StreamController<Location> _fishLocationController;

  FishLocationBloc({
    required this.screenSize,
    required Location initLocation,
    required this.hitBox,
  }) {
    _fishLocationController = StreamController()..add(initLocation);
  }

  Stream<Location> get fishLocation => _fishLocationController.stream;

  void changeLocation(int speed, int direction, Location oldLocation) {
    _fishLocationController.add(
      Location(
        x: oldLocation.x <= screenSize.width - hitBox
            ? getNewCoordinateX(oldLocation.x, speed, direction)
            : screenSize.width - hitBox - 5,
        y: oldLocation.y <= screenSize.height - hitBox
            ? getNewCoordinateY(oldLocation.y, speed, direction)
            : screenSize.height - hitBox - 5,
      ),
    );
  }

  double getNewCoordinateX(double num, int radius, int angle) =>
      (num + (radius * cos(angle * (pi / 180))));

  double getNewCoordinateY(double num, int radius, int angle) =>
      (num + (radius * sin(angle * (pi / 180))));

  void dispose() {
    _fishLocationController.close();
  }
}
