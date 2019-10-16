import 'dart:math';
import 'package:flare_flutter/flare_actor.dart';
import 'package:flare_flutter/flare_controller.dart';
import 'package:flare_dart/math/mat2d.dart';
import 'package:flare_flutter/flare.dart';
import 'package:flare_dart/actor_node_solo.dart';

class DragonController extends FlareController {
  ///boiler plate code
  FlutterActorArtboard _artboard;
  String _animationName;
  List<FlareAnimationLayer> _animationLayers = [];
  double _mixSeconds = 0.1;
  double _speed = 1.0;
  double _mixTime = 0.0;


  void initialize(FlutterActorArtboard artboard) {
    _artboard = artboard;
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

    for (int i = 0; i < _animationLayers.length; i++) {
      FlareAnimationLayer layer = _animationLayers[i];
      layer.mix += elapsed;
      layer.time += elapsed;

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
  ///end of boiler plate code

  ///we can call this to change the solo node any time we want
  void setSolo(String soloName, int index) {
    ActorNodeSolo solo = _artboard.getNode(soloName) as ActorNodeSolo;
    solo.setActiveChildIndex(index);
  }

  ///play our animations
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
