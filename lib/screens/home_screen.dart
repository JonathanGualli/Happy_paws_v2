import 'package:flutter/material.dart';
import 'package:happy_paws_v2/models/pet_model.dart';
import 'package:happy_paws_v2/providers/global_variables_provider.dart';
import 'package:happy_paws_v2/providers/pets_provider.dart';
import 'package:happy_paws_v2/screens/profile_pet_screen.dart';
import 'package:happy_paws_v2/services/snackbar_service.dart';
import 'package:happy_paws_v2/widgets/app_icon.dart';
import 'package:happy_paws_v2/widgets/no_pets_qr.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';
import 'package:provider/provider.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  double deviceWidth = 0;
  double deviceheight = 0;
  bool gifPlaying = false;
  bool show = true;
  bool play = false;
  bool sleep = false;
  String? _petSelected;
  bool isCat = true;

  @override
  Widget build(BuildContext context) {
    deviceWidth = MediaQuery.of(context).size.width;
    deviceheight = MediaQuery.of(context).size.height;
    _petSelected = Provider.of<PetsProvider>(context).petSelected;

    return _petSelected == null
        ? const NoPetQRScreen()
        : Scaffold(
            body: StreamBuilder<PetData>(
              stream: PetsProvider.instance.petStream(_petSelected!),
              builder: (BuildContext context, snapshot) {
                var petData = snapshot.data;
                isCat = petData?.type == "Gato";

                return snapshot.hasData
                    ? qrPageUI(petData)
                    : Center(
                        child: LoadingAnimationWidget.fourRotatingDots(
                            color: Colors.purple, size: 30),
                      );
              },
            ),
          );
  }

  Widget qrPageUI(pet) {
    // print("${petData!.name}");
    return Builder(builder: (BuildContext context) {
      SnackBarService.instance.buildContext = context;
      return Container(
        decoration: const BoxDecoration(
          image: DecorationImage(
              image: AssetImage(
                  'assets/cuartoFondo.jpg'), // Reemplaza 'background_image.jpg' con la ubicación de tu imagen de fondo
              fit: BoxFit.cover,
              alignment: Alignment(0.1, 0)),
        ),
        child: SafeArea(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              Card(
                color: const Color(0xFF9400FF),
                elevation: 10,
                child: SizedBox(
                  width: deviceWidth * 0.8,
                  height: deviceheight * 0.05,
                  child: Padding(
                    padding:
                        EdgeInsets.symmetric(horizontal: deviceWidth * 0.04),
                    child: Center(
                      child: Text(
                        pet.name,
                        style: TextStyle(
                            fontSize: deviceheight * 0.04,
                            color: Colors.white,
                            fontWeight: FontWeight.bold),
                      ),
                    ),
                  ),
                ),
              ),
              Padding(
                padding: EdgeInsets.symmetric(horizontal: deviceWidth * 0.05),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    GestureDetector(
                      onTap: () {
                        GlobalVariables.instance.changeIndexBN(3);
                      },
                      child: const AppIcon(
                        icon: Icons.notifications,
                        size: 50,
                        backgroundColor: Color(0xFF9400FF),
                      ),
                    ),
                    GestureDetector(
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) =>
                                ProfilePetScreen(petID: pet.id),
                          ),
                        );
                      },
                      child: const AppIcon(
                        icon: Icons.remove_red_eye,
                        size: 50,
                        backgroundColor: Color(0xFF9400FF),
                      ),
                    ),
                  ],
                ),
              ),
              GestureDetector(
                onLongPressStart: (details) {
                  setState(() {
                    gifPlaying = true;
                  });
                },
                onLongPressEnd: (details) {
                  setState(() {
                    gifPlaying = false;
                  });
                },
                child: Center(
                  child: SizedBox(
                    height: deviceheight * 0.5,
                    child: AnimatedSwitcher(
                      duration: const Duration(milliseconds: 100),
                      child: show
                          ? isCat
                              ? gifPlaying
                                  ? Image.asset(
                                      'assets/catLove.gif',
                                      key: ValueKey<bool>(gifPlaying),
                                      //width: deviceWidth * 1.5,
                                      //scale: 0.1,
                                    )
                                  : Image.asset(
                                      'assets/cat2.gif',
                                    )
                              : gifPlaying
                                  ? Image.asset(
                                      'assets/dog2.gif',
                                      key: ValueKey<bool>(gifPlaying),
                                      width: deviceWidth * 1.5,
                                      scale: 0.1,
                                    )
                                  : Image.asset(
                                      'assets/dog3.gif',
                                      width: deviceWidth,
                                    )
                          : isCat
                              ? play
                                  ? Image.asset(
                                      'assets/catPlay.gif',
                                    )
                                  : Image.asset(
                                      'assets/catSleep.gif',
                                      //width: deviceWidth,
                                    )
                              : play
                                  ? Image.asset(
                                      'assets/dogPlay.gif',
                                    )
                                  : Image.asset(
                                      'assets/dogSleep.gif',
                                      //width: deviceWidth,
                                    ),
                    ),
                  ),
                ),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  GestureDetector(
                    onTap: () {
                      setState(() {
                        show = true;
                        sleep = false;
                        play = false;
                      });
                    },
                    child: const AppIcon(
                      icon: Icons.bolt,
                      size: 80,
                      backgroundColor: Color(0xFF9400FF),
                    ),
                  ),
                  GestureDetector(
                    onTap: () {
                      setState(() {
                        show = false;
                        sleep = false;
                        play = true;
                      });
                    },
                    child: const AppIcon(
                      icon: Icons.games,
                      size: 80,
                      backgroundColor: Color(0xFF9400FF),
                    ),
                  ),
                  GestureDetector(
                    onTap: () {
                      setState(() {
                        show = false;
                        play = false;
                        sleep = true;
                      });
                    },
                    child: const AppIcon(
                      icon: Icons.bed,
                      size: 80,
                      backgroundColor: Color(0xFF9400FF),
                    ),
                  )
                ],
              )
            ],
          ),
        ),
      );
    });
  }

  //   return Scaffold(
  //     body: Container(
  //       decoration: const BoxDecoration(
  //         image: DecorationImage(
  //             image: AssetImage(
  //                 'assets/cuartoFondo.jpg'), // Reemplaza 'background_image.jpg' con la ubicación de tu imagen de fondo
  //             fit: BoxFit.cover,
  //             alignment: Alignment(0.1, 0)),
  //       ),
  //       child: Column(
  //         mainAxisAlignment: MainAxisAlignment.spaceEvenly,
  //         children: [
  //           Card(
  //             color: Color(0xFF9400FF),
  //             child: SizedBox(
  //               width: deviceWidth * 0.8,
  //               height: deviceheight * 0.05,
  //               child: Center(
  //                 child: Text(
  //                   "Nombre ",
  //                   style: TextStyle(
  //                       fontSize: deviceheight * 0.04,
  //                       color: Colors.white,
  //                       fontWeight: FontWeight.bold),
  //                 ),
  //               ),
  //             ),
  //           ),
  //           GestureDetector(
  //             onLongPressStart: (details) {
  //               setState(() {
  //                 gifPlaying = true;
  //               });
  //             },
  //             onLongPressEnd: (details) {
  //               setState(() {
  //                 gifPlaying = false;
  //               });
  //             },
  //             child: Center(
  //               child: Container(
  //                 height: deviceheight * 0.5,
  //                 child: AnimatedSwitcher(
  //                   duration: const Duration(milliseconds: 100),
  //                   child: gifPlaying
  //                       ? Image.asset(
  //                           'assets/cat2.gif', // Reemplaza 'your_gif.gif' con la ubicación de tu archivo GIF
  //                           key: ValueKey<bool>(gifPlaying),
  //                           width: deviceWidth * 1.5,
  //                           scale: 0.1,
  //                         )
  //                       : Image.asset(
  //                           'assets/cat1.png',
  //                           width: deviceWidth * 0.8,
  //                         ), // Reemplaza 'your_static_image.png' con la ubicación de tu imagen estática
  //                 ),
  //               ),
  //             ),
  //           ),
  //         ],
  //       ),
  //     ),
  //   );
  // }
}
