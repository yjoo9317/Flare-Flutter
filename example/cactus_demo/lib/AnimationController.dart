import 'dart:math';
import 'package:flare_dart/math/mat2d.dart';
import 'package:flare_flutter/flare.dart';
import 'package:flare_flutter/flare_controller.dart';

import 'package:flare_dart/actor_node_solo.dart';

class MyControls extends FlareController {
  ///so we can reference this any where once we declare it
  FlutterActorArtboard _artboard;

  ///our fill animation, so we can animate this each time we add/reduce water intake
  ActorAnimation _fillAnimation;
  double _smileTime = 0.0;
  bool doIt = false;
  double animTime = 0;
  int stacheSolo = 1;

  ActorAnimation progressTracker;

  void initialize(FlutterActorArtboard artboard) {
    //get the reference here on start to our animations and artboard

    if (artboard.name.compareTo("Scene") == 0) {
      _artboard = artboard;

      _fillAnimation = artboard.getAnimation("Mustache_New");

      progressTracker = artboard.getAnimation("Mustache_New");
    }

  }

  void setViewTransform(Mat2D viewTransform) {}

  bool advance(FlutterActorArtboard artboard, double elapsed) {
    _smileTime += elapsed * 1;

    List<AnimationEventArgs> _animationEvents = [];

     if(doIt == true){
       //String temp = _fillAnimation.name;
      //print(temp);
      _fillAnimation.apply(_smileTime % _fillAnimation.duration, _artboard, 1);
    }

    double currLayerAnim = animTime;

    animTime+= elapsed * 1;
    if(animTime > _fillAnimation.duration){
      doIt = false;
    }
    progressTracker.triggerEvents(artboard.components, currLayerAnim,
        animTime, _animationEvents);

    // print(animTime);
    // print(_smileTime);
    ///Step 3/3
    for(var event in _animationEvents)
    {
      switch (event.name)
      {
        case "Event":
        ///play our sound when the event happens
          playSound();
          break;
      }
    }

    return true;
  }


  void playSound(){
    print("bh");
  }
  void playAnim(){
    stacheSolo++;
    if(stacheSolo > 5){
      stacheSolo = 1;
    }
    var solo = _artboard.getNode("Mustache_Solo") as ActorNodeSolo;
    solo.setActiveChildIndex(stacheSolo);
     doIt = true;
     animTime = 0;


  }
}
