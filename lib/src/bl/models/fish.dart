import 'package:flutter_aqua/src/bl/models/location.dart';

class Fish {
  final String id;
  final bool isVulturous;
  final int level;
  final int speed;
  Location location;
  int direction;

  Fish({
    required this.id,
    required this.isVulturous,
    required this.level,
    required this.speed,
    required this.location,
    required this.direction,
  });

  set setNewDirection(int newDirection) => direction = newDirection;

  set setNewLocation(Location newLocation) => location = newLocation;
}
