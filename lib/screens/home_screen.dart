import 'package:flutter/material.dart';
import 'package:happy_paws_v2/providers/pets_provider.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Text("Soy la pantalla de inicio, o home, o ambas "),
      ),
    );
  }
}
