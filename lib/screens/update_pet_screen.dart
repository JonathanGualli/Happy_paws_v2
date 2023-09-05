import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:happy_paws_v2/models/pet_model.dart';
import 'package:happy_paws_v2/providers/global_variables_provider.dart';
import 'package:happy_paws_v2/providers/pets_provider.dart';
import 'package:happy_paws_v2/services/cloud_storage.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';

import '../services/navigation_service.dart';
import '../services/snackbar_service.dart';
import '../widgets/app_icon.dart';
import '../widgets/image_circle.dart';

class UpdatePetScreen extends StatefulWidget {
  final Map<String, dynamic> pet;
  const UpdatePetScreen({super.key, required this.pet});

  @override
  State<UpdatePetScreen> createState() => _UpdatePetScreenState();
}

class _UpdatePetScreenState extends State<UpdatePetScreen> {
  double deviceHeight = 0;
  double deviceWidth = 0;

  bool isLoading = false;
  bool isChange = false;

  GlobalKey<FormState> formKey = GlobalKey<FormState>();

  TextEditingController nameController = TextEditingController();
  TextEditingController nickNameController = TextEditingController();
  TextEditingController raceController = TextEditingController();
  TextEditingController sexController = TextEditingController();
  TextEditingController birthDatheController = TextEditingController();
  TextEditingController sizeController = TextEditingController();
  TextEditingController weightController = TextEditingController();
  TextEditingController aboutMeController = TextEditingController();

  var birthDate = DateTime.now();

  @override
  void initState() {
    super.initState();
    nameController.text = widget.pet["name"];
    nickNameController.text = widget.pet["nickname"];
    raceController.text = widget.pet["race"];
    sexController.text = widget.pet["sex"];
    if (widget.pet["birthDate"].toDate().year.toString() != "1950") {
      var dateTime = widget.pet["birthDate"].toDate();
      birthDatheController.text =
          "${dateTime.day}/${dateTime.month}/${dateTime.year}";
    } else {
      birthDatheController.text = "";
    }
    sizeController.text = widget.pet["size"];
    weightController.text = widget.pet["weight"];
    aboutMeController.text = widget.pet["aboutMe"];
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
        title: const Text("Actualizar mascota"),
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
        // padding: EdgeInsets.symmetric(
        //     horizontal: deviceWidth * 0.09, vertical: deviceHeight * 0.04),
        padding: EdgeInsets.fromLTRB(deviceWidth * 0.09, deviceWidth * 0.01,
            deviceWidth * 0.09, deviceWidth * 0.04),
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
      height: deviceHeight * 1.4,
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
              imagePath: widget.pet['profileImage'],
              isRegister: false,
            ),
            nameTextField(),
            nickNameTextField(),
            raceTextField(),
            sexDropdown(),
            birthDateSelector(),
            weightTextField(),
            sizeTextField(),
            aboutMeTextField(),
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
          child: Text('Nombre de tu mascota:',
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
                  return 'Ingresa el nombre de tu mascota';
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

  Widget nickNameTextField() {
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
              controller: nickNameController,
              autocorrect: false,
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
                prefixIcon: const Icon(Icons.add_reaction),
                contentPadding: const EdgeInsets.all(1),
                hintText: "Apodo de tu mascota",
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
              controller: raceController,
              autocorrect: false,
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
                prefixIcon: const Icon(Icons.pets_outlined),
                contentPadding: const EdgeInsets.all(1),
                hintText: "Raza de tu mascota",
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

  Widget sexDropdown() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Padding(
          padding: EdgeInsets.only(bottom: 10),
          child: Text('Mi mascota es:',
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
                  hintText: "Selecciona el sexo de tu mascota",
                  fillColor: Colors.red),
              value: sexController.text == "" ? null : sexController.text,
              items: const [
                DropdownMenuItem(
                  value: "Hembra",
                  child: Text("Hembra"),
                ),
                DropdownMenuItem(
                  value: "Macho",
                  child: Text("Macho"),
                ),
              ],
              onChanged: (value) {
                setState(() {
                  sexController.text = value!;
                  isChange = true;
                });
                //print(value);
              },
            ),
          ),
        ),
      ],
    );
  }

