import 'package:flutter/material.dart';
import 'package:happy_paws_v2/models/pet_model.dart';
import 'package:happy_paws_v2/providers/pets_provider.dart';
import 'package:happy_paws_v2/screens/profile_pet_screen.dart';
import 'package:happy_paws_v2/screens/register_pet_screen.dart';
import 'package:happy_paws_v2/services/navigation_service.dart';
import 'package:happy_paws_v2/widgets/sex_icon.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';
import 'package:provider/provider.dart';

class PetsScreen extends StatefulWidget {
  const PetsScreen({Key? key}) : super(key: key);

  @override
  State<PetsScreen> createState() => _PetsScreenState();
}

class _PetsScreenState extends State<PetsScreen> {
  double deviceHeight = 0;
  double deviceWidth = 0;

  @override
  Widget build(BuildContext context) {
    deviceHeight = MediaQuery.of(context).size.height;
    deviceWidth = MediaQuery.of(context).size.width;
    final petsStream = context.watch<PetsProvider>().petsStream;
    
    return Scaffold(
      backgroundColor: Color(0xFFDADAFF), // Cambiar el color de fondo a DADAFF
      appBar: AppBar(
        elevation: 0,
        titleTextStyle: const TextStyle(
          color: Color(0xFF57419D),
          fontSize: 25,
          fontWeight: FontWeight.bold,
        ),
        backgroundColor: Color(0xFFDADAFF), // Cambiar el color de fondo a DADAFF
        centerTitle: true,
        title: const Text("Mis mascotas"),
      ),
      body: Column(
        children: [
Container(
  color: Color(0xFFDADAFF), // Color de fondo morado
  padding: EdgeInsets.only(top: 40, left: 16, right: 16, bottom: 40), // Ajusta el espacio alrededor del texto
  child: Column(
  mainAxisAlignment: MainAxisAlignment.start,
  crossAxisAlignment: CrossAxisAlignment.center,
  children: [
    Text(
      "!Hola!", // Primera línea
      style: TextStyle(
        color: Colors.purple, // Color del texto blanco
        fontSize: 20,
        fontWeight: FontWeight.bold,
      ),
    ),
    Text(
      "Agrega a tus ", // Segunda línea
      style: TextStyle(
        color: Colors.purple, // Color del texto blanco
        fontSize: 20,
        fontWeight: FontWeight.bold,
      ),
    ),
    Text(
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

          Expanded(
            child: StreamBuilder<List<PetData>>(
              stream: petsStream,
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return Center(
                    child: LoadingAnimationWidget.fourRotatingDots(
                      color: Colors.purple,
                      size: 30,
                    ),
                  );
                }
                if (snapshot.hasError) {
                  return Text("Error ${snapshot.error}");
                }

                List<PetData>? petsData = snapshot.data;

                return snapshot.hasData
                    ? snapshot.data!.isEmpty
                        ? const Center(child: Text(""))
                        : ListView.builder(
                            itemCount: petsData!.length,
                            itemBuilder: (context, index) {
                              return Dismissible(
                                key: Key(petsData[index].id),
                                direction: DismissDirection.endToStart,
                                onDismissed: (direction) {
                                  PetsProvider.instance.deletePet(petsData[index].id);
                                  setState(() {
                                    petsData.removeAt(index);
                                  });
                                },
                                confirmDismiss: (direction) async {
                                  bool? result = false;
                                  result = await showDialog(
                                    context: context,
                                    builder: (context) {
                                      return AlertDialog(
                                        title: const Text(
                                          "¡Nyaa~! ٩(◕‿◕｡)۶ ¿Estás segurito de eliminar a esta lindura peludita? Recuerda que borrar a tu amiguito de cuatro patitas es una decisión definitiva. Piénsalo bien antes de confirmar, ¡prrr~! (＾◡＾✿)",
                                        ),
                                        actions: [
                                          TextButton(
                                            onPressed: () {
                                              return Navigator.pop(context, false);
                                            },
                                            child: const Text('Cancelar'),
                                          ),
                                          TextButton(
                                            onPressed: () {
                                              return Navigator.pop(context, true);
                                            },
                                            child: const Text('Si, estoy seguro'),
                                          )
                                        ],
                                      );
                                    },
                                  );
                                  return result;
                                },
                                background: Container(
                                  color: const Color(0xFFFF9B9B),
                                  child: Container(
                                    padding: EdgeInsets.all(deviceWidth * 0.1),
                                    child: const Align(
                                      alignment: Alignment.centerRight,
                                      child: Icon(
                                        Icons.delete,
                                        size: 50,
                                        color: Colors.white,
                                      ),
                                    ),
                                  ),
                                ),
                                child: GestureDetector(
                                  onTap: () {
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                        builder: (context) => ProfilePetScreen(
                                          petID: petsData[index].id,
                                        ),
                                      ),
                                    );
                                  },
                                  child: Container(
                                    margin: EdgeInsets.only(
                                      left: deviceWidth * 0.06,
                                      right: deviceWidth * 0.06,
                                      bottom: deviceWidth * 0.05,
                                      top: deviceWidth * 0.04,
                                    ),
                                    child: Row(
                                      children: [
                                        Container(
                                          height: deviceHeight * 0.17,
                                          width: deviceWidth * 0.35,
                                          decoration: BoxDecoration(
                                            borderRadius: BorderRadius.circular(16),
                                            color: Colors.white38,
                                            image: DecorationImage(
                                              fit: BoxFit.cover,
                                              image: NetworkImage(
                                                petsData[index].profileImage,
                                              ),
                                            ),
                                          ),
                                        ),
                                        Expanded(
                                          child: Container(
                                            height: deviceHeight * 0.14,
                                            decoration: const BoxDecoration(
                                              color: Colors.white,
                                              borderRadius: BorderRadius.only(
                                                topRight: Radius.circular(16.0),
                                                bottomRight: Radius.circular(16.0),
                                              ),
                                            ),
                                            child: Padding(
                                              padding: EdgeInsets.all(deviceWidth * 0.05),
                                              child: Column(
                                                crossAxisAlignment: CrossAxisAlignment.start,
                                                mainAxisAlignment: MainAxisAlignment.spaceAround,
                                                children: [
                                                  Row(
                                                    children: [
                                                      Text(
                                                        petsData[index].name,
                                                        style: const TextStyle(
                                                          color: Color(0xFF440A67),
                                                          fontSize: 20,
                                                          fontWeight: FontWeight.bold,
                                                        ),
                                                      ),
                                                      petsData[index].sex == ""
                                                          ? const Text("")
                                                          : SexIcon(
                                                              sex: petsData[index].sex,
                                                            )
                                                    ],
                                                  ),
                                                  Padding(
                                                    padding: const EdgeInsets.symmetric(
                                                      vertical: 9,
                                                    ),
                                                    child: Row(
                                                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                      children: [
                                                        Row(
                                                          children: [
                                                            const Padding(
                                                              padding: EdgeInsets.only(
                                                                right: 5,
                                                              ),
                                                              child: Icon(
                                                                Icons.circle,
                                                                size: 15,
                                                                color: Color(0xFFB9F3E4),
                                                              ),
                                                            ),
                                                            Text(petsData[index].type),
                                                          ],
                                                        ),
                                                        petsData[index].race != ""
                                                            ? Row(
                                                                children: [
                                                                  const Padding(
                                                                    padding: EdgeInsets.only(
                                                                      right: 5,
                                                                    ),
                                                                    child: Icon(
                                                                      Icons.circle,
                                                                      size: 15,
                                                                      color: Color(0xFFFFD4B2),
                                                                    ),
                                                                  ),
                                                                  Text(petsData[index].race),
                                                                ],
                                                              )
                                                            : const Text(""),
                                                      ],
                                                    ),
                                                  ),
                                                  petsData[index].aboutMe != ""
                                                      ? Expanded(
                                                          child: Text(
                                                            petsData[index].aboutMe,
                                                            overflow: TextOverflow.ellipsis,
                                                            //maxLines: 1,
                                                          ),
                                                        )
                                                      : const Expanded(
                                                          child: Text(""),
                                                        ),
                                                ],
                                              ),
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              );
                            },
                          )
                    : Center(
                        child: LoadingAnimationWidget.fourRotatingDots(
                          color: Colors.purple,
                          size: 30,
                        ),
                      );
              },
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: const Color(0xFFD9ACF5),
        onPressed: () {
          NavigationService.instance.navigatePushName(RegisterPetScreen.routeName);
        },
        child: const Icon(Icons.add),
      ),
    );
  }
}
