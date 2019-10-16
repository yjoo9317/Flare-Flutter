import 'package:flutter/material.dart';
import 'package:flare_flutter/flare_controls.dart';
import 'flare_button.dart';

class HomeView extends StatefulWidget {

  @override
  HomeViewState createState() => HomeViewState();
}

class HomeViewState extends State<HomeView> {

  ///Flare controls allow us to play different animations on the artboard we
  ///assign it to
  FlareControls _flareControls = FlareControls();

  void initState() {

    ///in 5 seconds, we'll show the Dialog
    Future.delayed(Duration(seconds: 5),() {
      showPopUp();
    });

    super.initState();
  }

  void showPopUp(){
    showDialog(
      context: context,
      builder: (BuildContext context) => _notEnoughCoinsDialog(context),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Colors.transparent,
        body: Center(
            child: Stack(
                children:<Widget>[
                  Center(
                    child:Image.asset( "blur_bg.png",
                        fit:BoxFit.cover,
                        width: MediaQuery.of(context).size.width * 1.1),
                  ),
                ]
            )
        )
    );
  }

  Widget _notEnoughCoinsDialog(BuildContext context) {

    return Container(
      height: MediaQuery.of(context).size.height,
      width: MediaQuery.of(context).size.width* .5,
      child:
      Center(
        child:
          FlareButton(
            actorString: "assets/DragonApp.flr",
            artboardString: "NotEnoughCoinsPopUp",
            animation: "not_enough_pop",
            buttonSizes: [Offset(130, 65)],
            nodeNames: ["ok_button_node"],
            onPressed:[_remove],
            btnAnimName: [""],
          ),
      ),
    );
  }

  void _remove(){
    ///play the reverse animation
    _flareControls.play("not_enough_pop_Rev");

    ///when the reverse animation is complete, remove the widget
    Future.delayed(Duration(milliseconds: 750),() {
      Navigator.of(context).pop();
    });

    ///start the whole loop over again
    Future.delayed(Duration(seconds: 5),() {
      showPopUp();
    });
  }
}
