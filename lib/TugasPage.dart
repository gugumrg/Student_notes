import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:intl/intl.dart';
import 'package:timezone/timezone.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Task {
  final String title;
  final String content;
  final DateTime scheduledDateTime;

  Task({
    required this.title,
    required this.content,
    required this.scheduledDateTime,
  });
}

class TugasPages extends StatefulWidget {
  const TugasPages({Key? key}) : super(key: key);

  @override
  _TugasPagesState createState() => _TugasPagesState();
}

class _TugasPagesState extends State<TugasPages> {
  late FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin;
  List<Task> tasks = [];
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

  Future<void> initializeSharedPreferences() async {
    preferences = await SharedPreferences.getInstance();
    List<String>? savedTasks = preferences.getStringList('tasks');
    if (savedTasks != null) {
      setState(() {
        tasks = savedTasks.map((taskString) {
          Map<String, dynamic> taskJson =
              TaskExtension.fromJsonString(taskString);
          return Task(
            title: taskJson['title'],
            content: taskJson['content'],
            scheduledDateTime: DateTime.parse(taskJson['scheduledDateTime']),
          );
        }).toList();
      });
    }
  }

  Future<void> saveTasksToSharedPreferences() async {
    List<String> taskStrings =
        tasks.map((task) => task.toJsonString()).toList();
    await preferences.setStringList('tasks', taskStrings);
  }

  void showSnackbar(String message) {
    ScaffoldMessenger.of(context)
        .showSnackBar(SnackBar(content: Text(message)));
  }

  void showAddTaskDialog() {
    TextEditingController titleController = TextEditingController();
    TextEditingController contentController = TextEditingController();
    DateTime selectedDate = DateTime.now();
    TimeOfDay selectedTime = TimeOfDay.now();

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Tambah Tugas'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              TextField(
                controller: titleController,
                style: const TextStyle(color: Colors.black),
                decoration: const InputDecoration(
                  hintText: 'Judul',
                ),
              ),
              const SizedBox(height: 8),
              TextField(
                controller: contentController,
                style: const TextStyle(color: Colors.black),
                decoration: const InputDecoration(
                  hintText: 'Konten',
                ),
              ),
              const SizedBox(height: 8),
              InkWell(
                onTap: () async {
                  DateTime? picked = await showDatePicker(
                    context: context,
                    initialDate: DateTime.now(),
                    firstDate: DateTime.now(),
                    lastDate: DateTime.now().add(const Duration(days: 365)),
                  );
                  if (picked != null) {
                    setState(() {
                      selectedDate = picked;
                    });
                  }
                },
                child: Row(
                  children: [
                    const Icon(Icons.calendar_today),
                    const SizedBox(width: 8),
                    Text(
                      DateFormat('EEE, dd MMM yyyy').format(selectedDate),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 8),
              InkWell(
                onTap: () async {
                  TimeOfDay? picked = await showTimePicker(
                    context: context,
                    initialTime: TimeOfDay.now(),
                  );
                  if (picked != null) {
                    setState(() {
                      selectedTime = picked;
                    });
                  }
                },
                child: Row(
                  children: [
                    const Icon(Icons.access_time),
                    const SizedBox(width: 8),
                    Text(selectedTime.format(context)),
                  ],
                ),
              ),
            ],
          ),
          actions: <Widget>[
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: const Text('Batal'),
            ),
            TextButton(
              onPressed: () {
                String title = titleController.text;
                String content = contentController.text;
                DateTime scheduledDateTime = DateTime(
                  selectedDate.year,
                  selectedDate.month,
                  selectedDate.day,
                  selectedTime.hour,
                  selectedTime.minute,
                );
                Task newTask = Task(
                  title: title,
                  content: content,
                  scheduledDateTime: scheduledDateTime,
                );

                setState(() {
                  tasks.add(newTask);
                });

                saveTasksToSharedPreferences();
                scheduleNotification(
                  title,
                  content,
                  TZDateTime.from(
                    scheduledDateTime,
                    getLocation('Asia/Jakarta'),
                  ),
                );

                showSnackbar('Tugas berhasil ditambahkan');
                Navigator.of(context).pop();
              },
              child: const Text('Simpan'),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Daftar Tugas'),
      ),
      body: ListView.builder(
        itemCount: tasks.length,
        itemBuilder: (context, index) {
          Task task = tasks[index];
          return ListTile(
            title: Text(task.title),
            subtitle: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(task.content),
                const SizedBox(height: 4),
                Text(
                  DateFormat('EEE, dd MMM yyyy HH:mm')
                      .format(task.scheduledDateTime),
                  style: const TextStyle(fontSize: 12),
                ),
              ],
            ),
            trailing: IconButton(
              icon: const Icon(Icons.delete),
              onPressed: () {
                setState(() {
                  tasks.removeAt(index);
                });
                saveTasksToSharedPreferences();
                showSnackbar('Tugas berhasil dihapus');
              },
            ),
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: showAddTaskDialog,
        child: const Icon(Icons.add),
      ),
    );
  }
}

extension TaskExtension on Task {
  String toJsonString() {
    Map<String, dynamic> taskJson = {
      'title': title,
      'content': content,
      'scheduledDateTime': scheduledDateTime.toIso8601String(),
    };
    return taskJson.toString();
  }

  static Map<String, dynamic> fromJsonString(String jsonString) {
    Map<String, dynamic> taskJson = Map<String, dynamic>.from(
      jsonDecode(jsonString),
    );
    return taskJson;
  }
}

void main() {
  runApp(const MaterialApp(
    home: TugasPages(),
  ));
}
