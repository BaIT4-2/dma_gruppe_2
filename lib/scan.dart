import 'package:PicFindR/profile_page.dart';
import 'package:flutter/material.dart';
import 'package:mobile_scanner/mobile_scanner.dart';
import 'package:shared_preferences/shared_preferences.dart';

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
          onDetect: (result) async {
            // Prevent multiple pop errors by checking if we already scanned
            if (!_isScanned && result.barcodes.isNotEmpty) {
              final prefs = await SharedPreferences.getInstance();
              _isScanned = true;
              final code = result.barcodes.first.rawValue;
              print(code);
              
              if (code == "TR") {
                image1 = 'burger/5.jpeg';
                await prefs.setString('image1', image1);
              } else if (code == "TL"){
                image2 = 'burger/6.jpeg';
                await prefs.setString('image2', image2);
              } else if (code == "BR"){
                image3 = 'burger/7.jpeg';
                await prefs.setString('image3', image3);
              } else if (code == "BL"){
                image4 = 'burger/8.jpeg';
                await prefs.setString('image4', image4);
              }

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