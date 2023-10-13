import 'package:barcode_scan2/barcode_scan2.dart';

Future<String?> qrScanner() async {
  String? result;
  try {
    ScanResult afterScan = await QRCodeBarCodeScanner.instance.scanner();
    if (afterScan.type == ResultType.Barcode) {
      result = afterScan.rawContent;
      return result;
    }
  } catch (e) {
    throw e.toString();
  }

  return null;
}


class QRCodeBarCodeScanner {
  static final QRCodeBarCodeScanner _instance = QRCodeBarCodeScanner();
  static QRCodeBarCodeScanner get instance => _instance;
  final _selectedCamera = -1;
  final bool _useAutoFocus = true;
  static final _possibleFormats = BarcodeFormat.values.toList()
    ..removeWhere((e) => e == BarcodeFormat.unknown);
  ScanResult scanResult = ScanResult();

  List<BarcodeFormat> selectedFormats = [..._possibleFormats];

  Future<ScanResult> scanner() async {
    ScanOptions options = ScanOptions(
      strings: {
        "cancel": "Back",
        "flash_on": "Flash on",
        "flash_off": "Flash off",
      },
      restrictFormat: selectedFormats,
      useCamera: _selectedCamera,
//        autoEnableFlash: _autoEnableFlash,
      android: AndroidOptions(
//          aspectTolerance: _aspectTolerance,
        useAutoFocus: _useAutoFocus,
      ),
    );
    try {
      scanResult = await BarcodeScanner.scan(options: options);
    } on Error catch (e) {
      throw (e.toString());
    }
    return scanResult;
  }
}

