import 'package:flutter/material.dart';
import 'package:happy_paws_v2/screens/add_reminders_screen.dart';
import 'package:happy_paws_v2/services/navigation_service.dart';
import 'package:happy_paws_v2/services/snackbar_service.dart';

// ignore: must_be_immutable
class NoRemindersScreen extends StatelessWidget {
  NoRemindersScreen({super.key});

  double deviceHeight = 0;
  double deviceWidth = 0;

  @override
  Widget build(BuildContext context) {
    deviceHeight = MediaQuery.of(context).size.height;
    deviceWidth = MediaQuery.of(context).size.width;
    return Scaffold(
      backgroundColor: const Color(0xFFF5F5FA),
      body: Align(
        alignment: Alignment.center,
        child: pageUI(),
      ),
    );
  }

  Widget pageUI() {
    return Builder(builder: (BuildContext context) {
      SnackBarService.instance.buildContext = context;
      return SingleChildScrollView(
        child: Container(
          alignment: Alignment.center,
          padding: EdgeInsets.fromLTRB(deviceWidth * 0.09, deviceWidth * 0.01,
              deviceWidth * 0.09, deviceWidth * 0.04),
          child: SingleChildScrollView(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                Column(
                  children: [
                    Text(
                      "Recordatorios",
                      style: TextStyle(
                          fontSize: 40,
                          color: Colors.purple[700],
                          fontWeight: FontWeight.bold),
                    ),
                    SizedBox(
                      height: deviceHeight * 0.35,
                      width: deviceWidth,
                      child: Image.asset("assets/dogNotifications.gif"),
                    ),
                    SizedBox(
                      height: deviceHeight * 0.25,
                      child: const Center(
                        child: Text(
                          "Nuestra función de 'Recordatorios' en Happy Paws te ayuda a programar y recibir alertas para cuidar adecuadamente a tu mascota. ¡Nunca olvidarás una tarea importante!. Mantén a tu mascota feliz y saludable con nuestros recordatorios personalizables",
                          style: TextStyle(fontSize: 18, color: Colors.grey),
                          textAlign: TextAlign.center,
                        ),
                      ),
                    ),
                    notificationButtom(),
                  ],
                )
              ],
            ),
          ),
        ),
      );
    });
  }

  Widget notificationButtom() {
    return SizedBox(
      width: deviceWidth * 0.9,
      height: deviceHeight * 0.08,
      child: ElevatedButton(
        style: ButtonStyle(
            backgroundColor: const MaterialStatePropertyAll(Color(0xFF57419D)),
            shape: MaterialStatePropertyAll<RoundedRectangleBorder>(
                RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(32)))),
        onPressed: () {
          NavigationService.instance
              .navigatePushName(AddRemindersScreen.routeName);
        },
        child: const Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            Text(
              "Establecer un recordatorio",
              style: TextStyle(color: Colors.white, fontSize: 20),
            ),
            Icon(
              Icons.calendar_month,
              color: Colors.white,
              size: 25,
            )
          ],
        ),
      ),
    );
  }
}
