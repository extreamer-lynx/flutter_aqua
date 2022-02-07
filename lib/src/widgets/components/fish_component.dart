import 'package:flutter/material.dart';
import 'package:flutter_aqua/src/bl/bloc/fish_direction_bloc.dart';
import 'package:flutter_aqua/src/bl/bloc/fish_location_bloc.dart';
import 'package:flutter_aqua/src/bl/models/config.dart';
import 'package:flutter_aqua/src/bl/models/fish.dart';
import 'package:flutter_aqua/src/bl/models/location.dart';
import 'package:flutter_aqua/src/bl/services/colision_service.dart';
import 'package:provider/provider.dart';

class FishComponent extends StatefulWidget {
  final String fishId;
  final void Function(Fish fish) killFishCallback;

  const FishComponent(
      {Key? key, required this.fishId, required this.killFishCallback})
      : super(key: key);

  @override
  _FishComponentState createState() => _FishComponentState();
}

class _FishComponentState extends State<FishComponent> {
  late final Config _config;
  late final Size _screenSize;
  late final ColisionService _colisionService;
  late final FishLocationBloc _fishLocationBloc;
  late final FishDirectionBloc _fishDirectionBloc;

  @override
  void initState() {
    _config = context.read<Config>();
    _screenSize = context.read<Size>();

    _colisionService =
        ColisionService(screenSize: _screenSize, hitBox: fishSize);

    _fishLocationBloc = FishLocationBloc(
      screenSize: _screenSize,
      initLocation: getFish.location,
      hitBox: fishSize,
    );

    _fishDirectionBloc = FishDirectionBloc(
      maxSize: _screenSize,
      initDirection: getFish.direction,
      hitBox: fishSize,
    );

    super.initState();
  }

  Fish get getFish => context
      .read<List<Fish>>()
      .where((avaibleFish) => avaibleFish.id == widget.fishId)
      .first;

  @override
  void dispose() {
    _fishLocationBloc.dispose();
    _fishDirectionBloc.dispose();

    super.dispose();
  }

  double get fishSize =>
      (_config.initialSize + (_config.sizeMultiplier * getFish.level))
          .toDouble();

  @override
  Widget build(BuildContext context) => StreamBuilder<Location>(
      stream: _fishLocationBloc.fishLocation,
      builder: (context, locationSnapshot) {
        if (!locationSnapshot.hasData) {
          return Container();
        }

        _fishLocationBloc.changeLocation(
            getFish.speed, getFish.direction, locationSnapshot.data!);

        if (locationSnapshot.data!
                .isScreenTouchedY(maxSize: _screenSize, hitBox: fishSize) ||
            locationSnapshot.data!
                .isScreenTouchedX(maxSize: _screenSize, hitBox: fishSize)) {
          _fishDirectionBloc.getNewRadius(locationSnapshot.data!);
        }

        getFish.location = locationSnapshot.data!;

        final fishColideList = _colisionService.colideCheck(
            getFish.location, context.read<List<Fish>>());

        if (fishColideList.isNotEmpty) {
          for (var fishColide in fishColideList) {
            if (fishColide.isVulturous &&
                (fishColide.level > getFish.level + 1 ||
                    (fishColide.level >= getFish.level &&
                        !getFish.isVulturous))) {
              widget.killFishCallback(getFish);
              
              return Container();
            }
          }
        }

        return AnimatedPositioned(
          left: getFish.location.x,
          top: getFish.location.y,
          width: fishSize,
          height: fishSize,
          duration: const Duration(milliseconds: 300),
          child: StreamBuilder<int>(
              stream: _fishDirectionBloc.fishDirection,
              builder: (context, directionSnapshot) {
                if (!directionSnapshot.hasData) {
                  return Container();
                }

                getFish.direction = directionSnapshot.data!;

                return AnimatedRotation(
                  turns: (getFish.direction / 360),
                  duration: const Duration(microseconds: 500),
                  child: SizedBox(
                    child: Image.asset(
                      'assets/fish/' +
                          (getFish.isVulturous
                              ? 'red-fish.png'
                              : 'blue-fish.png'),
                    ),
                  ),
                );
              }),
        );
      });
}
