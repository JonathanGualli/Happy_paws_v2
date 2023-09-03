// !Mejorar la apariencia visual del dropdown

import 'package:flutter/material.dart';
import 'package:happy_paws_v2/providers/global_variables_provider.dart';
import 'package:happy_paws_v2/providers/pets_provider.dart';
import 'package:happy_paws_v2/services/cloud_storage.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';
import 'package:uuid/uuid.dart';
import '../services/navigation_service.dart';
import '../services/snackbar_service.dart';
import '../widgets/app_icon.dart';
import '../widgets/image_circle.dart';

class RegisterPetScreen extends StatefulWidget {
  const RegisterPetScreen({super.key});

  static const routeName = "/registerPet";

  @override
  State<RegisterPetScreen> createState() => _RegisterPetScreenState();
}

class _RegisterPetScreenState extends State<RegisterPetScreen> {
  double deviceHeight = 0;
  double deviceWidth = 0;

  bool isLoading = false;

  TextEditingController nameController = TextEditingController();
  TextEditingController nicknameController = TextEditingController();
  TextEditingController raceController = TextEditingController();
  TextEditingController aboutMeController = TextEditingController();
  TextEditingController typeController = TextEditingController();

  GlobalKey<FormState> formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    deviceHeight = MediaQuery.of(context).size.height;
    deviceWidth = MediaQuery.of(context).size.width;
    SnackBarService.instance.buildContext = context;
    return Scaffold(
      backgroundColor: const Color(0xFFF5F5FA),
      appBar: AppBar(
        leading: IconButton(
          icon: const AppIcon(icon: Icons.arrow_back_ios_new_rounded),
          onPressed: () {
            NavigationService.instance.goBack();
          },
        ),
        elevation: 0,
        titleTextStyle: const TextStyle(
            color: Colors.purple, fontSize: 25, fontWeight: FontWeight.bold),
        backgroundColor: const Color(0xFFF5F5FA),
        centerTitle: true,
        title: const Text("Agregar Mascota"),
        iconTheme: const IconThemeData(color: Color(0xFF93329E)),
      ),
      body: Align(
        alignment: Alignment.center,
        child: registerPageUI(),
      ),
    );
  }

  Widget registerPageUI() {
    return Container(
        alignment: Alignment.center,
        padding: EdgeInsets.symmetric(horizontal: deviceWidth * 0.09),
        child: SingleChildScrollView(
            child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: <Widget>[inputForm()],
        )));
  }

  Widget inputForm() {
    return SizedBox(
      height: deviceHeight * 0.86,
      width: double.infinity,
      child: Form(
        key: formKey,
        onChanged: () {
          formKey.currentState!.save();
        },
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.max,
          children: <Widget>[
            //imageSelectorWidget(),
            const ImageCircle(
              imagePath: "assets/profileImage.png",
              isRegister: true,
            ),
            categoryDropdown(),
            nameTextField(),
            nicknameTextField(),
            raceTextField(),
            aboutMeTextField(),
            createButtom()
          ],
        ),
      ),
    );
  }

  Widget categoryDropdown() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Padding(
          padding: EdgeInsets.only(bottom: 10),
          child: Text('Mi mascota es un:',
              style: TextStyle(
                fontSize: 20,
                color: Color(0xFF27023E),
              )),
        ),
        Center(
          child: SizedBox(
            width: deviceWidth * 0.7,
            child: DropdownButtonFormField(
              decoration: const InputDecoration.collapsed(
                  hintText: "Selecciona un tipo de mascota",
                  fillColor: Colors.red),
              items: const [
                DropdownMenuItem(
                  value: "Gato",
                  child: Text("Gato"),
                ),
                DropdownMenuItem(
                  value: "Perro",
                  child: Text("Perro"),
                ),
              ],
              onChanged: (value) {
                typeController.text = value!;
                //print(value);
              },
              validator: (input) {
                if (input == null) {
                  return 'Ingresa el tipo de mascota';
                }
                return null;
              },
            ),
          ),
        ),
      ],
    );
  }

  Widget nameTextField() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Padding(
          padding: EdgeInsets.only(bottom: 10),
          child: Text('Nombre:',
              style: TextStyle(
                fontSize: 20,
                color: Color(0xFF27023E),
              )),
        ),
        Center(
          child: SizedBox(
            width: deviceWidth * 0.7,
            child: TextFormField(
              autocorrect: false,
              controller: nameController,
              style: const TextStyle(color: Color(0xFF57419D)),
              validator: (input) {
                if (input!.isEmpty) {
                  return "Ingresa el nombre de tu mascota";
                }
                return null;
              },
              decoration: InputDecoration(
                enabledBorder: OutlineInputBorder(
                  borderSide: const BorderSide(color: Colors.purple),
                  borderRadius: BorderRadius.circular(50),
                ),
                border: OutlineInputBorder(
                  borderSide: const BorderSide(color: Colors.purple),
                  borderRadius: BorderRadius.circular(50),
                ),
                prefixIcon: const Icon(Icons.pets),
                contentPadding: const EdgeInsets.all(1),
                hintText: "Nombre de tu mascota",
                filled: true,
                fillColor: const Color(0xFFDADAFF),
                prefixIconColor: Colors.purple,
                errorBorder: OutlineInputBorder(
                  borderSide:
                      const BorderSide(color: Color(0xFFFF9B9B), width: 2.5),
                  borderRadius: BorderRadius.circular(50),
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget nicknameTextField() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Padding(
          padding: EdgeInsets.only(bottom: 10),
          child: Text('Apodo:',
              style: TextStyle(
                fontSize: 20,
                color: Color(0xFF27023E),
              )),
        ),
        Center(
          child: SizedBox(
            width: deviceWidth * 0.7,
            child: TextFormField(
              autocorrect: false,
              controller: nicknameController,
              style: const TextStyle(color: Color(0xFF57419D)),
              decoration: InputDecoration(
                enabledBorder: OutlineInputBorder(
                  borderSide: const BorderSide(color: Colors.purple),
                  borderRadius: BorderRadius.circular(50),
                ),
                border: OutlineInputBorder(
                  borderSide: const BorderSide(color: Colors.purple),
                  borderRadius: BorderRadius.circular(50),
                ),
                prefixIcon: const Icon(Icons.pets),
                contentPadding: const EdgeInsets.all(1),
                hintText: "Apodo de tu mascota (opcional)",
                filled: true,
                fillColor: const Color(0xFFDADAFF),
                prefixIconColor: Colors.purple,
                errorBorder: OutlineInputBorder(
                  borderSide:
                      const BorderSide(color: Color(0xFFFF9B9B), width: 2.5),
                  borderRadius: BorderRadius.circular(50),
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget raceTextField() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Padding(
          padding: EdgeInsets.only(bottom: 10),
          child: Text('Raza:',
              style: TextStyle(
                fontSize: 20,
                color: Color(0xFF27023E),
              )),
        ),
        Center(
          child: SizedBox(
            width: deviceWidth * 0.7,
            child: TextFormField(
              autocorrect: false,
              controller: raceController,
              style: const TextStyle(color: Color(0xFF57419D)),
              decoration: InputDecoration(
                enabledBorder: OutlineInputBorder(
                  borderSide: const BorderSide(color: Colors.purple),
                  borderRadius: BorderRadius.circular(50),
                ),
                border: OutlineInputBorder(
                  borderSide: const BorderSide(color: Colors.purple),
                  borderRadius: BorderRadius.circular(50),
                ),
                prefixIcon: const Icon(Icons.pets),
                contentPadding: const EdgeInsets.all(1),
                hintText: "raza de tu mascota (opcional)",
                filled: true,
                fillColor: const Color(0xFFDADAFF),
                prefixIconColor: Colors.purple,
                errorBorder: OutlineInputBorder(
                  borderSide:
                      const BorderSide(color: Color(0xFFFF9B9B), width: 2.5),
                  borderRadius: BorderRadius.circular(50),
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget aboutMeTextField() {
    return Padding(
      padding: const EdgeInsets.only(bottom: 15),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Padding(
            padding: EdgeInsets.only(bottom: 10),
            child: Text('Sobre mí:',
                style: TextStyle(
                  fontSize: 20,
                  color: Color(0xFF27023E),
                )),
          ),
          Center(
            child: SizedBox(
              width: deviceWidth * 0.7,
              child: TextFormField(
                controller: aboutMeController,
                textAlign: TextAlign.justify,
                autocorrect: false,
                style: const TextStyle(color: Color(0xFF57419D)),
                maxLines: 4,
                minLines: 1,
                decoration: InputDecoration(
                  enabledBorder: OutlineInputBorder(
                    borderSide: const BorderSide(color: Colors.purple),
                    borderRadius: BorderRadius.circular(50),
                  ),
                  border: OutlineInputBorder(
                    borderSide: const BorderSide(color: Colors.purple),
                    borderRadius: BorderRadius.circular(50),
                  ),
                  prefixIcon: const Icon(Icons.sentiment_satisfied_alt),
                  contentPadding: const EdgeInsets.all(1),
                  hintText:
                      "Ingresa cosas interesantes sobre \ntu mascota (opcional)",
                  filled: true,
                  fillColor: const Color(0xFFDADAFF),
                  prefixIconColor: Colors.purple,
                  errorBorder: OutlineInputBorder(
                    borderSide:
                        const BorderSide(color: Color(0xFFFF9B9B), width: 2.5),
                    borderRadius: BorderRadius.circular(50),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget createButtom() {
    return SizedBox(
      width: deviceWidth * 0.9,
      height: deviceHeight * 0.055,
      child: ElevatedButton(
          style: ButtonStyle(
              backgroundColor:
                  const MaterialStatePropertyAll(Color(0xFF57419D)),
              shape: MaterialStatePropertyAll<RoundedRectangleBorder>(
                  RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(32)))),
          onPressed: isLoading
              ? null
              : () async {
                  if (GlobalVariables.instance.getTemporalImage() == null) {
                    SnackBarService.instance.showSnackBar(
                        "Por favor ingresa una imagen de tu mascota", false);
                  } else {
                    if (formKey.currentState!.validate()) {
                      setState(() {
                        isLoading = true;
                      });
                      var petID = const Uuid().v4();
                      var result =
                          await CloudStorageService.instance.uploadImage(
                        petID,
                        GlobalVariables.instance.getTemporalImage()!,
                        "pets_images",
                      );
                      var imageURL = await result!.ref.getDownloadURL();
                      
                      await PetsProvider.instance
                          .addPetInDB(
                              nameController.text,
                              typeController.text,
                              raceController.text,
                              nicknameController.text,
                              aboutMeController.text,
                              imageURL)
                          .then((_) {
                        SnackBarService.instance
                            .showSnackBar("Mascota agregada con éxito", true);
                        NavigationService.instance.goBack();
                      });
                    }
                  }
/*                  //print("Me estoy ejecutando weeee");
                  if (image == null) {
                    SnackBarService.instance.showSnackBarError(
                        "Por favor ingresa una imagen de tu mascota");
                  } else {
                    if (formKey.currentState!.validate()) {
                      var result =
                          await CloudStorageService.instance.uploadImage(
                              //ignore: prefer_interpolation_to_compose_strings
                              name + "_" + _auth!.user!.uid,
                              image!,
                              "pets_images");
                      var imageURL = await result!.ref.getDownloadURL();
                      await PetsProvider.instance
                          .addPet(name, type, race, nickname, aboutMe, imageURL)
                          .then((value) {
                        SnackBarService.instance
                            .showSnackBarSuccess("Mascota agregada con éxito");
                        NavigationService.instance.goBack();
                      });
                    }
                  }*/
                },
          child: isLoading
              ? LoadingAnimationWidget.fourRotatingDots(
                  color: Colors.white, size: 30)
              : const Text(
                  'Ingresar',
                  style: TextStyle(color: Colors.white, fontSize: 20),
                )),
    );
  }
}
