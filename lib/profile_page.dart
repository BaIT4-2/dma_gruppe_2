import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

  String image1 = 'burger/1.jpeg';
  String image2 = 'burger/2.jpeg';
  String image3 = 'burger/3.jpeg';
  String image4 = 'burger/4.jpeg';
class ProfilePage extends StatefulWidget {
  // This variable catches the data sent from main.dart
  final String? scannedCode; 

  const ProfilePage({super.key, this.scannedCode});

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  @override
  void initState() {
    super.initState();
    _loadImages();
  }

  Future<void> _loadImages() async {
    final prefs = await SharedPreferences.getInstance();
    

    setState(() {
      image1 = prefs.getString('image1') ?? image1;
      image2 = prefs.getString('image2') ?? image2;
      image3 = prefs.getString('image3') ?? image3;
      image4 = prefs.getString('image4') ?? image4;
    });
  }

  Future<void> _clearPrefs() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.clear();

    setState(() {
      image1 = 'burger/1.jpeg';
      image2 = 'burger/2.jpeg';
      image3 = 'burger/3.jpeg';
      image4 = 'burger/4.jpeg';
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Hello, PicFindR!")),
      body: Center(child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        spacing: 20,

        children: [ GridView.count(
        shrinkWrap: true,
        crossAxisCount: 2,
        crossAxisSpacing: 5,
        mainAxisSpacing: 5,
        children: [
          Image.asset(image1),
          Image.asset(image2),
          Image.asset(image3),
          Image.asset(image4),
        ],
      ),
    

      ElevatedButton.icon(
        onPressed: (_clearPrefs), // Clear the cache to reset the coupons
        icon: const Icon(Icons.qr_code_scanner),
        label: const Text("Reset coupons"),
      ),
       ],
        )
        ),

      bottomNavigationBar: BottomNavigationBar(
        currentIndex: 1,
        onTap: (index) {
          if (index == 0) {
            // This takes you back to the Map and removes the Profile page
            Navigator.popUntil(context, (route) => route.isFirst);
          }
        },
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.location_on_outlined), label: "Map"),
          BottomNavigationBarItem(icon: Icon(Icons.person_outline), label: "Your coupons"),
        ],
      ),
    );
  }
}