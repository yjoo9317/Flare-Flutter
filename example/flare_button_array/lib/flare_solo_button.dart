import 'package:flutter/material.dart';
import 'dart:math';
import 'package:flare_flutter/flare_actor.dart';
import 'package:flare_flutter/flare_controller.dart';
import 'package:flare_dart/math/mat2d.dart';
import 'package:flare_flutter/flare.dart';
import 'package:flare_dart/actor_node_solo.dart';

class FlareSoloButton extends StatefulWidget {
  ///boiler plate code here from FlareControls
  final String artboardString;
  final String pressAnimation;

  ///on Pressed our button needs to play it's animation
  final VoidCallback onPressed;

  ///where in the array our solo image is
  final int soloIndex;
  ///the name of the .flr file
  final String flareFile;
  ///What the Solo Node's name is
  final String soloName;
  /// how big we want our button to be
  final Offset btnSize;

  const FlareSoloButton(
      {this.artboardString, this.pressAnimation, this.onPressed,
        this.soloIndex, this.flareFile, this.soloName, this.btnSize});

  @override
  _FlareSoloButtonState createState() => _FlareSoloButtonState();
}

class _FlareSoloButtonState extends State<FlareSoloButton> with FlareController{
  ///boiler plate code
  FlutterActorArtboard _artboard;
  String _animationName;
  double _mixSeconds = 0.1;
  List<FlareAnimationLayer> _animationLayers = [];

  void initialize(FlutterActorArtboard artboard) {
    _artboard = artboard;

    ///set this on initialization, so our solo is set
    _setSolo();

  }

  ///boiler plate code carried over from FlareControls
  @override
  void setViewTransform(Mat2D viewTransform) {
  }
  void onCompleted(String name) {}
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
  void play(String name, {double mix = 1.0, double mixSeconds = 0.2}) {
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

  ///this is the bread and butter of the demo, this is where we set
  /// the active solo node
  void _setSolo(){
    ActorNodeSolo solo = _artboard.getNode(widget.soloName) as ActorNodeSolo;
    solo.setActiveChildIndex(widget.soloIndex);
  }

  ///create our widget with the Flare Actor
  @override
  Widget build(BuildContext context) {
    return RawMaterialButton(
      constraints: BoxConstraints.tight(
        Size(widget.btnSize.dx, widget
            .btnSize.dy),
      ),
      onPressed: () {
        ///play our pressed Flare animation here
        widget.onPressed?.call();
        if(widget.pressAnimation != null){
          this.play(widget.pressAnimation);
        }
      },
      highlightColor: Colors.transparent,
      splashColor: Colors.transparent,
      child: FlareActor(widget.flareFile,
          fit: BoxFit.contain,
          artboard: widget.artboardString,
          controller: this
      ),
    );
  }
}