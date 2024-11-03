import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/services.dart';
import 'package:qr_flutter/qr_flutter.dart';
import 'package:path_provider/path_provider.dart';
import 'package:image_picker/image_picker.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:share_plus/share_plus.dart';
import 'dart:io';
import 'dart:ui' as ui;
import 'package:mobile_scanner/mobile_scanner.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'QR Scanner & Generator',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        useMaterial3: true,
      ),
      home: const HomePage(),
    );
  }
}

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int _selectedIndex = 0;

  final List<Widget> _pages = [
    const ScanPage(),
    const GeneratePage(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _pages[_selectedIndex],
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _selectedIndex,
        onTap: (index) {
          setState(() {
            _selectedIndex = index;
          });
        },
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.qr_code_scanner),
            label: 'Escanear',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.qr_code),
            label: 'Generar',
          ),
        ],
      ),
    );
  }
}

class ScanPage extends StatefulWidget {
  const ScanPage({super.key});

  @override
  State<ScanPage> createState() => _ScanPageState();
}

class _ScanPageState extends State<ScanPage> {
  final MobileScannerController controller = MobileScannerController();
  String result = '';
  bool isScanning = true;

  Future<void> _pickImage() async {
    final ImagePicker picker = ImagePicker();
    final XFile? image = await picker.pickImage(source: ImageSource.gallery);

    if (image != null) {
      // Aquí implementarías la lógica para escanear el QR desde la imagen
      setState(() {
        result = 'Funcionalidad en desarrollo';
      });
    }
  }

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Escanear QR'),
        actions: [
          IconButton(
            icon: const Icon(Icons.image),
            onPressed: _pickImage,
          ),
          IconButton(
            icon: ValueListenableBuilder(
              valueListenable: controller.torchState,
              builder: (context, state, child) {
                return Icon(
                  state == TorchState.on ? Icons.flash_on : Icons.flash_off,
                );
              },
            ),
            onPressed: () => controller.toggleTorch(),
          ),
          IconButton(
            icon: ValueListenableBuilder(
              valueListenable: controller.cameraFacingState,
              builder: (context, state, child) {
                return Icon(
                  state == CameraFacing.front
                      ? Icons.camera_front
                      : Icons.camera_rear,
                );
              },
            ),
            onPressed: () => controller.switchCamera(),
          ),
        ],
      ),
      body: Column(
        children: [
          Expanded(
            flex: 5,
            child: MobileScanner(
              controller: controller,
              onDetect: (capture) {
                final List<Barcode> barcodes = capture.barcodes;
                if (isScanning && barcodes.isNotEmpty) {
                  setState(() {
                    result = barcodes.first.rawValue ?? 'Error en lectura';
                    isScanning = false;
                  });
                  controller.stop();
                }
              },
            ),
          ),
          Expanded(
            flex: 2,
            child: Container(
              padding: const EdgeInsets.all(16),
              child: Column(
                children: [
                  Text(
                    'Resultado: $result',
                    style: const TextStyle(fontSize: 16),
                  ),
                  const SizedBox(height: 16),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      ElevatedButton.icon(
                        icon: const Icon(Icons.copy),
                        label: const Text('Copiar'),
                        onPressed: result.isEmpty
                            ? null
                            : () {
                                Clipboard.setData(ClipboardData(text: result));
                                ScaffoldMessenger.of(context).showSnackBar(
                                  const SnackBar(
                                    content:
                                        Text('Texto copiado al portapapeles'),
                                  ),
                                );
                              },
                      ),
                      ElevatedButton.icon(
                        icon: const Icon(Icons.refresh),
                        label: const Text('Escanear otro'),
                        onPressed: () {
                          setState(() {
                            result = '';
                            isScanning = true;
                          });
                          controller.start();
                        },
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class GeneratePage extends StatefulWidget {
  const GeneratePage({super.key});

  @override
  State<GeneratePage> createState() => _GeneratePageState();
}

class _GeneratePageState extends State<GeneratePage> {
  final TextEditingController _textController = TextEditingController();
  final GlobalKey _qrKey = GlobalKey();
  String qrData = '';

  Future<void> _saveQrCode() async {
    try {
      // Obtener permiso de almacenamiento
      final status = await Permission.storage.request();
      if (!status.isGranted) return;

      // Convertir el widget QR a imagen
      final boundary =
          _qrKey.currentContext?.findRenderObject() as RenderRepaintBoundary?;
      if (boundary == null) return;

      final image = await boundary.toImage(pixelRatio: 3.0);
      final byteData = await image.toByteData(format: ui.ImageByteFormat.png);
      final pngBytes = byteData?.buffer.asUint8List();

      if (pngBytes == null) return;

      // Guardar la imagen
      final directory = await getApplicationDocumentsDirectory();
      final imagePath =
          '${directory.path}/qr_${DateTime.now().millisecondsSinceEpoch}.png';
      final imageFile = File(imagePath);
      await imageFile.writeAsBytes(pngBytes);

      // Compartir la imagen
      await Share.shareFiles([imagePath], text: 'QR Code');

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('QR guardado y compartido')),
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error al guardar: $e')),
      );
    }
  }

  @override
  void dispose() {
    _textController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Generar QR'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            TextField(
              controller: _textController,
              decoration: const InputDecoration(
                labelText: 'Texto para el QR',
                border: OutlineInputBorder(),
              ),
              onChanged: (value) {
                setState(() {
                  qrData = value;
                });
              },
            ),
            const SizedBox(height: 24),
            if (qrData.isNotEmpty)
              RepaintBoundary(
                key: _qrKey,
                child: QrImageView(
                  data: qrData,
                  version: QrVersions.auto,
                  size: 200,
                  backgroundColor: Colors.white,
                ),
              ),
            const SizedBox(height: 24),
            if (qrData.isNotEmpty)
              ElevatedButton.icon(
                icon: const Icon(Icons.save),
                label: const Text('Guardar QR'),
                onPressed: _saveQrCode,
              ),
          ],
        ),
      ),
    );
  }
}
