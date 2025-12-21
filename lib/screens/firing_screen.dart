import 'package:flutter/material.dart';
import 'package:tank_app/screens/control_screen.dart';
import 'package:tank_app/theme/styles.dart';
import 'package:sleek_circular_slider/sleek_circular_slider.dart';

class FiringScreen extends StatefulWidget {
  const FiringScreen({super.key});

  @override
  State<FiringScreen> createState() => _FiringScreenState();
}

class _FiringScreenState extends State<FiringScreen> {

  final int elevation = 0;
  final List<String> rotaValue = ["-0.6", "-6", "+6", "+0.6"];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        color: backgroundColor,
        child: Row(
          children: <Widget>[
            const SizedBox(
              width: 10,
            ),
            Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: buttonBackgroundColor,
                  ),
                  child: Text("tank control", style: buttonTextStyle),
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (_) => const ControlScreen()
                      ),
                    );
                  },
                ),
              ],
            ),
            const SizedBox(
              width: 20,
            ),

            Row(
                children: [
                  for(int i=0; i<4; i++)
                    ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: buttonBackgroundColor,
                      ),
                      onPressed: (){
                        print(rotaValue[i]);
                      },
                      child: Text(rotaValue[i], style: buttonTextStyle),
                    ),


                ]
            ),
            // SleekCircularSlider(
            //   min: -40,
            //   max: 30,
            //   initialValue: 0,
            //   appearance: CircularSliderAppearance(
            //     infoProperties: InfoProperties(
            //       modifier: (double value) {
            //         value = -1 * value;
            //         return '${value.toStringAsFixed(0)}°';
            //       },
            //     ),
            //     customWidths: CustomSliderWidths(
            //       handlerSize: 8,
            //       trackWidth: 8,
            //       progressBarWidth: 30,
            //     ),
            //     customColors: CustomSliderColors(
            //       progressBarColor: test2color,
            //       trackColor: Colors.grey.shade800,
            //       dotColor: Colors.white,
            //       shadowColor: Colors.black,
            //     ),
            //     angleRange: 70,
            //     startAngle: 320,
            //     size: 300,
            //   ),
            //   onChange: (double value) {
            //     int elevation = -1 * value.round();
            //     print(elevation);
            //   },
            // ),
            // Transform.rotate(
            //   angle: elevation * 3.1415 / 180,
            //   child: const Icon(Icons.expand_less, size: 40, color: widgetTextColor),
            // ),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: buttonBackgroundColor,
              ),
              onPressed: (null),
              child: Text("FIRE !", style: buttonTextStyle),
            ),
          ],
        ),
      ),
    );
  }
}
