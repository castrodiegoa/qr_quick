// import 'dart:typed_data';

// import 'package:flutter/material.dart';
// import 'package:qr_flutter/qr_flutter.dart';
// import 'package:gallery_saver/gallery_saver.dart';
// import 'package:flutter/rendering.dart';
// import 'dart:ui' as ui;

// class QRGenerateScreen extends StatefulWidget {
//   @override
//   _QRGenerateScreenState createState() => _QRGenerateScreenState();
// }

// class _QRGenerateScreenState extends State<QRGenerateScreen> {
//   TextEditingController _textController = TextEditingController();
//   GlobalKey globalKey = new GlobalKey();

//   Future<void> _saveQRCode() async {
//     RenderRepaintBoundary boundary =
//         globalKey.currentContext!.findRenderObject() as RenderRepaintBoundary;
//     ui.Image image = await boundary.toImage();
//     ByteData? byteData = await image.toByteData(format: ui.ImageByteFormat.png);
//     final pngBytes = byteData?.buffer.asUint8List();

//     if (pngBytes != null) {
//       // Guarda la imagen en la galería
//       await GallerySaver.saveImage(pngBytes as String);
//     }
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(title: Text('Generar QR')),
//       body: Padding(
//         padding: const EdgeInsets.all(16.0),
//         child: Column(
//           children: [
//             TextField(
//               controller: _textController,
//               decoration: InputDecoration(
//                 labelText: 'Ingrese texto para el código QR',
//                 border: OutlineInputBorder(),
//               ),
//               onChanged: (value) {
//                 setState(() {});
//               },
//             ),
//             SizedBox(height: 20),
//             RepaintBoundary(
//   key: globalKey,
//   child: QrImage(
//     data: _textController.text.isNotEmpty ? _textController.text : " ", // Proporciona datos por defecto si está vacío
//     size: 200.0,
//     version: QrVersions.auto,
//   ),
// )
//             ElevatedButton(
//               onPressed: _saveQRCode,
//               child: Text("Guardar en la galería"),
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }
