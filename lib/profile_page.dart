import 'package:flutter/material.dart';

class ProfilePage extends StatefulWidget {
  // This variable catches the data sent from main.dart
  final String? scannedCode; 

  const ProfilePage({super.key, this.scannedCode});

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  String image1 = 'burger/1.jpeg';
  String image2 = 'burger/2.jpeg';
  String image3 = 'burger/3.jpeg';
  String image4 = 'burger/4.jpeg';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Hello, Jack!")),
      body: Center(child: 
      GridView.count(
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
      )),
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