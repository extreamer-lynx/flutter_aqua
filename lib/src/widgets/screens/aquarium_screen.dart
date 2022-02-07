import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_aqua/src/bl/models/config.dart';
import 'package:flutter_aqua/src/bl/models/fish.dart';
import 'package:flutter_aqua/src/bl/services/timer_helper.dart';
import 'package:provider/provider.dart';
import 'package:flutter_aqua/src/bl/bloc/fish_generator_bloc.dart';
import 'package:flutter_aqua/src/widgets/components/fish_component.dart';

class AquariumScreen extends StatefulWidget {
  const AquariumScreen({Key? key}) : super(key: key);

  @override
  _AquariumScreenState createState() => _AquariumScreenState();
}

class _AquariumScreenState extends State<AquariumScreen> {
  final StreamController<List<Fish>> _aquariumController = StreamController();
  late Config config;
  late final FishGeneratorBloc _fishGeneratorBloc;
  late final StreamSubscription _fishGeneratorSubscription;

  List<Fish> aquarium = [];

  @override
  void initState() {
    config = context.read<Config>();
    _fishGeneratorBloc = FishGeneratorBloc(config: config);

    _fishGeneratorSubscription =
        _fishGeneratorBloc.fishGenerator.listen((fishList) {
      for (var newFish in fishList) {
        aquarium.add(newFish);
      }
      _aquariumController.add(aquarium);
    });
    super.initState();
  }

  @override
  void dispose() {
    _fishGeneratorSubscription.cancel();
    _fishGeneratorBloc.dispose();
    _aquariumController.close();
    super.dispose();
  }

  @override
  Widget build(_) => Scaffold(
        body: SafeArea(
          child: LayoutBuilder(builder: (context, boxConstraints) {
            if (aquarium.isEmpty) {
              _fishGeneratorBloc.generateFish(
                  config.fishCount, boxConstraints.biggest);
            }

            return MultiProvider(
              providers: [
                Provider(create: (_) => boxConstraints.biggest),
                Provider(create: (_) => aquarium),
              ],
              child: StreamBuilder<List<Fish>>(
                  stream: _aquariumController.stream,
                  builder: (context, snapshot) {
                    if (!snapshot.hasData) {
                      return Container();
                    }

                    return Stack(
                      children: snapshot.data!
                          .map(
                            (fishList) => FishComponent(
                              key: Key(fishList.id),
                              fishId: fishList.id,
                              killFishCallback: (Fish fish) {
                                _aquariumController.add(aquarium
                                    .where((element) => element.id != fish.id)
                                    .toList());
                                aquarium.remove(fish);
                                TimerHelper().seconds(60).listen((seconds) {
                                  if(seconds == 0) {
                                    _fishGeneratorBloc.generateFish(1, boxConstraints.biggest);
                                  }
                                });
                              },
                            ),
                          )
                          .toList(),
                    );
                  }),
            );
          }),
        ),
      );
}
