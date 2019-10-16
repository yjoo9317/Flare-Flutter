import 'package:flutter/material.dart';
import 'package:flare_flutter/flare_actor.dart';
import 'package:flare_flutter/flare_controller.dart';
import 'package:flare_flutter/flare.dart';
import 'package:flare_dart/math/mat2d.dart';
import 'dart:math';

class FlareButton extends StatefulWidget {
  FlareButton(
      {Key key, this.actorString, this.artboardString, this.animation, this
          .buttonSizes, this.nodeNames, this
          .onPressed, this.btnAnimName})
      : super(key: key);

  final List<Offset> buttonSizes;
  final List<VoidCallback> onPressed;
  final String actorString;
  final String artboardString;
  final String animation;
  final List<String> nodeNames;
  final List<String> btnAnimName;

  int fillIndex = 0;
  int soloInt;
  String soloName;


  _FlareButtonState myAppState = new _FlareButtonState();
  @override
  _FlareButtonState createState() => myAppState;

}

class _FlareButtonState extends State<FlareButton> with FlareController{

  double width = 0.0;
  double height = 0.0;

  List<Offset> position = [Offset(0.0, 0.0)];
  List<Offset> newPosition = [Offset(0.0, 0.0)];

  FlutterActorArtboard _artboard;
  final List<FlareAnimationLayer> _baseAnimations = [];


  @override
  void initialize(FlutterActorArtboard artboard) {

    _artboard = artboard;

  }

  @override
  void setViewTransform(Mat2D viewTransform) {
  }


  @override
  bool advance(FlutterActorArtboard artboard, double elapsed) {

    for(int i = 0; i < widget.nodeNames.length; i ++) {

      double percentX = this
          .getNode(widget.nodeNames[i])
          .worldTransform[4] / artboard.width;

      double percentY = this
          .getNode(widget.nodeNames[i])
          .worldTransform[5] / artboard.height;

      newPosition[i] = Offset(
          (width * percentX) - (widget.buttonSizes[i].dx / 2),
          (height * percentY) - (widget.buttonSizes[i].dy / 2));

      if (position[i] != newPosition[i]) {
        position[i] = newPosition[i];
        _updateBtn(artboard);

      }
    }
    int len = _baseAnimations.length - 1;
    for (int i = len; i >= 0; i--) {
      FlareAnimationLayer layer = _baseAnimations[i];
      layer.time += elapsed;
      layer.mix = min(1.0, layer.time / 0.01);
      layer.apply(_artboard);

      if (layer.isDone) {
        _baseAnimations.removeAt(i);
      }
    }
    return true;
  }
  //this just updates the btns pos
  _updateBtn(FlutterActorArtboard artboard){
    setState((){});
  }
  ActorNode getNode(String myNode){
    return _artboard.getNode(myNode);
  }
  void playAnimation(String animName) {
    if(_artboard != null){
      ActorAnimation animation = _artboard.getAnimation(animName);

      if (animation != null) {
        _baseAnimations.add(FlareAnimationLayer()
          ..name = animName
          ..animation = animation);
      }
    }

  }

  _didTapHere(int idx){
    //which button was pressed (if the artboard has many buttons)
    widget.onPressed[idx]?.call();

    if(widget.btnAnimName[idx].length != null){
      //play the pressed animation, if one was set
      playAnimation(widget.btnAnimName[idx]);
    }

  }
  @override
  Widget build(BuildContext context) {
    final RenderBox box = context.findRenderObject();
    //set the w/h to the widget's size, not the device screen size
    if(box != null){
      width = box.size.width;
      height = box.size.height;
    }

    return Stack(
      children: <Widget>[
        new FlareActor(widget.actorString,
          controller: this,
          fit: BoxFit.contain,
          animation: widget.animation,
          artboard: widget.artboardString,
        ),
        Stack(
            children: <Widget>[
        for(int i = 0; i < widget.nodeNames.length; i ++)
        Positioned(
          left: position[i].dx,
          top: position[i].dy,
          child: new GestureDetector(
            onTap: () => _didTapHere(i),
            child: Container(width: widget.buttonSizes[i].dx, height: widget
                .buttonSizes[i].dy, color: Colors.transparent,
            ),
          ),
        ),
      ],
    )
    ],
    );
  }
}