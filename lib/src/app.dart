import 'package:flutter/material.dart';
import 'package:flutter_aqua/src/bl/models/config.dart';
import 'package:flutter_aqua/src/widgets/screens/aquarium_screen.dart';
import 'package:provider/provider.dart';

class App extends StatelessWidget {
  const App({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) => Provider<Config>(
        create: (_) => Config.init(),
        child: MaterialApp(
          debugShowCheckedModeBanner: false,
          title: 'Flutter Demo',
          theme: ThemeData(
            primarySwatch: Colors.blue,
            cardTheme: const CardTheme(
              color: Colors.blue,
              shadowColor: Colors.red,
            ),
          ),
          home: const AquariumScreen(),
        ),
      );
}
