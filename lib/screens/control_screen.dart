import 'package:flutter/material.dart';
import 'package:tank_app/screens/firing_screen.dart';

class ControlScreen extends StatefulWidget {
  const ControlScreen({super.key});

  @override
  State<ControlScreen> createState() => _ControlScreenState();
}

class _ControlScreenState extends State<ControlScreen> {
  int leftTrack = 0;
  int rightTrack = 0;

  void setBothTracks(int value) {
    setState(() {
      leftTrack = value;
      rightTrack = value;
    });
    // send to tank
  }

  void sendToTank() {
    // Replace this with your Bluetooth or Serial communication
    print("Left: $leftTrack, Right: $rightTrack");
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.bottomLeft,
            end: Alignment.topRight,
            colors: <Color>[
              Color(0xff214c91),
              Color(0xff154494),
              Color(0xff093c96),
              Color(0xff033297),
              Color(0xff062896),
              Color(0xff111b95),
              Color(0xff1d149b),
              Color(0xff2a16aa),
              Color(0xff3717b9),
              Color(0xff4317c8),
              Color(0xff5117d7),
              Color(0xff5e15e6),
            ],
          ),
        ),
        child: Row(
          children: <Widget>[
            const SizedBox(
              width: 40,
            ),
            RotatedBox(
              quarterTurns: -1,
              child: Slider(
                value: rightTrack.toDouble(),
                max: 14,
                divisions: 14,
                label: "$rightTrack",
                onChanged: (value) {
                  setState(() => rightTrack = value.toInt());
                },
              ),
            ),
            SizedBox(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  ElevatedButton(
                    onPressed: () {
                      print("FORWARD !!!!!");
                    },
                    child: const SizedBox(
                      width: 100,
                      height: 120,
                      child: Center(
                        child: Text("FORWARD"),
                      ),
                    ),
                  ),
                  ElevatedButton(
                    onPressed: () {
                      print("BACKWARD !!!!!");
                    },
                    child: const SizedBox(
                      width: 100,
                      height: 120,
                      child: Center(
                        child: Text("BACKWARD"),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            ElevatedButton(
              child: const Text("barrel commands"),
              onPressed: () {
                Navigator.push(context,
                    MaterialPageRoute(builder: (_) => const FiringScreen()));
              },
            ),
            SizedBox(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  ElevatedButton(
                    onPressed: () {
                      print("TURN LEFT !!!!!");
                    },
                    child: const SizedBox(
                      width: 100,
                      height: 120,
                      child: Center(
                        child: Text("TURN LEFT"),
                      ),
                    ),
                  ),
                  ElevatedButton(
                    onPressed: () {
                      print("TURN RIGHT !!!!!");
                    },
                    child: const SizedBox(
                      width: 100,
                      height: 120,
                      child: Center(
                        child: Text("TURN RIGHT"),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            RotatedBox(
              quarterTurns: -1,
              child: Slider(
                value: leftTrack.toDouble(),
                max: 14,
                divisions: 14,
                label: "$leftTrack",
                onChanged: (value) {
                  setState(() => leftTrack = value.toInt());
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
