class Config {
  final int initialSize;
  final int sizeMultiplier;
  final int maxLevel;
  final int fishCount;

  Config({
    required this.initialSize,
    required this.sizeMultiplier,
    required this.maxLevel,
    required this.fishCount,
  });

  factory Config.init() => Config(
        initialSize: 50,
        sizeMultiplier: 10,
        maxLevel: 5,
        fishCount: 10,
      );
}
