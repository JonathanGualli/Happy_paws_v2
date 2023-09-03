import 'package:flutter/material.dart';

class noPetScreen extends StatelessWidget {
  const noPetScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return  Center(
      child: Container(
      color: const Color(0xFFDADAFF), // Color de fondo morado
      padding: const EdgeInsets.only(top: 40, left: 16, right: 16, bottom: 40), // Ajusta el espacio alrededor del texto
      child: Column(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
      const Text(
        "!Hola!", // Primera línea
        style: TextStyle(
          color: Colors.purple, // Color del texto blanco
          fontSize: 20,
          fontWeight: FontWeight.bold,
        ),
      ),
     const  Text(
        "Agrega a tus ", // Segunda línea
        style: TextStyle(
          color: Colors.purple, // Color del texto blanco
          fontSize: 20,
          fontWeight: FontWeight.bold,
        ),
      ),
     const  Text(
        "Amiguitos Peludos", // Tercera línea
        style: TextStyle(
          color: Colors.purple, // Color del texto blanco
          fontSize: 20,
          fontWeight: FontWeight.bold,
        ),
      ),
      ClipOval(
        child: Image.network(
          'https://media.istockphoto.com/id/1131169572/es/foto/retrato-de-un-perro-jack-russell-terrier-y-gato-escoc%C3%A9s-recta-abraz%C3%A1ndose-entre-s%C3%AD-aislado.jpg?s=612x612&w=0&k=20&c=gCDwRFV6REr0m7ivQ6OEvLeU22FcEufA6hLjvVK3xMY=',
          width: 250, // Ancho de la imagen
          height: 250, // Altura de la imagen
          fit: BoxFit.cover, // Ajustar la imagen dentro del óvalo
        ),
      ),
      ],
    ),
    
    ),
    );
  }
}