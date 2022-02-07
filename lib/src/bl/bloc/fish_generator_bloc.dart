import 'dart:async';
import 'dart:math';
import 'dart:ui';

import 'package:flutter_aqua/src/bl/models/config.dart';
import 'package:flutter_aqua/src/bl/models/fish.dart';
import 'package:flutter_aqua/src/bl/models/location.dart';
import 'package:uuid/uuid.dart';

class FishGeneratorBloc {
  final Config config;
  final StreamController<List<Fish>> _fishGeneratorController =
      StreamController();

  FishGeneratorBloc({required this.config});

  Stream<List<Fish>> get fishGenerator => _fishGeneratorController.stream;

  void generateFish(int count, Size screenSize) {
    List<Fish> fishList = [];
    for (int fish = 0; fish <= count; fish++) {
      final randomNumberGenerator = Random();
      final level = randomNumberGenerator.nextInt(config.maxLevel - 1);

      fishList.add(
        Fish(
            id: const Uuid().v1(),
            direction: randomNumberGenerator.nextInt(360),
            location: Location(
              x: _doubleInRange(
                  source: randomNumberGenerator,
                  start: config.initialSize + (config.sizeMultiplier * level),
                  end: screenSize.width),
              y: _doubleInRange(
                  source: randomNumberGenerator,
                  start: config.initialSize + (config.sizeMultiplier * level),
                  end: screenSize.height),
            ),
            isVulturous: randomNumberGenerator.nextBool(),
            level: level + 1,
            speed: List<int>.generate(config.maxLevel, (index) => index + 1)
                .reversed
                .toList()[level]),
      );
    }

    _fishGeneratorController.add(fishList);
  }

  double _doubleInRange(
          {required Random source, num start = 0, required num end}) =>
      source.nextDouble() * (end - start) + start;

  void dispose() {
    _fishGeneratorController.close();
  }
}
