import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:happy_paws_v2/models/reminder_model.dart';
import 'package:happy_paws_v2/providers/pets_provider.dart';
import 'package:happy_paws_v2/services/db_service.dart';
import 'package:happy_paws_v2/services/navigation_service.dart';
import 'package:happy_paws_v2/services/reminder_service.dart';
import 'package:happy_paws_v2/services/snackbar_service.dart';
import 'package:happy_paws_v2/widgets/app_icon.dart';
import 'package:provider/provider.dart';
import 'package:syncfusion_flutter_calendar/calendar.dart';

class AddRemindersScreen extends StatefulWidget {
  const AddRemindersScreen({super.key});

  static const routeName = "/addNotifications";

  @override
  State<AddRemindersScreen> createState() => _AddRemindersScreenState();
}

class _AddRemindersScreenState extends State<AddRemindersScreen> {
  double deviceHeight = 0;
  double deviceWidth = 0;

  TextEditingController namePetController = TextEditingController();
  TextEditingController descriptionController = TextEditingController();

  GlobalKey<FormState> formKey = GlobalKey<FormState>();

  CalendarController calendarController = CalendarController();

  var date = DateTime.now();
  TimeOfDay? selectedTime;
  DateTime? selectedDate;

  @override
  Widget build(BuildContext context) {
    deviceHeight = MediaQuery.of(context).size.height;
    deviceWidth = MediaQuery.of(context).size.width;
    SnackBarService.instance.buildContext = context;
    final petsDataStream = Provider.of<PetsProvider>(context).petsStream;
    PetsProvider.instance.listenToPetsData(petsDataStream);

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
        title: const Text("Recordatorios"),
        iconTheme: const IconThemeData(color: Color(0xFF93329E)),
      ),
      body: Align(
        alignment: Alignment.center,
        child: addNotifiationsPageUI(context),
      ),
    );
  }

  Widget addNotifiationsPageUI(BuildContext context) {
    return Container(
        alignment: Alignment.center,
        padding: EdgeInsets.symmetric(horizontal: deviceWidth * 0.09),
        child: SingleChildScrollView(
            child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: <Widget>[inputForm(context)],
        )));
  }

  Widget inputForm(BuildContext context) {
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
            namePetTextField(),
            descriptionTextField(),
            calendar(),
            //dateSelector(),
            //timeSelector(context),
            setReminder(),
          ],
        ),
      ),
    );
  }

  Widget calendar() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Padding(
          padding: EdgeInsets.only(bottom: 10),
          child: Text(
            'Escoge una fecha:',
            style: TextStyle(
              fontSize: 20,
              color: Color(0xFF27023E),
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
        SfCalendar(
          controller: calendarController,
          view: CalendarView.month,
          minDate: DateTime.now(),
          onTap: (CalendarTapDetails details) {
            setState(() {
              selectedDate = details.date;
            });
            _showTimePicker(context);
          },
        ),
        const SizedBox(height: 20),
        Text(
          selectedDate != null
              ? 'Fecha seleccionada: ${selectedDate!.toLocal()}'
              : 'Ninguna fecha seleccionada',
          style: const TextStyle(fontSize: 16),
        ),
        Text(
          selectedTime != null
              ? 'Hora seleccionada: ${selectedTime!.format(context)}'
              : 'Ninguna hora seleccionada',
          style: const TextStyle(fontSize: 16),
        ),
      ],
    );
  }

  Widget namePetTextField() {
    final petNames = Provider.of<PetsProvider>(context).petNames;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Padding(
          padding: EdgeInsets.only(bottom: 10),
          child: Text(
            'Destinado a: ',
            style: TextStyle(
              fontSize: 20,
              color: Color(0xFF27023E),
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
        Center(
          child: SizedBox(
            width: deviceWidth * 0.7,
            child: DropdownButtonFormField<String>(
              decoration: const InputDecoration.collapsed(
                hintText: "Selecciona un tipo de mascota",
                fillColor: Colors.red,
              ),
              items: [
                const DropdownMenuItem<String>(
                  value: "Todas mis mascotas",
                  child: Text("Todas mis mascotas"),
                ),
                if (petNames.isNotEmpty)
                  ...petNames.map((petName) {
                    return DropdownMenuItem<String>(
                      value: petName,
                      child: Text(petName),
                    );
                  }),
              ],
              validator: (input) {
                if (input == null) {
                  return 'Ingresa una mascota';
                }
                return null;
              },
              onChanged: (selectedPet) {
                namePetController.text = selectedPet!;
              },
              hint: const Text('Selecciona una mascota'),
            ),
          ),
        ),
      ],
    );
  }

  Widget descriptionTextField() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Padding(
          padding: EdgeInsets.only(bottom: 10),
          child: Text(
            'Descripcion:',
            style: TextStyle(
              fontSize: 20,
              color: Color(0xFF27023E),
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
        Center(
          child: SizedBox(
            width: deviceWidth * 0.7,
            child: TextFormField(
              maxLength: 90,
              controller: descriptionController,
              textAlign: TextAlign.justify,
              autocorrect: false,
              style: const TextStyle(color: Color(0xFF57419D)),
              maxLines: 3,
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
                hintText: "Ingresa una descripción para tu recordatorio",
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

  Future<void> _showTimePicker(BuildContext context) async {
    final newTime = await showTimePicker(
      context: context,
      initialTime: TimeOfDay.now(),
    );

    if (newTime != null) {
      if (selectedDate!.day == DateTime.now().day) {
        if (newTime.hour >= TimeOfDay.now().hour &&
            newTime.minute > TimeOfDay.now().minute) {
          setState(() {
            selectedTime = newTime;
          });
        } else {
          SnackBarService.instance
              .showSnackBar("Por favor, elige una hora posterior", false);
          selectedDate = null;
        }
      } else {
        setState(() {
          selectedTime = newTime;
        });
      }
    } else {
      selectedDate = null;
    }
  }

  Widget setReminder() {
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
          onPressed: () {
            if (formKey.currentState!.validate()) {
              var dateNow = DateTime.now();
              String id = dateNow.month.toString() +
                  dateNow.day.toString() +
                  dateNow.hour.toString() +
                  dateNow.minute.toString() +
                  dateNow.second.toString();

              ReminderData reminder = ReminderData(
                id: id,
                petName: namePetController.text,
                description: descriptionController.text,
                dateTime: Timestamp.fromDate(
                  DateTime(
                    selectedDate!.year,
                    selectedDate!.month,
                    selectedDate!.day,
                    selectedTime!.hour,
                    selectedTime!.minute,
                  ),
                ),
                isEnabled: true,
              );

              setReminderService(reminder).then((isCorrect) {
                if (isCorrect) {
                  DBService.instance.createReminderInDB(reminder).then((_) {
                    SnackBarService.instance
                        .showSnackBar("Recordatorio guardado con exito", true);
                    NavigationService.instance.goBack();
                  });
                } else {
                  // ignore: avoid_print
                  print("algo fallo ");
                }
              });
              // DBService.instance.createReminderInDB(reminder).then(
              //   (_) {
              //     setReminderService(reminder);
              //     SnackBarService.instance
              //         .showSnackBar("Recordatorio guardado con exito", true);
              //     NavigationService.instance.goBack();
              //   },
              // );
            }
          },
          child: const Text(
            'Guardar recordatorio',
            style: TextStyle(color: Colors.white, fontSize: 20),
          )),
    );
  }
}
