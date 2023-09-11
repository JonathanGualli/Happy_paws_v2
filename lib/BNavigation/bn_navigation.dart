import 'package:flutter/material.dart';
import 'package:happy_paws_v2/providers/global_variables_provider.dart';
import 'package:happy_paws_v2/providers/pets_provider.dart';
import 'package:happy_paws_v2/screens/home_screen.dart';
import 'package:happy_paws_v2/screens/pets_screen.dart';
import 'package:happy_paws_v2/screens/profile_screen.dart';
import 'package:happy_paws_v2/screens/qr_screen.dart';
import 'package:happy_paws_v2/screens/reminders_screen.dart';
import 'package:happy_paws_v2/widgets/no_reminders.dart';
import 'package:provider/provider.dart';

class BNavigation extends StatefulWidget {
  static const routeName = "/BNnavigaton";

  const BNavigation({super.key});

  @override
  State<BNavigation> createState() => _BNavigationState();
}

class _BNavigationState extends State<BNavigation> {
  late int index;

  List<Widget> pages = [
    const PetsScreen(),
    const QrScreen(),
    const HomeScreen(),
    //const NotificationsScreen(),
    RemindersScreen(),
    const ProfileScreen(),
  ];

  @override
  Widget build(BuildContext context) {
    //index = GlobalVariables.instance.index;
    index = Provider.of<GlobalVariables>(context).index;
    PetsProvider.instance;
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
          GlobalVariables.instance.index = index;
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