// metodos para poder ingresar una fecha con el calendario
  void callDatePicker() async {
    var selectedDate = await getDatePickerWidget(context);
    setState(() {
      if (selectedDate != null) {
        birthDate = selectedDate;
        birthDatheController.text =
            "${birthDate.day}/${birthDate.month}/${birthDate.year}";
      }
    });
  }

  Future<DateTime?> getDatePickerWidget(BuildContext context) {
    return showDatePicker(
      context: context,
      initialDate: birthDate,
      firstDate: DateTime(2015),
      lastDate: DateTime(2024),
      builder: (context, child) {
        return Theme(data: ThemeData.light(), child: child!);
      },
    );
  }

  Widget birthDateSelector() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Padding(
          padding: EdgeInsets.only(bottom: 10),
          child: Text('Fecha de nacimiento:',
              style: TextStyle(
                fontSize: 20,
                color: Color(0xFF27023E),
              )),
        ),
        Center(
          child: SizedBox(
            width: deviceWidth * 0.7,
            child: TextFormField(
              controller: birthDatheController,
              autocorrect: false,
              onChanged: (input) {
                isChange = true;
              },
              style: const TextStyle(color: Color(0xFF57419D)),
              onTap: () {
                callDatePicker();
              },
              readOnly: true,
              decoration: InputDecoration(
                enabledBorder: OutlineInputBorder(
                  borderSide: const BorderSide(color: Colors.purple),
                  borderRadius: BorderRadius.circular(50),
                ),
                border: OutlineInputBorder(
                  borderSide: const BorderSide(color: Colors.purple),
                  borderRadius: BorderRadius.circular(50),
                ),
                prefixIcon: const Icon(Icons.calendar_month),
                contentPadding: const EdgeInsets.all(1),
                hintText: "Fecha de nacimiento",
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

  Widget weightTextField() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Padding(
          padding: EdgeInsets.only(bottom: 10),
          child: Text('Weight:',
              style: TextStyle(
                fontSize: 20,
                color: Color(0xFF27023E),
              )),
        ),
        Center(
          child: SizedBox(
            width: deviceWidth * 0.7,
            child: TextFormField(
              keyboardType: TextInputType.number,
              controller: weightController,
              autocorrect: false,
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
                prefixIcon: const Icon(Icons.scale),
                contentPadding: const EdgeInsets.all(1),
                hintText: "Peso",
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

  Widget sizeTextField() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Padding(
          padding: EdgeInsets.only(bottom: 10),
          child: Text('Talla:',
              style: TextStyle(
                fontSize: 20,
                color: Color(0xFF27023E),
              )),
        ),
        Center(
          child: SizedBox(
            width: deviceWidth * 0.7,
            child: TextFormField(
              keyboardType: TextInputType.number,
              controller: sizeController,
              autocorrect: false,
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
                prefixIcon: const Icon(Icons.straighten),
                contentPadding: const EdgeInsets.all(1),
                hintText: "Talla",
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
                  prefixIcon: const Icon(Icons.tag_faces_rounded),
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
                  var imageURL = widget.pet["profileImage"];

                  if (GlobalVariables.instance.getTemporalImage() != null) {
                    await CloudStorageService.instance
                        .uploadImage(
                            widget.pet["id"],
                            GlobalVariables.instance.getTemporalImage()!,
                            "pets_images")
                        .then((value) async {
                      imageURL = await value!.ref.getDownloadURL();
                    });
                  }
                  List<String> date;
                  String agePet;
                  if (birthDatheController.text != "") {
                    date = birthDatheController.text.split("/");
                    agePet =
                        (DateTime.now().year - int.parse(date[2])).toString();
                  } else {
                    date = "1/1/1950".split('/');
                    agePet = "";
                  }

                  await PetsProvider.instance
                      .updatePetInDB(
                    PetData(
                        id: widget.pet["id"],
                        images: widget.pet["images"],
                        aboutMe: aboutMeController.text,
                        birthDate: Timestamp.fromDate(DateTime(
                            int.parse(date[2]),
                            int.parse(date[1]),
                            int.parse(date[0]))),
                        age: agePet,
                        characteristics: widget.pet["characteristics"],
                        profileImage: imageURL,
                        name: nameController.text,
                        nickname: nickNameController.text,
                        race: raceController.text,
                        sex: sexController.text,
                        size: sizeController.text,
                        type: widget.pet["type"],
                        weight: weightController.text,
                        qrImage: widget.pet["qrImage"],
                        isUpdate: true,
                        isSelected: widget.pet["isSelected"]),
                  )
                      .then((_) {
                    SnackBarService.instance
                        .showSnackBar("Mascota actualizada con exito", true);
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
