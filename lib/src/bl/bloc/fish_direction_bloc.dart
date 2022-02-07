import 'dart:async';
import 'dart:math';

import 'dart:ui';

import 'package:flutter_aqua/src/bl/models/location.dart';

class FishDirectionBloc {
  final Size maxSize;
  final Size minSize;
  final double hitBox;

  late final StreamController<int> _fishDirectionController;

  FishDirectionBloc({
    required this.maxSize,
    required int initDirection,
    required this.hitBox,
    this.minSize = const Size(0, 0),
  }) {
    _fishDirectionController = StreamController()..add(initDirection);
  }

  Stream<int> get fishDirection => _fishDirectionController.stream;

  void getNewRadius(Location location) {
    final randomNumberGenerator = Random(DateTime.now().microsecond);

    if (minSize.width >= location.x) {
      return _fishDirectionController.add(randomNumberGenerator.nextBool()
          ? randomNumberGenerator.nextInt(90)
          : randomNumberGenerator.nextInt(270 - 180));
    }

    if (location.x >= (maxSize.width - hitBox) &&
        !location.isScreenTouchedY(maxSize: maxSize, hitBox: hitBox)) {
      return _fishDirectionController
          .add(randomNumberGenerator.nextInt(180) + 90);
    }

    if (maxSize.height - hitBox <= location.y) {
      return _fishDirectionController
          .add(randomNumberGenerator.nextInt(260) + 180);
    }

    return _fishDirectionController.add(randomNumberGenerator.nextInt(180));
  }

  void dispose() {
    _fishDirectionController.close();
  }
}
