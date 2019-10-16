import 'dart:math';
import 'package:flare_flutter/flare_actor.dart';
import 'package:flare_flutter/flare_controller.dart';
import 'package:flare_dart/math/mat2d.dart';
import 'package:flare_flutter/flare.dart';
///Make sure you update your pubspec.yaml
import 'package:audioplayers/audio_cache.dart';

import 'package:flare_dart/actor_bone.dart';

class DragonController extends FlareController {
  FlutterActorArtboard _artboard;
  String _animationName;
  double _mixSeconds = 0.1;
  List<FlareAnimationLayer> _animationLayers = [];

  ActorAnimation progressTracker;

  double _speed = 1.0;
  double _mixTime = 0.0;

  void initialize(FlutterActorArtboard artboard) {
    _artboard = artboard;

    ///need to get the animation that has the trigger
    progressTracker = artboard.getAnimation("fight_bar");

  }

  ///Play our sound on the event
  void playSound(){
    AudioCache player = new AudioCache();
    const alarmAudioPath = "audio/heart_success.wav";
    player.play(alarmAudioPath);
  }

  @override
  void setViewTransform(Mat2D viewTransform) {
  }

  void onCompleted(String name) {

  }

  @override
  bool advance(FlutterActorArtboard artboard, double elapsed) {
    int lastFullyMixed = -1;
    double lastMix = 0.0;

    List<FlareAnimationLayer> completed = [];

    ///Step 1/3
    ///this will get populated in step 2
    List<AnimationEventArgs> _animationEvents = [];

    for (int i = 0; i < _animationLayers.length; i++) {
      FlareAnimationLayer layer = _animationLayers[i];

      double currLayerAnim = layer.time;

      layer.mix += elapsed;
      layer.time += elapsed;

      ///Step 2/3
      progressTracker.triggerEvents(artboard.components, currLayerAnim, layer.time, _animationEvents);


      ///Step 3/3
      for(var event in _animationEvents)
      {
        switch (event.name)
        {
          case "Button_Sound":
          ///play our sound when the event happens
            playSound();
            break;
        }
      }

      lastMix = (_mixSeconds == null || _mixSeconds == 0.0)
          ? 1.0
          : min(1.0, layer.mix / _mixSeconds);

      if (layer.animation.isLooping) {
        layer.time %= layer.animation.duration;
      }

       _mixTime += elapsed * _speed;

      layer.animation.apply(layer.time, _artboard, lastMix);

      if (lastMix == 1.0) {
        lastFullyMixed = i;
      }

      if (layer.time > layer.animation.duration) {
        completed.add(layer);
      }
    }

    if (lastFullyMixed != -1) {
      _animationLayers.removeRange(0, lastFullyMixed);
    }
    if (_animationName == null &&
        _animationLayers.length == 1 &&
        lastMix == 1.0) {
      _animationLayers.removeAt(0);

    }

    for (FlareAnimationLayer animation in completed) {
      _animationLayers.remove(animation);
      onCompleted(animation.name);
    }
    return _animationLayers.isNotEmpty;
  }

  void play(String name,{double mix = 1.0, double mixSeconds = 0.2}) {

    _animationName = name;

    if (_animationName != null && _artboard != null) {

      ActorAnimation animation = _artboard.getAnimation(_animationName);
      if (animation != null) {

        _animationLayers.add(FlareAnimationLayer()
          ..name = _animationName
          ..animation = animation
          ..mix = mix
          ..mixSeconds = mixSeconds);
        isActive.value = true;
      }
    }
  }
}
