import 'package:dma_gruppe_2/profile_page.dart';
import 'package:flutter/material.dart';
import 'package:mobile_scanner/mobile_scanner.dart';

class ScanPage extends StatefulWidget {
  const ScanPage({super.key});

  @override
  State<ScanPage> createState() => _ScanPageState();
}

class _ScanPageState extends State<ScanPage> {
  bool _isScanned = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Scan the QR-code!")),
      body: Center(
        child: MobileScanner(
          onDetect: (result) {
            // Prevent multiple pop errors by checking if we already scanned
            if (!_isScanned && result.barcodes.isNotEmpty) {
              _isScanned = true;
              final code = result.barcodes.first.rawValue;
              print(code);
              // Pop the context and return the scanned string
              Navigator.pushReplacement(
  context,
  MaterialPageRoute(builder: (_) => ProfilePage()),
);
            }
          },  
        ),
      ),
    );
  }
}