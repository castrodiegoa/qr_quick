// import 'package:flutter/material.dart';
// import 'package:qr_flutter/qr_flutter.dart';
// import 'package:share_plus/share_plus.dart';
// import 'package:path_provider/path_provider.dart';
// import 'package:mobile_scanner/mobile_scanner.dart' as mobile_scanner;
// import 'package:image_picker/image_picker.dart';
// import 'package:gallery_saver/gallery_saver.dart';
// import 'dart:io';
// import 'package:google_mlkit_barcode_scanning/google_mlkit_barcode_scanning.dart'
//     as mlkit;

// class QRController {
//   final mobile_scanner.MobileScannerController scannerController =
//       mobile_scanner.MobileScannerController();
//   final mlkit.BarcodeScanner barcodeScanner = mlkit.BarcodeScanner();
//   final picker = ImagePicker();

//   Future<String?> scanImageFromGallery() async {
//     try {
//       final XFile? pickedFile =
//           await picker.pickImage(source: ImageSource.gallery);
//       if (pickedFile == null) return null;

//       final inputImage = mlkit.InputImage.fromFilePath(pickedFile.path);
//       final List<mlkit.Barcode> barcodes =
//           await barcodeScanner.processImage(inputImage);

//       if (barcodes.isNotEmpty) {
//         return barcodes.first.rawValue;
//       } else {
//         return 'No se encontró código QR en la imagen';
//       }
//     } catch (e) {
//       return 'Error al procesar la imagen: $e';
//     }
//   }

//   Future<void> saveQRToGallery(String data, BuildContext context) async {
//     try {
//       // Crear el QR
//       final painter = QrPainter(
//         data: data,
//         version: QrVersions.auto,
//         color: const Color(0xff000000),
//       );

//       final directory = await getTemporaryDirectory();
//       final path =
//           '${directory.path}/qr_${DateTime.now().millisecondsSinceEpoch}.png';
//       final imageData = await painter.toImageData(200.0);

//       if (imageData != null) {
//         final file = File(path);
//         await file.writeAsBytes(imageData.buffer.asUint8List());

//         // Guardar en la galería
//         await GallerySaver.saveImage(file.path);
//         _showSnackBar(context, 'Código QR guardado en la galería');
//       }
//     } catch (e) {
//       _showSnackBar(context, 'Error al guardar el código QR: $e');
//     }
//   }

//   Future<void> shareQR(String data, BuildContext context) async {
//     try {
//       final painter = QrPainter(
//         data: data,
//         version: QrVersions.auto,
//         color: const Color(0xff000000),
//       );

//       final directory = await getTemporaryDirectory();
//       final path =
//           '${directory.path}/qr_${DateTime.now().millisecondsSinceEpoch}.png';
//       final imageData = await painter.toImageData(200.0);

//       if (imageData != null) {
//         final file = File(path);
//         await file.writeAsBytes(imageData.buffer.asUint8List());
//         await Share.shareXFiles([XFile(path)], text: 'Mi código QR');
//       }
//     } catch (e) {
//       _showSnackBar(context, 'Error al compartir el código QR: $e');
//     }
//   }

//   void _showSnackBar(BuildContext context, String message) {
//     ScaffoldMessenger.of(context)
//         .showSnackBar(SnackBar(content: Text(message)));
//   }

//   void dispose() {
//     scannerController.dispose();
//     barcodeScanner.close();
//   }
// }
