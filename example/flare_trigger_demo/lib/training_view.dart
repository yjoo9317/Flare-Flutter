import 'package:flutter/material.dart';
///make sure you update your pubspec.yaml!
import 'package:flare_flutter/flare_actor.dart';
import 'dragon_controller.dart';

class TrainingScene extends StatefulWidget {
  @override
  TrainingSceneState createState() => TrainingSceneState();
}

class TrainingSceneState extends State<TrainingScene> {
  ///Step 1/3
  DragonController _dragonController;

  void initState() {
    ///Step 2/3
    _dragonController = DragonController();

    super.initState();
  }

  ///on play, let's play thru the fight animation and trigger our event!
  void play(){
    _dragonController.play("fight_bar");

  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: Center(
        child: Stack(
            children: <Widget>[
              ///Set up our basic Flare Actor inside a button
              RawMaterialButton(
                constraints: BoxConstraints.tight(const Size(550, 550)),
                onPressed: play,
                shape: Border(),
                highlightColor: Colors.transparent,
                splashColor: Colors.transparent,
                elevation: 0.0,
                child: FlareActor("assets/DragonApp.flr",
                    ///Step 3/3
                    controller: _dragonController,
                    fit: BoxFit.contain,
                    animation: "enter",
                    artboard: "FightTrainingDemo"),
              ),

            ]
        ),
      ),
    );
  }
}