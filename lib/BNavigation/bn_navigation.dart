import 'package:flutter/material.dart';
import 'package:happy_paws_v2/screens/pets_screen.dart';
import 'package:happy_paws_v2/screens/profile_screen.dart';
import 'package:happy_paws_v2/screens/qr_screen.dart';

class BNavigation extends StatefulWidget {
  static const routeName = "/BNnavigaton";

  const BNavigation({super.key});

  @override
  State<BNavigation> createState() => _BNavigationState();
}

class _BNavigationState extends State<BNavigation> {
  int index = 2;

  List<Widget> pages = [
    const PetsScreen(),
    //QRCode(),
    const QrScreen(),
    const QrScreen(),
    const QrScreen(),
    const ProfileScreen(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: pages[index],
      bottomNavigationBar: navigationBar(),
    );
  }

  Widget navigationBar() {
    return BottomNavigationBar(
      backgroundColor: Colors.white,
      selectedItemColor: const Color(0xFF93329E),
      currentIndex: index,
      unselectedItemColor: Colors.grey,
      onTap: (index) {
        setState(() {
          this.index = index;
        });
      },
      type: BottomNavigationBarType.fixed,
      items: const [
        BottomNavigationBarItem(
          icon: Icon(Icons.pets),
          label: "mascotas",
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.qr_code_scanner),
          label: "QR",
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.home),
          label: "Inicio",
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.notifications),
          label: "Notificaciones",
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.person),
          label: "Perfil",
        )
      ],
    );
  }
}
