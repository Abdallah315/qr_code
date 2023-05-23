import 'package:flutter/material.dart';
import 'package:flutter_barcode_scanner/flutter_barcode_scanner.dart';
import 'package:flutter_qr_code/data/store/auth.dart';
import 'package:flutter_qr_code/data/store/course_store.dart';
import 'package:flutter_qr_code/utils/constants.dart';
import 'package:lottie/lottie.dart';
import 'package:provider/provider.dart';

class ScanScreen extends StatefulWidget {
  static const routeName = '/scan-qr-code';
  const ScanScreen({super.key});

  @override
  State<ScanScreen> createState() => _ScanScreenState();
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
        if (value != -1) {
          String token =
              await Provider.of<Auth>(context, listen: false).getToken();
          // ignore: use_build_context_synchronously
          Provider.of<CourseStore>(context, listen: false)
              .createStudentAttendance(context, token, value)
              .then((value) {
            if (value) {
              setState(() {
                qrstr = 'Done';
              });
              showSuccessBottomSheet(context);
            } else {
              setState(() {
                qrstr = 'Try Again';
              });
              showFailureBottomSheet(context);
            }
          });
        }
      });
    } catch (e) {
      setState(() {
        qrstr = 'unable to read this';
      });
    }
  }

  Future<void> showSuccessBottomSheet(
    context,
  ) async {
    await showModalBottomSheet(
      context: context,
      isDismissible: true,
      enableDrag: true,
      useRootNavigator: true,
      builder: (context) => Material(
        color: Colors.white,
        child: StatefulBuilder(
          builder: (ctx, setState) => Container(
            height: getHeight(ctx) / 2.3,
            padding: const EdgeInsets.symmetric(vertical: 15.0, horizontal: 16),
            child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Lottie.asset('assets/images/green check-mark.json',
                      width: 140, height: 140),
                  const Text(
                    'Your Attendance have been recorded',
                    style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.w700,
                        color: Colors.black),
                  ),
                  ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xff171d22),
                      fixedSize: Size(MediaQuery.of(context).size.width * 0.7,
                          MediaQuery.of(context).size.height * 0.08),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(35),
                      ),
                    ),
                    onPressed: () =>
                        Navigator.of(ctx, rootNavigator: true).pop(),
                    child: const Text(
                      "Done",
                      style: TextStyle(fontSize: 15),
                    ),
                  ),
                ]),
          ),
        ),
      ),
    );
  }

  Future<void> showFailureBottomSheet(
    context,
  ) async {
    await showModalBottomSheet(
      context: context,
      isDismissible: true,
      enableDrag: true,
      useRootNavigator: true,
      builder: (context) => Material(
        color: Colors.white,
        child: StatefulBuilder(
          builder: (ctx, setState) => Container(
            height: getHeight(ctx) / 2.3,
            padding: const EdgeInsets.symmetric(vertical: 15.0, horizontal: 16),
            child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Icon(
                    Icons.close_outlined,
                    size: 70,
                    color: Colors.red,
                  ),
                  const Text(
                    'Something went wrong,please try again',
                    style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.w700,
                        color: Colors.black),
                  ),
                  ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xff171d22),
                      fixedSize: Size(MediaQuery.of(context).size.width * 0.7,
                          MediaQuery.of(context).size.height * 0.08),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(35),
                      ),
                    ),
                    onPressed: () =>
                        Navigator.of(ctx, rootNavigator: true).pop(),
                    child: const Text(
                      "close",
                      style: TextStyle(fontSize: 15),
                    ),
                  ),
                ]),
          ),
        ),
      ),
    );
  }
}
