import 'package:flutter/material.dart';
import 'package:tank_app/screens/firing_screen.dart';

class ControlScreen extends StatefulWidget {
  const ControlScreen({super.key});

  @override
  State<ControlScreen> createState() => _ControlScreenState();
}

class _ControlScreenState extends State<ControlScreen> {
  @override
  Widget build(BuildContext context) {
    return Container(
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
        children: [
          const SizedBox(
            width: 50,
          ),
          ElevatedButton(
            child: const Text("barrel commands"),
            onPressed: () {
              Navigator.push(context,
                  MaterialPageRoute(builder: (_) => const FiringScreen()));
            },
          )
        ],
      ),
    );
  }
}
