import 'package:flutter/material.dart';
import 'package:flare_flutter/flare_actor.dart';
import 'AnimationController.dart';
void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: MyHomePage(title: 'Flutter Demo Home Page'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  MyHomePage({Key key, this.title}) : super(key: key);


  final String title;

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {

  MyControls _controller = MyControls();


  void _OnPress(){
    _controller.playAnim();
  }

  @override
  Widget build(BuildContext context) {
        return Scaffold(
      appBar: AppBar(
           title: Text(widget.title),
      ),
      body:  Container(
        ///Stack some widgets
        color: const Color.fromRGBO(93, 93, 93, 1),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
        RawMaterialButton(
          constraints: BoxConstraints.tight(const Size(555, 555)),
          onPressed: _OnPress,
          highlightColor: Colors.transparent,
          splashColor: Colors.transparent,
          child: FlareActor("assets/Cactus_No_Joy.flr",
              fit: BoxFit.contain,
            artboard: "Scene",
            controller: _controller,
            animation: "Idle",
              ),
        )
          ],
        ),
      ),
        // This trailing comma makes auto-formatting nicer for build methods.
    );
  }
}
