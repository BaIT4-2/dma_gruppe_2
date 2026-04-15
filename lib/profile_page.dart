import 'package:flutter/material.dart';

class ProfilePage extends StatelessWidget {
  const ProfilePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Hello, Jack!")),
      body: const Center(
        child: Text("This is the Profile page"),
      ),


      bottomNavigationBar: BottomNavigationBar(
  currentIndex: 1,

  onTap: (index) {
      Navigator.pop(context);
  },
  items: const [
    BottomNavigationBarItem(
      icon: Icon(Icons.location_on_outlined),
      label: "Map",
    ),
    BottomNavigationBarItem(
      icon: Icon(Icons.person_outline),
      label: "Your coupons",
    ),
  ],
),
    );
  }
}