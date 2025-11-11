import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(colorScheme: ColorScheme.fromSeed(seedColor: Colors.white)),
      home: const MyHomePage(),
      debugShowCheckedModeBanner: false,
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key});

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  final initialChainHeight = 100.0;
  late final double pullThreshold = initialChainHeight * 1.5;
  late double chainHeight = initialChainHeight;
  bool holdingChain = false;
  final animationDuration = Duration(milliseconds: 400);
  bool isDay = true;
  final sunColor = Colors.orange.shade300;
  final moonColor = Colors.white;
  final sunMoonRadius = 130.0;
  final curve = Curves.fastOutSlowIn;
  final dayBg = Colors.yellow.shade100;
  final nightBg = Colors.grey.shade900;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: AnimatedContainer(
        duration: animationDuration,
        color: isDay ? dayBg : nightBg,
        width: double.infinity,
        curve: curve,
        child: Column(
          children: [
            SizedBox(height: 300),
            Stack(
              children: [
                AnimatedContainer(
                  duration: animationDuration,
                  decoration: BoxDecoration(color: isDay ? sunColor : moonColor, shape: BoxShape.circle),
                  height: sunMoonRadius,
                  width: sunMoonRadius,
                  curve: curve,
                ),
                Transform.translate(
                  offset: Offset(-10, -10),
                  child: AnimatedContainer(
                    duration: animationDuration,
                    height: isDay ? 0 : 110,
                    width: isDay ? 0 : 110,
                    curve: curve,
                    decoration: BoxDecoration(color: isDay ? dayBg : nightBg, shape: BoxShape.circle),
                  ),
                ),
              ],
            ),
            AnimatedContainer(
              duration: holdingChain ? Duration.zero : Duration(milliseconds: 1000),
              curve: Curves.elasticOut,
              height: chainHeight,
              width: 3,
              decoration: BoxDecoration(color: isDay ? sunColor : moonColor),
            ),
            Draggable(
              axis: Axis.vertical,
              feedback: SizedBox(),
              onDragUpdate: onDragUpdate,
              onDragEnd: onDragEnd,
              child: AnimatedContainer(
                duration: animationDuration,
                decoration: BoxDecoration(color: isDay ? sunColor : moonColor, shape: BoxShape.circle),
                height: 15,
                width: 15,
                curve: curve,
              ),
            ),
          ],
        ),
      ),
    );
  }

  void onDragUpdate(DragUpdateDetails details) {
    setState(() {
      chainHeight += details.delta.dy;
      if (chainHeight < 0) {
        chainHeight = 0;
      }
      holdingChain = true;
    });
  }

  void onDragEnd(DraggableDetails details) {
    setState(() {
      if (chainHeight > pullThreshold) {
        isDay = !isDay;
      }
      chainHeight = initialChainHeight;
      holdingChain = false;
    });
  }
}
