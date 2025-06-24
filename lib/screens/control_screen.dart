import 'package:flutter/material.dart';
import 'package:tank_app/main.dart';
import 'package:tank_app/screens/firing_screen.dart';
import 'package:tank_app/theme/styles.dart';

class ControlScreen extends StatefulWidget {
  const ControlScreen({super.key});

  @override
  State<ControlScreen> createState() => _ControlScreenState();
}

class _ControlScreenState extends State<ControlScreen> {

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        color: backgroundColor,
        // decoration: const BoxDecoration(
        //   gradient: LinearGradient(
        //     begin: Alignment.bottomLeft,
        //     end: Alignment.topRight,
        //     colors: <Color>[
        //       Color(0xff214c91),
        //       Color(0xff154494),
        //       Color(0xff093c96),
        //       Color(0xff033297),
        //       Color(0xff062896),
        //       Color(0xff111b95),
        //       Color(0xff1d149b),
        //       Color(0xff2a16aa),
        //       Color(0xff3717b9),
        //       Color(0xff4317c8),
        //       Color(0xff5117d7),
        //       Color(0xff5e15e6),
        //     ],
        //   ),
        // ),
        child: Row(
          children: <Widget>[
            const SizedBox(
              width: 10,
            ),
            SizedBox(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: buttonBackgroundColor,
                    ),
                    onPressed: BluetoothManager().forward,
                    child: SizedBox(
                      width: 100,
                      height: 100,
                      child: Center(
                        child: Text(
                          "FORWARD",
                          style: buttonTextStyle
                        ),
                      ),
                    ),
                  ),
                  ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: buttonBackgroundColor,
                      ),
                      onPressed: BluetoothManager().stop,
                      child: SizedBox(
                        width: 100,
                        height: 100,
                        child: Center(
                          child: Text(
                            "STOP",
                            style: buttonTextStyle
                          ),
                        ),
                      ),
                    ),
                  ElevatedButton(
                    onPressed: BluetoothManager().backward,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: buttonBackgroundColor,
                    ),
                    child: SizedBox(
                      width: 100,
                      height: 100,
                      child: Center(
                        child: Text(
                          "BACKWARD",
                          style: buttonTextStyle
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(
              width: 140,
              height: 60,
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: buttonBackgroundColor,
                ),
                child: Text(
                  "barrel commands",
                  textAlign: TextAlign.center,
                  style: buttonTextStyle
                ),
                onPressed: () {
                  Navigator.push(context,
                      MaterialPageRoute(builder: (_) => const FiringScreen()));
                },
              ),
            ),
            SizedBox(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: buttonBackgroundColor,
                        ),
                        onPressed: BluetoothManager().rotateLeft,
                        child: SizedBox(
                          width: 100,
                          height: 100,
                          child: Center(
                            child: Transform(
                              alignment: Alignment.center,
                              transform: Matrix4.identity()
                                ..scale(-1.0, 1.0, 1.0),
                              child: const Icon(
                                Icons.refresh_rounded,
                                color: widgetTextColor,
                                size: 50.0,
                              ),
                            ),
                          ),
                        ),
                      ),
                      ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: buttonBackgroundColor,
                        ),
                        onPressed: BluetoothManager().rotateRight,
                        child: const SizedBox(
                          width: 100,
                          height: 100,
                          child: Center(
                            child: Icon(
                              Icons.refresh_rounded,
                              color: widgetTextColor,
                              size: 50.0,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: buttonBackgroundColor,
                        ),
                        onPressed: BluetoothManager().turnLeft,
                        child: const SizedBox(
                          width: 110,
                          height: 120,
                          child: Center(
                            child: Icon(
                              Icons.undo,
                              color: widgetTextColor,
                              size: 50.0,
                            ),
                          ),
                        ),
                      ),
                      ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: buttonBackgroundColor,
                        ),
                        onPressed: BluetoothManager().turnRight,
                        child: const SizedBox(
                          width: 110,
                          height: 120,
                          child: Center(
                            child: Icon(
                              Icons.redo,
                              color: widgetTextColor,
                              size: 50.0,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: buttonBackgroundColor,
                        ),
                        onPressed: BluetoothManager().turnLeftBack,
                        child: SizedBox(
                          width: 100,
                          height: 110,
                          child: Transform(
                            alignment: Alignment.center,
                            transform: Matrix4.identity()
                              ..scale(1.0, -1.0, 1.0),
                            child: const Icon(
                              Icons.undo,
                              color: widgetTextColor,
                              size: 50.0,
                            ),
                          ),
                        ),
                      ),
                      ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: buttonBackgroundColor,
                        ),
                        onPressed: BluetoothManager().turnRightBack,
                        child: SizedBox(
                          width: 100,
                          height: 110,
                          child: Transform(
                            alignment: Alignment.center,
                            transform: Matrix4.identity()
                              ..scale(1.0, -1.0, 1.0),
                            child: const Icon(
                              Icons.redo,
                              color: widgetTextColor,
                              size: 50.0,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
