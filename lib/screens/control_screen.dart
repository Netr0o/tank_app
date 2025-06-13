import 'package:flutter/material.dart';
import 'package:tank_app/screens/firing_screen.dart';
import 'package:flutter_blue_plus/flutter_blue_plus.dart';

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

  void _startScan() {
    FlutterBluePlus.startScan(timeout: const Duration(seconds: 5));

    FlutterBluePlus.scanResults.listen((results) async {
      for (ScanResult r in results) {
        if (r.device.name == targetDeviceName) {
          print("device: ${r.device.name}");
          FlutterBluePlus.stopScan();
          await _connectToDevice(r.device);
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
            setState(() {});
            return;
          }
        }
      }
    }
  }

  void _sendOne() async {
    if (_characteristic != null) {
      await _characteristic!.write([0x01]);
      print("send: 1");
    }
  }

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
              child: Center(
                child: SizedBox(
                  width: 300,
                  height: 40,
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
              ),
            ),
            SizedBox(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  ElevatedButton(
                    onPressed: _characteristic != null ? _sendOne : null,
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
              child: Center(
                child: SizedBox(
                  width: 300,
                  height: 40,
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
              ),
            ),
          ],
        ),
      ),
    );
  }
}
