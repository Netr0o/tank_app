import 'package:flutter/material.dart';
import 'package:tank_app/screens/control_screen.dart';

class FiringScreen extends StatefulWidget {
  const FiringScreen({super.key});

  @override
  State<FiringScreen> createState() => _FiringScreenState();
}

class _FiringScreenState extends State<FiringScreen> {
  @override
  Widget build(BuildContext context) {
    return Container(
      child: Row(
        children: [
          const SizedBox(
            width: 10,
          ),
          ElevatedButton(
            child: const Text("tank control"),
            onPressed: () {
              Navigator.push(context,
                  MaterialPageRoute(builder: (_) => const ControlScreen()));
            },
          )
        ],
      ),
    );
  }
}
