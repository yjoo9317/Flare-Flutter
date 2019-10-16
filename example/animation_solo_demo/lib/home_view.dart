import 'package:flutter/material.dart';
import 'dragon_controller.dart';
import 'package:flare_flutter/flare_actor.dart';

class HomeView extends StatefulWidget {
  @override
  HomeViewState createState() => HomeViewState();
}

class HomeViewState extends State<HomeView> {
  ///controller to our dragon that will modify the animation and solo node
  DragonController _dragonController;

  ///this corresponds to the solo nodes in the Flare project under 'Food_Solo'
  int foodIndex = 1;

  void initState() {
    ///declare this here
    _dragonController = DragonController();

    super.initState();
  }

  ///MAGIC HERE: set the animation we want to play after we set the active
  ///solo index on our solo node.  Increment each time so it loops through
  void _didTap(){

    _dragonController.setSolo("Food_Solo", foodIndex);
    _dragonController.play("eat");

    foodIndex++;
    if(foodIndex > 3){
      foodIndex = 1;
    }
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Colors.transparent,
        body: Center(
            child: Stack(
                children: <Widget>[
                  ///initialize our dragon with our controller
                  FlareActor(
                    "assets/Dragon.flr",
                    controller: _dragonController,
                    animation: "idle",
                    fit: BoxFit.cover,
                    artboard: "Scene",
                  ),
                  ///simple button to change the animation and the solo nodes
                  RawMaterialButton(
                    constraints: BoxConstraints.tight(
                      Size(MediaQuery.of(context).size.width,
                          MediaQuery.of(context).size.height),
                    ),
                    onPressed: _didTap,
                    shape: Border(),
                    highlightColor: Colors.white,
                    splashColor: Colors.white,
                    elevation: 0.0,
                    child: Text("TAP!",style:
                    TextStyle(
                        fontFamily: 'Mario', color: Colors.white, fontSize: 30),
                    ),
                  )
                ]
            )
        )
    );
  }
}