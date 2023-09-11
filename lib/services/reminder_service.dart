// ignore_for_file: avoid_print

import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:happy_paws_v2/models/reminder_model.dart';
import 'package:happy_paws_v2/services/snackbar_service.dart';
import 'package:timezone/data/latest_all.dart' as tz;
import 'package:timezone/timezone.dart' as tz;

final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
    FlutterLocalNotificationsPlugin();

Future<void> initNotifications() async {
  const AndroidInitializationSettings initializationSettingsAndroid =
      AndroidInitializationSettings(
          'app_icon'); //entre los parentesis es el nombre del icóno que tendra nuestra notificación
  const DarwinInitializationSettings initializationSettingsIOS =
      DarwinInitializationSettings();

  const InitializationSettings initializationSettings = InitializationSettings(
      android: initializationSettingsAndroid, iOS: initializationSettingsIOS);

  await flutterLocalNotificationsPlugin.initialize(initializationSettings);
}

var counter = 0;

Future<bool> setReminderService(ReminderData reminder) async {
  tz.initializeTimeZones();
  tz.setLocalLocation(tz.getLocation("America/Guayaquil"));
  bool isCorrect = true;
  const AndroidNotificationDetails androidNotificationDetails =
      AndroidNotificationDetails("channelId", "happy_paws_channel",
          priority: Priority.max, importance: Importance.max);

  const DarwinNotificationDetails darwinNotificationDetails =
      DarwinNotificationDetails();

  const NotificationDetails notificationDetails = NotificationDetails(
    android: androidNotificationDetails,
    iOS: darwinNotificationDetails,
  );
  counter++;
  try {
    await flutterLocalNotificationsPlugin.zonedSchedule(
      int.parse(reminder.id),
      reminder.petName,
      reminder.description,
      tz.TZDateTime(
        tz.local, // Zona horaria local
        reminder.dateTime.toDate().year, // Año
        reminder.dateTime.toDate().month, // Mes
        reminder.dateTime.toDate().day, // Día
        reminder.dateTime.toDate().hour, // Hora
        reminder.dateTime.toDate().minute, // Minuto
      ),
      notificationDetails,
      androidScheduleMode: AndroidScheduleMode.exactAllowWhileIdle,
      uiLocalNotificationDateInterpretation:
          UILocalNotificationDateInterpretation.absoluteTime,
    );
    isCorrect = true;
    return isCorrect;
    //SnackBarService.instance.showSnackBar("Alarma programada con exito", true);
  } catch (e) {
    isCorrect = false;

    SnackBarService.instance
        .showSnackBar("Ha ocurrido un error, intentalo de nuevo", false);
    print(e);
    return isCorrect;
  }
}

Future<void> cancelReminder(String reminderId) async {
  await flutterLocalNotificationsPlugin.cancel(int.parse(reminderId));
}

Future<void> getAllScheduledReminders() async {
  final List<PendingNotificationRequest> pendingNotifications =
      await flutterLocalNotificationsPlugin.pendingNotificationRequests();

  for (final notification in pendingNotifications) {
    print('ID: ${notification.id}');
    print('Título: ${notification.title}');
    print('Cuerpo: ${notification.body}');
    print('------------------');
  }
}

Future<void> cancelAllReminders() async {
  await flutterLocalNotificationsPlugin.cancelAll();
}



  //   await flutterLocalNotificationsPlugin.show(
  //   1,
  //   "title de notificación",
  //   "este es el body",
  //   notificationDetails,
  //   payload: "probemos a ver que hace esto",
  // );
