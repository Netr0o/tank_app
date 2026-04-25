import 'package:flutter/material.dart';
import 'package:tank_app/theme/styles.dart';

class TankStatusBar extends StatelessWidget {
  final Widget child;
  const TankStatusBar({required this.child});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          height: 30,
          color: Colors.black,
          child: const Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Center(child:
                Text("11.9V",
                  style: TextStyle(
                    decoration: TextDecoration.none,
                    color: Colors.orange,
                    fontSize: 15,
                  ),
                ),
              ),
              SizedBox(width: 40),
              Center(child:
                Text("CONNECTED",
                  style: TextStyle(
                    decoration: TextDecoration.none,
                    color: Colors.orange,
                    fontSize: 15,
                    fontWeight: FontWeight.bold,
                    fontStyle: FontStyle.italic,),
                ),
              ),
            ],
          ),
        ),
        Expanded(child: child),
      ],
    );
  }
}