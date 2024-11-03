// import 'package:flutter/material.dart';
// import 'package:flutter/services.dart';
// import 'package:qr_code_scanner/qr_code_scanner.dart';
// import 'package:image_picker/image_picker.dart';

// class QRScanScreen extends StatefulWidget {
//   @override
//   _QRScanScreenState createState() => _QRScanScreenState();
// }

// class _QRScanScreenState extends State<QRScanScreen> {
//   final GlobalKey qrKey = GlobalKey(debugLabel: 'QR');
//   Barcode? result;
//   QRViewController? controller;

//   @override
//   void dispose() {
//     controller?.dispose();
//     super.dispose();
//   }

//   void _scanFromGallery() async {
//     final pickedFile =
//         await ImagePicker().pickImage(source: ImageSource.gallery);
//     if (pickedFile != null) {
//       // Aquí puedes usar una librería de reconocimiento QR de imágenes
//       // que no incluye qr_code_scanner
//     }
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(title: Text('Escanear QR')),
//       body: Column(
//         children: <Widget>[
//           Expanded(
//             flex: 4,
//             child: QRView(
//               key: qrKey,
//               onQRViewCreated: _onQRViewCreated,
//             ),
//           ),
//           Expanded(
//             flex: 1,
//             child: Column(
//               mainAxisAlignment: MainAxisAlignment.center,
//               children: [
//                 Text(result != null
//                     ? 'Resultado: ${result!.code}'
//                     : 'Escanea un código QR'),
//                 ElevatedButton(
//                   onPressed: () {
//                     Clipboard.setData(ClipboardData(text: result?.code ?? ""));
//                   },
//                   child: Text("Copiar resultado"),
//                 ),
//                 ElevatedButton(
//                   onPressed: _scanFromGallery,
//                   child: Text("Escanear desde galería"),
//                 ),
//               ],
//             ),
//           ),
//         ],
//       ),
//     );
//   }

//   void _onQRViewCreated(QRViewController controller) {
//     this.controller = controller;
//     controller.scannedDataStream.listen((scanData) {
//       setState(() {
//         result = scanData;
//       });a
//     });
//   }
// }
