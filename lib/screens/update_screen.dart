//! para cambiar la imagen debe modificar algun parametro del texto, revisar esta parte.

import 'package:flutter/material.dart';
import 'package:happy_paws_v2/models/user_model.dart';
import 'package:happy_paws_v2/providers/global_variables_provider.dart';
import 'package:happy_paws_v2/services/cloud_storage.dart';
import 'package:happy_paws_v2/services/db_service.dart';
import 'package:happy_paws_v2/widgets/app_icon.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';
import '../services/navigation_service.dart';
import '../services/snackbar_service.dart';
import '../widgets/image_circle.dart';

class UpdateProfileScreen extends StatefulWidget {
  final Map<String, dynamic> userData;
  const UpdateProfileScreen({super.key, required this.userData});

  static const routeName = "/updateUser";

  @override
  State<UpdateProfileScreen> createState() => _UpdateProfileScreenState();
}

class _UpdateProfileScreenState extends State<UpdateProfileScreen> {
  double deviceHeight = 0;
  double deviceWidth = 0;

  bool isLoading = false;
  bool isChange = false;

  GlobalKey<FormState> formKey = GlobalKey<FormState>();

  TextEditingController nameController = TextEditingController();
  TextEditingController phoneController = TextEditingController();
  TextEditingController addressController = TextEditingController();
  TextEditingController aboutMeController = TextEditingController();

  @override
  void initState() {
    super.initState();
    nameController.text = widget.userData["name"];
    phoneController.text = widget.userData["phone"];
    addressController.text = widget.userData["address"];
    aboutMeController.text = widget.userData["aboutMe"];
  }

  @override
  Widget build(BuildContext context) {
    deviceHeight = MediaQuery.of(context).size.height;
    deviceWidth = MediaQuery.of(context).size.width;

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
        title: const Text("Perfil"),
        iconTheme: const IconThemeData(color: Color(0xFF93329E)),
      ),
      body: Align(
        alignment: Alignment.center,
        child: updatePageUI(),
      ),
    );
  }

  Widget updatePageUI() {
    return Builder(builder: (BuildContext context) {
      SnackBarService.instance.buildContext = context;
      return Container(
        alignment: Alignment.center,
        padding: EdgeInsets.symmetric(
            horizontal: deviceWidth * 0.09, vertical: deviceHeight * 0.04),
        child: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: <Widget>[
              inputForm(),
            ],
          ),
        ),
      );
    });
  }

  Widget inputForm() {
    return SizedBox(
      height: deviceHeight * 0.8,
      width: double.infinity,
      child: Form(
        key: formKey,
        onChanged: () {
          formKey.currentState!.save();
        },
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.max,
          children: <Widget>[
            ImageCircle(
              imagePath: widget.userData['image'],
              isRegister: false,
            ),
            nameTextField(),
            phoneTextField(),
            locationTextField(),
            aboutTextField(),
            updateButtom(),
          ],
        ),
      ),
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
              controller: nameController,
              autocorrect: false,
              style: const TextStyle(color: Color(0xFF57419D)),
              validator: (input) {
                if (input!.isEmpty) {
                  return 'Ingrese su nombre';
                }
                return null;
              },
              onChanged: (input) {
                isChange = true;
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
                prefixIcon: const Icon(Icons.account_box_rounded),
                contentPadding: const EdgeInsets.all(1),
                hintText: "Nombre del propietario",
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

  Widget phoneTextField() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Padding(
          padding: EdgeInsets.only(bottom: 10),
          child: Text('Número telefónico:',
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
              controller: phoneController,
              style: const TextStyle(color: Color(0xFF57419D)),
              validator: (input) {
                if (input!.isEmpty) {
                  return 'Ingrese su número de telefono';
                }
                return null;
              },
              onChanged: (input) {
                isChange = true;
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
                prefixIcon: const Icon(Icons.phone_android),
                contentPadding: const EdgeInsets.all(1),
                hintText: "Número telefónico",
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

  Widget locationTextField() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Padding(
          padding: EdgeInsets.only(bottom: 10),
          child: Text('Ubicación:',
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
              controller: addressController,
              onChanged: (input) {
                isChange = true;
              },
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
                prefixIcon: const Icon(Icons.location_on),
                contentPadding: const EdgeInsets.all(1),
                hintText: "Ingresa tu ubicación",
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

  Widget aboutTextField() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Padding(
          padding: EdgeInsets.only(bottom: 10),
          child: Text('Sobre mi:',
              style: TextStyle(
                fontSize: 20,
                color: Color(0xFF27023E),
              )),
        ),
        Center(
          child: SizedBox(
            width: deviceWidth * 0.7,
            //height: deviceHeight * 0.2,
            child: TextFormField(
              textAlign: TextAlign.justify,
              controller: aboutMeController,
              onChanged: (input) {
                isChange = true;
              },
              autocorrect: false,
              style: const TextStyle(color: Color(0xFF57419D)),
              maxLines: 4,
              minLines: 1,
              //expands: true,
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
                hintText: "Ingresa cosas sobre ti",
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

  Widget updateButtom() {
    return SizedBox(
      width: deviceWidth * 0.9,
      height: deviceHeight * 0.055,
      child: ElevatedButton(
        style: isChange
            ? ButtonStyle(
                backgroundColor:
                    const MaterialStatePropertyAll(Color(0xFF57419D)),
                shape: MaterialStatePropertyAll<RoundedRectangleBorder>(
                    RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(32))))
            : ButtonStyle(
                backgroundColor:
                    const MaterialStatePropertyAll(Color(0xFF9DB2BF)),
                shape: MaterialStatePropertyAll<RoundedRectangleBorder>(
                    RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(32)))),
        onPressed: isLoading || !isChange || !formKey.currentState!.validate()
            ? null
            : () async {
                setState(() {
                  isLoading = true;
                });
                if (formKey.currentState!.validate()) {
                  var imageURL = widget.userData["image"];

                  if (GlobalVariables.instance.getTemporalImage() != null) {
                    await CloudStorageService.instance
                        .uploadImage(
                            widget.userData["id"],
                            GlobalVariables.instance.getTemporalImage()!,
                            "profile_images")
                        .then((value) async {
                      imageURL = await value!.ref.getDownloadURL();
                    });
                  }
                  
                  await DBService.instance
                      .updateUserInDB(
                    UserData(
                      id: widget.userData["id"],
                      name: nameController.text,
                      email: widget.userData["email"],
                      phone: phoneController.text,
                      address: addressController.text,
                      image: imageURL,
                      aboutMe: aboutMeController.text,
                    ),
                  )
                      .then((value) {
                    SnackBarService.instance
                        .showSnackBar("Usuario actualizado con exito", true);
                    NavigationService.instance.goBack();
                  });
                }
              },
        child: isLoading
            ? LoadingAnimationWidget.fourRotatingDots(
                color: Colors.white, size: 30)
            : const Text(
                'Actualizar Perfil',
                style: TextStyle(color: Colors.white, fontSize: 20),
              ),
      ),
    );
  }
}
