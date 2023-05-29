import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:intl/intl.dart';
import 'package:flutter_native_timezone/flutter_native_timezone.dart';
import 'package:timezone/timezone.dart';
import 'package:shared_preferences/shared_preferences.dart';

class TugasPages extends StatefulWidget {
  const TugasPages({Key? key}) : super(key: key);

  @override
  _TugasPagesState createState() => _TugasPagesState();
}

class _TugasPagesState extends State<TugasPages> {
  late FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin;
  TextEditingController titleController = TextEditingController();
  TextEditingController contentController = TextEditingController();
  DateTime selectedDate = DateTime.now();
  TimeOfDay selectedTime = TimeOfDay.now();
  late SharedPreferences preferences;

  @override
  void initState() {
    super.initState();
    flutterLocalNotificationsPlugin = FlutterLocalNotificationsPlugin();
    initializeNotifications();
    initializeSharedPreferences();
  }

  Future<void> initializeNotifications() async {
    var initializationSettingsAndroid =
        const AndroidInitializationSettings('@mipmap/ic_launcher');
    var initializationSettings = InitializationSettings(
      android: initializationSettingsAndroid,
    );
    await flutterLocalNotificationsPlugin.initialize(initializationSettings);
  }

  Future<void> scheduleNotification(
      String title, String content, TZDateTime scheduledDateTime) async {
    var androidPlatformChannelSpecifics = const AndroidNotificationDetails(
      'channel_id',
      'channel_name',
      importance: Importance.max,
      priority: Priority.high,
    );
    var platformChannelSpecifics = NotificationDetails(
      android: androidPlatformChannelSpecifics,
    );

    await flutterLocalNotificationsPlugin.zonedSchedule(
      0,
      title,
      content,
      scheduledDateTime,
      platformChannelSpecifics,
      androidAllowWhileIdle: true,
      uiLocalNotificationDateInterpretation:
          UILocalNotificationDateInterpretation.absoluteTime,
    );
  }

  void showSnackbar(String message) {
    ScaffoldMessenger.of(context)
        .showSnackBar(SnackBar(content: Text(message)));
  }

  Future<void> initializeSharedPreferences() async {
    preferences = await SharedPreferences.getInstance();
    String? savedTitle = preferences.getString('title');
    String? savedContent = preferences.getString('content');
    if (savedTitle != null) {
      titleController.text = savedTitle;
    }
    if (savedContent != null) {
      contentController.text = savedContent;
    }
  }

  Future<void> saveToSharedPreferences() async {
    await preferences.setString('title', titleController.text);
    await preferences.setString('content', contentController.text);
  }

  Future<void> _selectDate(BuildContext context) async {
    final DateTime? pickedDate = await showDatePicker(
      context: context,
      initialDate: selectedDate,
      firstDate: DateTime.now(),
      lastDate: DateTime(2100),
    );
    if (pickedDate != null && pickedDate != selectedDate) {
      setState(() {
        selectedDate = pickedDate;
      });
    }
  }

  Future<void> _selectTime(BuildContext context) async {
    final TimeOfDay? pickedTime = await showTimePicker(
      context: context,
      initialTime: selectedTime,
    );
    if (pickedTime != null && pickedTime != selectedTime) {
      setState(() {
        selectedTime = pickedTime;
      });
    }
  }

  TZDateTime _getZonedScheduledDateTime() {
    final scheduledDateTime = TZDateTime(
      getLocation('Asia/Jakarta'), // Ganti dengan zona waktu yang sesuai
      selectedDate.year,
      selectedDate.month,
      selectedDate.day,
      selectedTime.hour,
      selectedTime.minute,
    );
    return scheduledDateTime;
  }

  void createNotification() {
    if (selectedTime == null) {
      showSnackbar('Pilih Tanggal');
      return;
    }

    if (titleController.text.isEmpty || contentController.text.isEmpty) {
      showSnackbar('Judul dan Deskripsi harus diisi');
      return;
    }

    TZDateTime scheduledDateTime = _getZonedScheduledDateTime();

    if (scheduledDateTime.isBefore(DateTime.now())) {
      showSnackbar('Pilih tanggal');
      return;
    }

    String formattedDateTime =
        DateFormat('dd-MM-yyyy – HH:mm').format(scheduledDateTime);
    scheduleNotification(
        titleController.text, contentController.text, scheduledDateTime);
    showSnackbar('Notification set for $formattedDateTime');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Tugas'),
      ),
      body: Container(
        color: const Color.fromARGB(255, 172, 89, 59),
        padding: MediaQuery.of(context).padding,
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: <Widget>[
              Padding(
                padding: const EdgeInsets.all(10.0),
                child: TextField(
                  controller: titleController,
                  style: const TextStyle(color: Colors.white),
                  decoration: const InputDecoration(
                    hintText: 'Judul',
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(10.0),
                child: TextField(
                  controller: contentController,
                  style: const TextStyle(color: Colors.white),
                  maxLines: null,
                  keyboardType: TextInputType.multiline,
                  decoration: const InputDecoration(
                    hintText: 'Deskripsi',
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(10.0),
                child: ElevatedButton(
                  onPressed: () => _selectDate(context),
                  child: Text(selectedDate != null
                      ? 'Pilih tanggal: \n ${DateFormat('dd-MM-yyyy').format(selectedDate)}'
                      : 'Pilih tanggal'),
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(10.0),
                child: ElevatedButton(
                  onPressed: () => _selectTime(context),
                  child: Text(selectedTime != null
                      ? 'Pilih Jam: \n ${selectedTime.format(context)}'
                      : 'Pilih Jam'),
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(10.0),
                child: ElevatedButton(
                  onPressed: () {
                    createNotification();
                    saveToSharedPreferences();
                  },
                  child: const Text('Atur Notifikasi'),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
