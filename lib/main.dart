import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'screens/control_screen.dart';
import 'bluetoothServices/bluetooth_services.dart';
import 'widgets/tank_status_bar.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await SystemChrome.setPreferredOrientations([
    DeviceOrientation.landscapeRight,
  ]);

  BluetoothManager().start();

  runApp(const MyApp());
}


class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Tank controller',
      theme: ThemeData(colorScheme: ColorScheme.fromSeed(seedColor: Colors.blue), useMaterial3: true),
      home: const TankStatusBar(
          child: ControlScreen()
      ),
    );
  }
}
