import 'package:flutter/material.dart';
import 'package:flutter_barcode_scanner/flutter_barcode_scanner.dart';
import 'package:flutter_qr_code/data/store/auth.dart';
import 'package:flutter_qr_code/data/store/course_store.dart';
import 'package:flutter_qr_code/utils/constants.dart';
import 'package:provider/provider.dart';

class ScanScreen extends StatefulWidget {
  static const routeName = '/scan-qr-code';
  const ScanScreen({super.key});

  @override
  _ScanScreenState createState() => _ScanScreenState();
}

class _ScanScreenState extends State<ScanScreen> {
  var qrstr = "Press to Scan";

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          backgroundColor: const Color(0xff161E4C),
          title: const Text('Scanning QR code'),
        ),
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Text(
                qrstr,
                style: const TextStyle(color: Color(0xff161E4C), fontSize: 30),
              ),
              ElevatedButton(
                onPressed: scanQr,
                style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xff161E4C),
                    fixedSize: Size(getWidth(context) * 0.6, 60)),
                child: const Text(
                  ('Scanner'),
                ),
              ),
            ],
          ),
        ));
  }

  Future<void> scanQr() async {
    try {
      FlutterBarcodeScanner.scanBarcode('#2A99CF', 'cancel', true, ScanMode.QR)
          .then((value) async {
        //! send the value to the backend
        if (value != -1) {
          String token = await Provider.of<Auth>(context).getToken();
          Provider.of<CourseStore>(context, listen: false)
              .createStudentAttendance(context, token, value);
        }
        setState(() {
          qrstr = value;
        });
      });
    } catch (e) {
      setState(() {
        qrstr = 'unable to read this';
      });
    }
  }
}
