import 'package:flutter/material.dart';

class NoPetScreen extends StatelessWidget {
  const NoPetScreen({super.key});


  @override
  Widget build(BuildContext context) {
    double deviceWidth = MediaQuery.of(context).size.width;

    return Center(
      child: Container(
        width: double.infinity,
        color: const Color(0xFFDADAFF),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // const Text(
            //   "!Hola!", // Primera línea
            //   style: TextStyle(
            //     color: Colors.purple, // Color del texto blanco
            //     fontSize: 20,
            //     fontWeight: FontWeight.bold,
            //   ),
            // ),
            // const Text(
            //   "Agrega a tus ", // Segunda línea
            //   style: TextStyle(
            //     color: Colors.purple, // Color del texto blanco
            //     fontSize: 20,
            //     fontWeight: FontWeight.bold,
            //   ),
            // ),
            // const Text(
            //   "Amiguitos Peludos", // Tercera línea
            //   style: TextStyle(
            //     color: Colors.purple, // Color del texto blanco
            //     fontSize: 20,
            //     fontWeight: FontWeight.bold,
            //   ),
            // ),
            Padding(
              padding: EdgeInsets.all(deviceWidth * 0.1),
              child: Text(
                "¡Hola!\nAnímate a agregar a tus adorables\namigos peludos",
                style: TextStyle(
                  fontSize: 22,
                  color: Colors.purple[700],
                  fontWeight: FontWeight.bold,
                ),
                textAlign: TextAlign.center,
              ),
            ),
            ClipOval(
              child: Image.asset(
                'assets/friendlyPets.jpg',
                width: deviceWidth * 0.6,
                height: deviceWidth * 0.6,
                fit: BoxFit.cover,
              ),
            ),
            Padding(
              padding: EdgeInsets.all(deviceWidth * 0.1),
              child: Text(
                "¡Agrega a tus adoradas 🐶🐱 mascotas para llevar un registro de ellas y descubre las emocionantes funcionalidades adicionales que tenemos para ofrecerte! 🌟😃",
                style: TextStyle(color: Colors.grey[700]),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
