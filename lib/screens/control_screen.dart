import 'package:flutter/material.dart';
import 'package:tank_app/screens/firing_screen.dart';
import 'package:flutter_blue_plus/flutter_blue_plus.dart';
import 'package:permission_handler/permission_handler.dart';

class ControlScreen extends StatefulWidget {
  const ControlScreen({super.key});

  @override
  State<ControlScreen> createState() => _ControlScreenState();
}

class _ControlScreenState extends State<ControlScreen> {
  BluetoothDevice? _device;
  BluetoothCharacteristic? _characteristic;

  final String targetDeviceName = "MOUHAHA";
  final Guid serviceUuid = Guid("19B10000-E8F2-537E-4F6C-D104768A1214");
  final Guid characteristicUuid = Guid("19B10001-E8F2-537E-4F6C-D104768A1214");

  @override
  void initState() {
    super.initState();
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
        } else {print("fail !!!");}
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
            setState(() {});
            return;
          }
        }
      }
    }
  }

  void _forward() async {
    if (_characteristic != null) {
      await _characteristic!.write([0x01], withoutResponse: false);
    }
  }

  void _stop() async {
    if (_characteristic != null) {
      await _characteristic!.write([0x0]);
    }
  }

  void _backward() async {
    if (_characteristic != null) {
      await _characteristic!.write([0x2]);
    }
  }

  void _turnLeft() async {
    if (_characteristic != null) {
      await _characteristic!.write([0x03]);
    }
  }

  void _turnRight() async {
    if (_characteristic != null) {
      await _characteristic!.write([0x04]);
    }
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
              width: 90,
            ),
            SizedBox(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  ElevatedButton(
                    onPressed: _characteristic != null ? _forward : null,
                    child: const SizedBox(
                      width: 100,
                      height: 80,
                      child: Center(
                        child: Text("FORWARD"),
                      ),
                    ),
                  ),
                  ElevatedButton(
                      onPressed: _characteristic != null ? _stop : null,
                      child: const SizedBox(
                        width: 100,
                        height: 80,
                        child: Center(
                          child: Text("STOP"),
                        ),
                      )),
                  ElevatedButton(
                    onPressed: _characteristic != null ? _backward : null,
                    child: const SizedBox(
                      width: 100,
                      height: 80,
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
                    onPressed:  _characteristic != null ? _turnLeft : null,
                    child: const SizedBox(
                      width: 100,
                      height: 120,
                      child: Center(
                        child: Text("TURN LEFT"),
                      ),
                    ),
                  ),
                  ElevatedButton(
                    onPressed: _characteristic != null ? _turnRight : null,
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
          ],
        ),
      ),
    );
  }
}
