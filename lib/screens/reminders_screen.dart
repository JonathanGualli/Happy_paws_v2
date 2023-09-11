import 'package:flutter/material.dart';
import 'package:happy_paws_v2/models/reminder_model.dart';
import 'package:happy_paws_v2/screens/add_reminders_screen.dart';
import 'package:happy_paws_v2/services/db_service.dart';
import 'package:happy_paws_v2/services/navigation_service.dart';
import 'package:happy_paws_v2/services/reminder_service.dart';
import 'package:happy_paws_v2/widgets/no_reminders.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';
// ignore: depend_on_referenced_packages
import 'package:intl/intl.dart';

class RemindersScreen extends StatefulWidget {
  const RemindersScreen({super.key});

  @override
  State<RemindersScreen> createState() => _RemindersScreenState();
}

class _RemindersScreenState extends State<RemindersScreen> {
  double deviceHeight = 0;
  double deviceWidth = 0;

  @override
  Widget build(BuildContext context) {
    deviceHeight = MediaQuery.of(context).size.height;
    deviceWidth = MediaQuery.of(context).size.width;

    return Scaffold(
      backgroundColor: const Color(0xFFF5F5FA),
      appBar: AppBar(
        elevation: 0,
        //leadingWidth: 56,
        titleTextStyle: const TextStyle(
            color: Color(0xFF57419D),
            fontSize: 25,
            fontWeight: FontWeight.bold),
        backgroundColor: const Color(0xFFF5F5FA),
        centerTitle: true,
        title: const Text("Mis Recordatorios"),
      ),
      body: StreamBuilder<List<ReminderData>>(
        stream: DBService.instance.getRemindersStream,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(
              child: LoadingAnimationWidget.fourRotatingDots(
                  color: Colors.purple, size: 30),
            );
          }
          if (snapshot.hasError) {
            return Text("Error ${snapshot.error}");
          }
          List<ReminderData>? remindersData = snapshot.data;

          if (remindersData != null) {
            for (ReminderData reminder in remindersData) {
              if (reminder.dateTime.toDate().isBefore(DateTime.now())) {
                DBService.instance.disableReminder(reminder.id);
              }
            }
          }

          return snapshot.hasData
              ? snapshot.data!.isEmpty
                  ? NoRemindersScreen()
                  : ListView.builder(
                      itemCount: remindersData!.length,
                      itemBuilder: (context, index) {
                        return Dismissible(
                          key: Key(remindersData[index].id),
                          direction: DismissDirection.endToStart,
                          onDismissed: (direction) {
                            DBService.instance
                                .deleteReminder(remindersData[index].id);
                          },
                          confirmDismiss: (direction) async {
                            bool? result = false;
                            result = await showDialog(
                              context: context,
                              builder: (context) {
                                return AlertDialog(
                                  title: const Text(
                                      "¿Estás seguro de que quieres eliminar este recordatorio?"),
                                  actions: [
                                    TextButton(
                                      onPressed: () {
                                        return Navigator.pop(context, false);
                                      },
                                      child: const Text('Cancelar'),
                                    ),
                                    TextButton(
                                      onPressed: () {
                                        cancelReminder(remindersData[index].id);
                                        Navigator.pop(context, true);
                                      },
                                      child: const Text(
                                        'Si, estoy seguro',
                                        style: TextStyle(
                                            color: Color.fromARGB(
                                                255, 255, 118, 108)),
                                      ),
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
                            child: Card(
                              elevation: 2.0,
                              margin: EdgeInsets.symmetric(
                                  horizontal: deviceWidth * 0.05,
                                  vertical: deviceHeight * 0.01),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(8.0),
                              ),
                              child: ListTile(
                                contentPadding: const EdgeInsets.symmetric(
                                    horizontal: 16.0, vertical: 8.0),
                                leading: const Icon(
                                  Icons.alarm,
                                  color: Colors.purple,
                                ),
                                title: Text(
                                  remindersData[index].petName,
                                  style: const TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 20,
                                      color: Colors.deepPurple),
                                ),
                                subtitle: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      remindersData[index].description,
                                      style: const TextStyle(
                                        fontSize: 14.0,
                                      ),
                                    ),
                                    const SizedBox(height: 4.0),
                                    Text(
                                      DateFormat('dd MMMM y - HH:mm a').format(
                                          remindersData[index]
                                              .dateTime
                                              .toDate()), // Formato de fecha y hora legible
                                      style: const TextStyle(
                                        fontSize: 14.0,
                                      ),
                                    ),
                                  ],
                                ),
                                trailing: remindersData[index].isEnabled
                                    ? const Icon(Icons.circle,
                                        color:
                                            Color.fromARGB(255, 133, 224, 72))
                                    : const Icon(Icons.circle,
                                        color:
                                            Color.fromARGB(255, 255, 112, 102)),
                                onTap: () {
                                  showReminder(remindersData[index]);
                                },
                              ),
                            ),
                          ),
                        );
                      },
                    )
              : Center(
                  child: LoadingAnimationWidget.fourRotatingDots(
                      color: Colors.purple, size: 30),
                );
        },
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: const Color(0xFFD9ACF5),
        onPressed: () {
          NavigationService.instance
              .navigatePushName(AddRemindersScreen.routeName);
        },
        child: const Icon(Icons.add),
      ),
    );
  }

  // Dentro del State de tu widget
  void showReminder(ReminderData reminder) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text(
            'Detalles del Recordatorio',
            style: TextStyle(
                color: Colors.deepPurple, fontWeight: FontWeight.bold),
          ),
          content: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              Row(
                children: [
                  const Text(
                    'Para: ',
                    style:
                        TextStyle(fontSize: 18.0, fontWeight: FontWeight.w600),
                  ),
                  Text(
                    reminder.petName,
                    style: const TextStyle(
                      fontSize: 18.0,
                    ),
                  )
                ],
              ),
              Row(
                children: [
                  const Text(
                    'Descripción: ',
                    style:
                        TextStyle(fontSize: 18.0, fontWeight: FontWeight.w600),
                  ),
                  Text(
                    reminder.description,
                    style: const TextStyle(
                      fontSize: 18.0,
                    ),
                  )
                ],
              ),
              const Text('Fecha y Hora: ',
                  style:
                      TextStyle(fontSize: 16.0, fontWeight: FontWeight.w600)),
              Text(
                DateFormat('dd MMMM y - hh:mm a')
                    .format(reminder.dateTime.toDate()),
                style: const TextStyle(fontSize: 16.0),
              )
            ],
          ),
          actions: [
            Center(
              child: Wrap(
                alignment: WrapAlignment.center,
                spacing: 15,
                children: [
                  TextButton(
                    onPressed: () {
                      DBService.instance.deleteReminder(reminder.id.toString());
                      cancelReminder(reminder.id);

                      Navigator.of(context).pop();
                    },
                    child: const Text('Borrar'),
                  ),
                  // TextButton(
                  //   onPressed: () {
                  //     // Acción para editar el recordatorio
                  //     Navigator.of(context).pop();
                  //   },
                  //   child: const Text('Editar'),
                  // ),
                  TextButton(
                    onPressed: () {
                      DBService.instance.disableReminder(reminder.id);
                      cancelReminder(reminder.id);
                      Navigator.of(context).pop();
                    },
                    child: const Text('Deshabilitar'),
                  ),
                ],
              ),
            ),
            Center(
              child: TextButton(
                onPressed: () {
                  Navigator.of(context).pop();
                },
                child: const Text(
                  'Cerrar',
                  style: TextStyle(color: Color.fromARGB(255, 255, 101, 90)),
                ),
              ),
            ),
          ],
        );
      },
    );
  }
}
