import 'package:expandable_text/expandable_text.dart';
import 'package:flutter/material.dart';
import 'package:happy_paws_v2/providers/pets_provider.dart';
import 'package:happy_paws_v2/screens/update_pet_screen.dart';
import 'package:happy_paws_v2/widgets/sex_icon.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';

import '../models/pet_model.dart';
import '../services/navigation_service.dart';
import '../widgets/app_icon.dart';

class ProfilePetScreen extends StatefulWidget {
  final String petID;

  const ProfilePetScreen({super.key, required this.petID});

  static const routeName = '/profilePet';

  @override
  State<ProfilePetScreen> createState() => _ProfilePetScreenState();
}

class _ProfilePetScreenState extends State<ProfilePetScreen> {
  double deviceHeight = 0;
  double deviceWidth = 0;

  @override
  Widget build(BuildContext context) {
    deviceHeight = MediaQuery.of(context).size.height;
    deviceWidth = MediaQuery.of(context).size.width;

    return Scaffold(
      body: StreamBuilder<PetData>(
        stream: PetsProvider.instance.petStream(widget.petID),
        builder: (BuildContext context, snapshot) {
          var petData = snapshot.data;

          return snapshot.hasData
              ? Stack(
                  children: [
                    userImage(petData!.profileImage),
                    icons(petData),
                    userInformation(petData),
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

  Widget userImage(image) {
    return Positioned(
      left: 0,
      right: 0,
      child: Container(
        width: double.maxFinite,
        //height: 350,
        height: deviceHeight * 0.49,
        decoration: BoxDecoration(
            image: DecorationImage(
          fit: BoxFit.cover,
          image: NetworkImage(image),
        )),
      ),
    );
  }

  Widget icons(petData) {
    return Positioned(
      top: deviceHeight * 0.05,
      left: deviceWidth * 0.04,
      right: deviceWidth * 0.04,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          GestureDetector(
            child: const AppIcon(icon: Icons.arrow_back_ios_new_rounded),
            onTap: () {
              NavigationService.instance.goBack();
            },
          ),
          GestureDetector(
              child: const AppIcon(icon: Icons.edit),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => UpdatePetScreen(pet: petData.toMap()),
                  ),
                );
              }),
        ],
      ),
    );
  }

  Widget userInformation(PetData pet) {
    return Positioned(
      left: 0,
      right: 0,
      bottom: 0,
      top: deviceHeight * 0.44,
      child: Container(
        height: double.minPositive,
        padding: EdgeInsets.fromLTRB(deviceWidth * 0.08, deviceWidth * 0.1,
            deviceWidth * 0.08, deviceWidth * 0.08),
        decoration: BoxDecoration(
          image: DecorationImage(
            image: const AssetImage("assets/fondo1.png"),
            fit: BoxFit.cover,
            colorFilter: ColorFilter.mode(
              const Color(0xFFDADAFF).withOpacity(
                  0.08), // Ajusta la opacidad aquí (0.1 en este ejemplo)
              BlendMode.dstATop, // Usa dstATop para un efecto más sutil
            ),
          ),
          borderRadius: const BorderRadius.only(
            topRight: Radius.circular(47),
            topLeft: Radius.circular(47),
          ),
          color: const Color(0xFFDADAFF),

          //color: Colors.red,
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            nameInformation(pet),
            pet.isUpdate ? otherInformation(pet) : addInformation(pet)
            //otherInformation(pet)

            //ownerInformation(),
            // emailInformation(email),
            // phoneInformation(phone),
            // logOut(),
          ],
        ),
      ),
    );
  }

  Widget nameInformation(PetData pet) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Text(
              pet.name,
              style: const TextStyle(
                fontSize: 25,
                fontWeight: FontWeight.bold,
                color: Color(0xFF440A67),
              ),
            ),
            pet.sex == "" ? const Text("") : SexIcon(sex: pet.sex)
          ],
        ),
        Text(
          pet.nickname,
        ),
      ],
    );
  }

  Widget otherInformation(PetData pet) {
    return Expanded(
      child: Padding(
        padding: const EdgeInsets.only(top: 20),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  width: deviceWidth * 0.2,
                  height: deviceWidth * 0.2,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(15),
                    color: const Color(0xFFED2B2A),
                  ),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        pet.sex == "" ? "N/A" : pet.sex,
                        style: const TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
                      const Text(
                        "Sex",
                        style: TextStyle(color: Colors.white),
                      ),
                    ],
                  ),
                ),
                Container(
                  width: deviceWidth * 0.23,
                  height: deviceWidth * 0.2,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(15),
                    color: const Color(0xFFF48FB1),
                  ),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        pet.age == DateTime(1950) ? "N/A" : pet.age,
                        style: const TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
                      const Text(
                        "Edad",
                        style: TextStyle(color: Colors.white),
                      ),
                    ],
                  ),
                ),
                Container(
                  width: deviceWidth * 0.2,
                  height: deviceWidth * 0.2,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(15),
                    color: const Color(0xFFE384FF),
                  ),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        pet.weight == "" ? "N/A" : pet.weight,
                        style: const TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
                      const Text(
                        "Peso",
                        style: TextStyle(color: Colors.white),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            ExpandableText(
              pet.aboutMe,
              expandText: 'Vew Más',
              collapseText: 'Vew Menos',
              maxLines: 3, // Número de líneas antes de "Vew Más"
              linkColor:
                  Colors.purple[600], // Puedes cambiw el colow a algo lindo 💙
            ),
          ],
        ),
      ),
    );
  }

  Widget addInformation(PetData petData) {
    return Expanded(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          Image.asset("assets/mascotas.png"),
          const Text(
            //"Tu masctoa es pwechiosa, ¿pewo qué tal si añadimos un poquito más de magia? OwO 🌟",
            "Tienes una mascota increible, ¿Pero que tal si añades más información relevante? 🌟",
            style: TextStyle(
              fontFamily: 'Cewestial',
              fontSize: 16,
            ),
          ),
          Center(
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
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) =>
                          UpdatePetScreen(pet: petData.toMap()),
                    ),
                  );
                },
                child: const Text(
                  'Añadir Información',
                  style: TextStyle(color: Colors.white, fontSize: 20),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
