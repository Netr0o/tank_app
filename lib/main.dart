import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'screens/control_screen.dart';
import 'package:flutter_blue_plus/flutter_blue_plus.dart';
import 'package:permission_handler/permission_handler.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await SystemChrome.setPreferredOrientations([
    DeviceOrientation.landscapeRight,
  ]);

  BluetoothManager().start();

  runApp(const MyApp());
}

class BluetoothManager {
  static final BluetoothManager _instance = BluetoothManager._internal();
  factory BluetoothManager() => _instance;
  BluetoothManager._internal();

  BluetoothDevice? _device;
  BluetoothCharacteristic? _characteristic;

  final String targetDeviceName = "MOUHAHA";
  final Guid serviceUuid = Guid("19B10000-E8F2-537E-4F6C-D104768A1214");
  final Guid characteristicUuid = Guid("19B10001-E8F2-537E-4F6C-D104768A1214");

  void start() {
    _startScan();
  }

  Future<bool> requestBluetoothPermissions() async {
    final status = await [
      Permission.bluetoothScan,
      Permission.bluetoothConnect,
      Permission.location
    ].request();
    return status.values.every((s) => s.isGranted);
  }

  void _startScan() async {
    var status = await requestBluetoothPermissions();

    if (!status) {
      print("perm not allowed");
    }

    bool isOn = await FlutterBluePlus.isOn;
    if (!isOn) {
      print("Bluetooth is off. Please enable Bluetooth.");
      return;
    }

    FlutterBluePlus.startScan(timeout: const Duration(seconds: 5));

    FlutterBluePlus.scanResults.listen((results) async {
      for (ScanResult r in results) {
        print("result : ${r.device.name}");
        if (r.advertisementData.advName == targetDeviceName) {
          print("found device: ${r.advertisementData.advName}");
          FlutterBluePlus.stopScan();
          await _connectToDevice(r.device);
          break;
        } else {
          print("fail !!!");
        }
      }
    });
  }

  Future<void> _connectToDevice(BluetoothDevice device) async {
    await device.connect();
    _device = device;

    List<BluetoothService> services = await device.discoverServices();
    for (var service in services) {
      if (service.uuid == serviceUuid) {
        for (var characteristic in service.characteristics) {
          if (characteristic.uuid == characteristicUuid) {
            _characteristic = characteristic;
            print("found !!!!!");
            return;
          }
        }
      }
    }
  }

  void forward() async {
    await _characteristic?.write([0x01]);
  }

  void stop() async {
    await _characteristic?.write([0x00]);
  }

  void backward() async {
    await _characteristic?.write([0x02]);
  }

  void rotateLeft() async {
    await _characteristic?.write([0x03]);
  }

  void rotateRight() async {
    await _characteristic?.write([0x04]);
  }

  void turnLeft() async {
    await _characteristic?.write([0x10]);
  }

  void turnRight() async {
    await _characteristic?.write([0x11]);
  }

  void turnLeftBack() async {
    await _characteristic?.write([0x12]);
  }

  void turnRightBack() async {
    await _characteristic?.write([0x13]);
  }


}


class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Tank controller',
      theme: ThemeData(colorScheme: ColorScheme.fromSeed(seedColor: Colors.blue), useMaterial3: true),
      home: const ControlScreen(),
    );
  }
}
