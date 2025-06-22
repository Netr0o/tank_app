import 'package:flutter/material.dart';
import 'package:tank_app/screens/firing_screen.dart';
import 'package:flutter_blue_plus/flutter_blue_plus.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:tank_app/theme/colors.dart';

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

  void _rotateLeft() async {
    if (_characteristic != null) {
      await _characteristic!.write([0x3]);
    }
  }

  void _rotateRight() async {
    if (_characteristic != null) {
      await _characteristic!.write([0x04]);
    }
  }

  void _turnLeft() async {
    if (_characteristic != null) {
      await _characteristic!.write([0x10]);
    }
  }

  void _turnRight() async {
    if (_characteristic != null) {
      await _characteristic!.write([0x11]);
    }
  }

  void _turnLeftBack() async {
    if (_characteristic != null) {
      await _characteristic!.write([0x12]);
    }
  }

  void _turnRightBack() async {
    if (_characteristic != null) {
      await _characteristic!.write([0x13]);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        color: Colors.black,
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
                      backgroundColor: backgroundColor,
                    ),
                    onPressed: _characteristic != null ? _forward : null,
                    child: SizedBox(
                      width: 100,
                      height: 100,
                      child: Center(
                        child: Text(
                          "FORWARD",
                          style: GoogleFonts.orbitron(
                            color: widgetTextColor,
                            fontSize: 13,
                            fontWeight: FontWeight.bold,
                            fontStyle: FontStyle.italic,
                          ),
                        ),
                      ),
                    ),
                  ),
                  ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: backgroundColor,
                      ),
                      onPressed: _characteristic != null ? _stop : null,
                      child: SizedBox(
                        width: 100,
                        height: 100,
                        child: Center(
                          child: Text(
                            "STOP",
                            style: GoogleFonts.orbitron(
                              color: widgetTextColor,
                              fontSize: 13,
                              fontWeight: FontWeight.bold,
                              fontStyle: FontStyle.italic,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ElevatedButton(
                    onPressed: _characteristic != null ? _backward : null,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: backgroundColor,
                    ),
                    child: SizedBox(
                      width: 100,
                      height: 100,
                      child: Center(
                        child: Text(
                          "BACKWARD",
                          style: GoogleFonts.orbitron(
                            color: widgetTextColor,
                            fontSize: 13,
                            fontWeight: FontWeight.bold,
                            fontStyle: FontStyle.italic,
                          ),
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
                  backgroundColor: backgroundColor,
                ),
                child: Text(
                  "barrel commands",
                  textAlign: TextAlign.center,
                  style: GoogleFonts.orbitron(
                    color: widgetTextColor,
                    fontSize: 13,
                    fontWeight: FontWeight.bold,
                    fontStyle: FontStyle.italic,
                  ),
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
                          backgroundColor: backgroundColor,
                        ),
                        onPressed: _characteristic != null ? _rotateLeft : null,
                        child: SizedBox(
                          width: 100,
                          height: 100,
                          child: Center(
                            child: Transform(
                              alignment: Alignment.center,
                              transform: Matrix4.identity()
                                ..scale(-1.0, 1.0, 1.0),
                              child: Icon(
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
                          backgroundColor: backgroundColor,
                        ),
                        onPressed:
                            _characteristic != null ? _rotateRight : null,
                        child: SizedBox(
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
                          backgroundColor: backgroundColor,
                        ),
                        onPressed: _characteristic != null ? _turnLeft : null,
                        child: SizedBox(
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
                          backgroundColor: backgroundColor,
                        ),
                        onPressed: _characteristic != null ? _turnRight : null,
                        child: SizedBox(
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
                          backgroundColor: backgroundColor,
                        ),
                        onPressed:
                            _characteristic != null ? _turnLeftBack : null,
                        child: SizedBox(
                          width: 100,
                          height: 110,
                          child: Transform(
                            alignment: Alignment.center,
                            transform: Matrix4.identity()
                              ..scale(1.0, -1.0, 1.0),
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
                          backgroundColor: backgroundColor,
                        ),
                        onPressed:
                            _characteristic != null ? _turnLeftBack : null,
                        child: SizedBox(
                          width: 100,
                          height: 110,
                          child: Transform(
                            alignment: Alignment.center,
                            transform: Matrix4.identity()
                              ..scale(1.0, -1.0, 1.0),
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
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
