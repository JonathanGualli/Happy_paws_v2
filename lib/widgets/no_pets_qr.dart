import 'package:flutter/material.dart';
import 'package:happy_paws_v2/providers/global_variables_provider.dart';

class NoPetQRScreen extends StatelessWidget {
  const NoPetQRScreen({super.key});

  @override
  Widget build(BuildContext context) {
    double deviceWidth = MediaQuery.of(context).size.width;

    return Center(
      child: SizedBox(
        width: double.infinity,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Padding(
              padding: EdgeInsets.all(deviceWidth * 0.1),
              child: Text(
                "¡Oh no! Parece que aún no has elegido a tu peludito amigo o no lo has registrado todavía",
                style: TextStyle(
                  fontSize: 22,
                  color: Colors.purple[700],
                  fontWeight: FontWeight.bold,
                ),
                textAlign: TextAlign.center,
              ),
            ),
            Image.asset(
              'assets/sadPets2.png',
              width: deviceWidth * 0.7,
              fit: BoxFit.cover,
            ),
            Padding(
              padding: EdgeInsets.all(deviceWidth * 0.1),
              child: Text(
                "Dirígete a la pantalla de mascotas y realiza esta acción allí. Recuerda que, para seleccionar una mascota, debes mantener presionado su icono durante unos segundos.",
                style: TextStyle(color: Colors.grey[700]),
              ),
            ),
            ElevatedButton(
              style: ButtonStyle(
                  backgroundColor:
                      const MaterialStatePropertyAll(Color(0xFFF16767)),
                  shape: MaterialStatePropertyAll<RoundedRectangleBorder>(
                      RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(32)))),
              onPressed: () {
                GlobalVariables.instance.changeIndexBN(0);
              },
              child: const Text(
                'Seleccionar una mascota',
                style: TextStyle(color: Colors.white, fontSize: 20),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
