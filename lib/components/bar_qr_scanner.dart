import 'package:flutter/services.dart';
import 'package:flutter_barcode_scanner/flutter_barcode_scanner.dart';

class BarQRScan {
  static Future<String> scanBarQrCodeNormal(ScanMode scanmode) async {
    String barcodeScanRes;
    try {
      barcodeScanRes = await FlutterBarcodeScanner.scanBarcode(
          '#ff6666', 'Cancel', true, scanmode);
    } on PlatformException {
      barcodeScanRes = 'Failed to get platform version';
    }

    return barcodeScanRes;
  }
}
