import 'package:flutter/material.dart';
import 'package:happy_paws_v2/models/user_model.dart';
import 'package:happy_paws_v2/providers/auth_provider.dart';
import 'package:happy_paws_v2/screens/update_screen.dart';
import 'package:happy_paws_v2/services/db_service.dart';
import 'package:happy_paws_v2/widgets/app_icon.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';
import 'package:provider/provider.dart';

// ignore: must_be_immutable
class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  double deviceHeight = 0;
  double deviceWidth = 0;

  AuthProvider? _auth;

  @override
  Widget build(BuildContext context) {
    deviceHeight = MediaQuery.of(context).size.height;
    deviceWidth = MediaQuery.of(context).size.width;

    _auth = Provider.of<AuthProvider>(context);

    return Scaffold(
      body: StreamBuilder<UserData>(
        stream: DBService.instance.getUserData(_auth!.user!.uid),
        builder: (BuildContext context, snapshot) {
          var userData = snapshot.data;

          return snapshot.hasData
              ? Stack(
                  children: [
                    userImage(userData!.image),
                    icons(context, userData),
                    userInformation(
                        userData.name, userData.email, userData.phone, userData.address, userData.aboutMe)
                    //Text(snapshot.data!.name),
                  ],
                )
              : Center(
                  child: LoadingAnimationWidget.fourRotatingDots(
                      color: Colors.purple, size: 30),
                );
        },
      ),
    );
  }

  Widget userImage(String image) {
    return Positioned(
      left: 0,
      right: 0,
      child: Container(
        width: double.maxFinite,
        //height: 350,
        height: deviceHeight * 0.44,
        decoration: BoxDecoration(
            image: DecorationImage(
          fit: BoxFit.cover,
          image: NetworkImage(image),
        )),
      ),
    );
  }

  Widget icons(BuildContext context, UserData userData) {
    return Positioned(
      top: deviceHeight * 0.05,
      left: deviceWidth * 0.04,
      right: deviceWidth * 0.04,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          const AppIcon(icon: Icons.arrow_back_ios_new_rounded),
          GestureDetector(
            child: const AppIcon(icon: Icons.edit),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) =>
                      UpdateProfileScreen(userData: userData.toMap()),
                ),
              );
            },
          ),
        ],
      ),
    );
  }

  Widget userInformation(String name, String email, String phone, String address, String aboutMe) {
    return Positioned(
      left: 0,
      right: 0,
      bottom: 0,
      top: deviceHeight * 0.42,
      child: Container(
        height: double.minPositive,
        padding: EdgeInsets.fromLTRB(deviceWidth * 0.08, deviceWidth * 0.1,
            deviceWidth * 0.08, deviceWidth * 0.08),
        decoration: const BoxDecoration(
          borderRadius: BorderRadius.only(
            topRight: Radius.circular(55),
            topLeft: Radius.circular(55),
          ),
          color: Color(0xFFDADAFF),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            nameInformation(name),
            emailInformation(email),
            phoneInformation(phone),
            addressInformation(address),
            aboutMeInformation(aboutMe),
            
            logOut(),
          ],
        ),
      ),
    );
  }

  Widget nameInformation(String name) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          name,
       //    style: const TextStyle(
         //   fontSize: 20,
           // fontWeight: FontWeight.bold,
           // color: Color(0xFF440A67),
         // ),
        ),
        const Text(
          "Dueño de 2 mascota/s",
        )
      ],
    );
  }

 Widget emailInformation(String email) {
  return Row(
    crossAxisAlignment: CrossAxisAlignment.center,
    children: [
      const Icon(
        Icons.email,
        color: Color(0xFFFF78C4),
        size: 16.0, // Ajusta el tamaño del icono según tu preferencia
      ),
      const SizedBox(
        width: 8.0, // Espacio entre el icono y el texto (ajusta según tu preferencia)
      ),
      const Text(
        'Correo:',
        //style: TextStyle(
          //fontSize: 20,
          //color: Color.fromARGB(255, 74, 20, 141),
        //),
      ),
      const SizedBox(
        width: 8.0, // Espacio entre 'Correo:' y la dirección de correo electrónico (ajusta según tu preferencia)
      ),
      Text(
        email,
        style: const TextStyle(
          color: Color(0xFF440A67),
          fontSize: 16,
        ),
      ),
    ],
  );
}

Widget phoneInformation(String phone) {
  return Row(
    crossAxisAlignment: CrossAxisAlignment.center,
    children: [
      const Icon(
        Icons.phone_android,
        color: Color(0xFFFF78C4),
        size: 16.0, // Ajusta el tamaño del icono según tu preferencia
      ),
      const SizedBox(
        width: 8.0, // Espacio entre el icono y el texto (ajusta según tu preferencia)
      ),
      const Text(
        'Teléfono:',
        style: TextStyle(
          color: Color(0xFF440A67),
          fontSize: 16,
        ),
      ),
      const SizedBox(
        width: 8.0, // Espacio entre 'Teléfono:' y el número de teléfono (ajusta según tu preferencia)
      ),
      Text(
        phone,
        style: const TextStyle(
          color: Color(0xFF440A67),
          fontSize: 16,
        ),
      ),
    ],
  );
}


Widget addressInformation(String address) {
  return Row(
    crossAxisAlignment: CrossAxisAlignment.center,
    children: [
      const Icon(
        Icons.location_on,
        color: Color(0xFFFF78C4),
        size: 16.0, // Ajusta el tamaño del icono según tu preferencia
      ),
      const SizedBox(
        width: 8.0, // Espacio entre el icono y la dirección (ajusta según tu preferencia)
      ),
      const Text(
        'Ubicación:',
        style: TextStyle(
          color: Color(0xFF440A67),
          fontSize: 16,
        ),
      ),
      const SizedBox(
        width: 8.0, // Espacio entre 'Ubicación:' y la dirección (ajusta según tu preferencia)
      ),
      Text(
        address,
        style: const TextStyle(
          color: Color(0xFF440A67),
          fontSize: 16,
        ),
      ),
    ],
  );
}
Widget aboutMeInformation(String aboutMe) {
  return Row(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      const Padding(
        padding: EdgeInsets.only(bottom: 0, right: 8), // Espacio entre el icono y el texto
        child: Icon(
          Icons.person, // Puedes cambiar este icono por el que desees
          color: Color(0xFFFF78C4), // Color del icono
          size: 20, // Tamaño del icono
        ),
      ),
      Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'About Me:',
            style: TextStyle(
              fontSize: 16,
              color: Color.fromARGB(255, 74, 20, 141),
            ),
          ),
          Text(
            aboutMe,
            style: const TextStyle(
              color: Color(0xFF440A67),
              fontSize: 16,
            ),
          ),
        ],
      ),
    ],
  );
}

  Widget logOut() {
    return Center(
      child: SizedBox(
        width: deviceWidth * 0.7,
        height: deviceHeight * 0.055,
        child: ElevatedButton(
          style: ButtonStyle(
              backgroundColor:
                  const MaterialStatePropertyAll(Color(0xFFF16767)),
              shape: MaterialStatePropertyAll<RoundedRectangleBorder>(
                  RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(32)))),
          onPressed: () {
            _auth!.logoutUser();
          },
          child: const Text(
            'Cerrar sesión',
            style: TextStyle(color: Colors.white, fontSize: 20),
          ),
        ),
      ),
    );
  }
}
