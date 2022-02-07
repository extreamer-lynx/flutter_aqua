import 'dart:ui';

import 'package:flutter_aqua/src/bl/models/fish.dart';
import 'package:flutter_aqua/src/bl/models/location.dart';

class ColisionService {
  final Size screenSize;
  final double hitBox;
  final Size minSize;

  ColisionService(
      {required this.screenSize,
      required this.hitBox,
      this.minSize = const Size(0, 0)});

  // TODO: Need to use bloc
  List<Fish> colideCheck(
          Location fishLocation, List<Fish> listLocation) =>
      listLocation
          .where((fishList) => fishList.location != fishLocation)
          .where((fishList) =>
              fishLocation.x <= fishList.location.x &&
              fishLocation.x + hitBox >= fishList.location.x)
          .where((fishList) =>
              fishLocation.y <= fishList.location.y &&
              fishLocation.y + hitBox >= fishList.location.y)
          .toList();
}
