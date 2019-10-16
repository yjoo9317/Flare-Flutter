import 'package:flutter/material.dart';
import 'flare_solo_button.dart';

class OptionsView extends StatefulWidget {
  @override
  OptionsViewState createState() => OptionsViewState();
}

class OptionsViewState extends State<OptionsView> {
  ///this corresponds to the images in the solo node in our Flare project
  final List<int> _soloList = <int>[1, 2, 3, 4];

  ///our button event, can be broken down based on index
  void _pressedInteractions(int idx) {
    print("pressed: $idx");
  }

  ///Our widget, with a background image, a text obj for our title, then a
  ///ListView of our solo nodes to create our button array
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Colors.transparent,
        body: Center(
            child: Stack(
                children:<Widget>[
                  Center( child: Image.asset( "blur_bg.png",
                    fit:BoxFit.cover),
                  ),
                  Column(
                      children: [
                        SizedBox(
                            height:
                            MediaQuery.of(context).size.height*.1),
                        Align(
                            alignment: Alignment.centerLeft,
                            child:
                            Container(
                              child:
                              Text(" Items ", style:
                              TextStyle(
                                  fontFamily: 'Mario',
                                  color: Colors.white,
                                  fontSize: 30)
                              ),
                            )
                        ),
                      ]),
                  Container(
                    padding: EdgeInsets.only(
                      left: MediaQuery.of(context).size.width* .03,
                    ),
                    height: MediaQuery.of(context).size.height* .5,
                    width: MediaQuery.of(context).size.width* .97,
                    child: ListView.builder(
                      itemCount: _soloList.length,
                      scrollDirection: Axis.horizontal,
                      itemBuilder: (BuildContext context, int index){
                        return Center(
                          ///Our new Flare Button!
                          child: new FlareSoloButton(
                              flareFile: "assets/DragonApp.flr",
                              btnSize: Offset(150, 400),
                              artboardString: "Items",
                              soloIndex: _soloList[index],
                              pressAnimation: "item_select",
                              soloName: "Solo",
                              onPressed:(){
                                _pressedInteractions(_soloList[index]);
                              }
                          ),
                        );
                      },
                    ),
                  ),
                ]
            )
        )
    );
  }
}