import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:timezone/timezone.dart' as tz;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';

class Task {
  String title;
  String content;
  DateTime scheduledDateTime;

  Task({
    required this.title,
    required this.content,
    required this.scheduledDateTime,
  });

  factory Task.fromJson(Map<String, dynamic> json) {
    return Task(
      title: json['title'],
      content: json['content'],
      scheduledDateTime: DateTime.parse(json['scheduledDateTime']),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'title': title,
      'content': content,
      'scheduledDateTime': scheduledDateTime.toIso8601String(),
    };
  }
}

class TugasPage extends StatefulWidget {
  const TugasPage({Key? key}) : super(key: key);

  @override
  _TugasPageState createState() => _TugasPageState();
}

class _TugasPageState extends State<TugasPage> {
  List<Task> tasks = [];
  late SharedPreferences preferences;
  FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
      FlutterLocalNotificationsPlugin();

  @override
  void initState() {
    super.initState();
    initializeSharedPreferences();
    initializeNotifications();
  }

  Future<void> initializeSharedPreferences() async {
    preferences = await SharedPreferences.getInstance();
    List<String>? savedTasks = preferences.getStringList('tasks');
    if (savedTasks != null) {
      setState(() {
        tasks = savedTasks.map((taskString) {
          return Task.fromJson(jsonDecode(taskString));
        }).toList();
      });
    }
  }

  Future<void> saveTasksToSharedPreferences() async {
    List<String> taskList = tasks.map((task) {
      return jsonEncode(task.toJson());
    }).toList();
    await preferences.setStringList('tasks', taskList);
  }

  Future<void> initializeNotifications() async {
    const AndroidInitializationSettings initializationSettingsAndroid =
        AndroidInitializationSettings('app_icon');
    final InitializationSettings initializationSettings =
        const InitializationSettings(android: initializationSettingsAndroid);
    await flutterLocalNotificationsPlugin.initialize(initializationSettings);
  }

  Future<void> showNotification(Task task) async {
    const AndroidNotificationDetails androidPlatformChannelSpecifics =
        AndroidNotificationDetails(
      'Learn Student',
      'Tugas Akan Melewati Deadline',
      importance: Importance.high,
      priority: Priority.high,
    );
    const NotificationDetails platformChannelSpecifics =
        NotificationDetails(android: androidPlatformChannelSpecifics);
    await flutterLocalNotificationsPlugin.show(
      0,
      task.title,
      task.content,
      platformChannelSpecifics,
      payload: task.toJson().toString(),
    );
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

                showSnackbar('Tugas berhasil ditambahkan');
                Navigator.of(context).pop();

                scheduleNotification(newTask);
              },
              child: const Text('Simpan'),
            ),
          ],
        );
      },
    );
  }

  Future<void> scheduleNotification(Task task) async {
    final tz.TZDateTime scheduledDateTime = tz.TZDateTime.from(
      task.scheduledDateTime,
      tz.local,
    );

    await flutterLocalNotificationsPlugin.zonedSchedule(
      0,
      task.title,
      task.content,
      scheduledDateTime,
      const NotificationDetails(
        android: AndroidNotificationDetails(
          'your channel name',
          'your channel description',
          importance: Importance.high,
          priority: Priority.high,
        ),
      ),
      androidAllowWhileIdle: true,
      uiLocalNotificationDateInterpretation:
          UILocalNotificationDateInterpretation.absoluteTime,
    );
  }

  Future<void> cancelNotification(Task task) async {
    await flutterLocalNotificationsPlugin.cancel(0);
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
          return Card(
            elevation: 4,
            margin: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
            child: ListTile(
              title: Text(
                task.title,
                style: const TextStyle(
                  fontWeight: FontWeight.bold,
                ),
              ),
              subtitle: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    task.content,
                    style: TextStyle(
                      color: Colors.grey[700],
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    DateFormat('EEE, dd MMM yyyy HH:mm')
                        .format(task.scheduledDateTime),
                    style: TextStyle(
                      fontSize: 12,
                      color: Colors.grey[600],
                    ),
                  ),
                ],
              ),
              onTap: () {
                showDialog(
                  context: context,
                  builder: (BuildContext context) {
                    TextEditingController titleController =
                        TextEditingController(text: task.title);
                    TextEditingController contentController =
                        TextEditingController(text: task.content);
                    DateTime selectedDate = task.scheduledDateTime;
                    TimeOfDay selectedTime =
                        TimeOfDay.fromDateTime(task.scheduledDateTime);

                    return AlertDialog(
                      title: const Text('Edit Tugas'),
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
                                initialDate: selectedDate,
                                firstDate: DateTime.now(),
                                lastDate: DateTime.now()
                                    .add(const Duration(days: 365)),
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
                                  DateFormat('EEE, dd MMM yyyy')
                                      .format(selectedDate),
                                ),
                              ],
                            ),
                          ),
                          const SizedBox(height: 8),
                          InkWell(
                            onTap: () async {
                              TimeOfDay? picked = await showTimePicker(
                                context: context,
                                initialTime:
                                    TimeOfDay.fromDateTime(selectedDate),
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

                            setState(() {
                              task.title = title;
                              task.content = content;
                              task.scheduledDateTime = scheduledDateTime;
                            });

                            saveTasksToSharedPreferences();

                            showSnackbar('Tugas berhasil diperbarui');
                            Navigator.of(context).pop();

                            cancelNotification(task);
                            scheduleNotification(task);
                          },
                          child: const Text('Simpan'),
                        ),
                      ],
                    );
                  },
                );
              },
              onLongPress: () {
                showDialog(
                  context: context,
                  builder: (BuildContext context) {
                    return AlertDialog(
                      title: const Text('Hapus Tugas'),
                      content:
                          const Text('Anda yakin ingin menghapus tugas ini?'),
                      actions: <Widget>[
                        TextButton(
                          onPressed: () {
                            Navigator.of(context).pop();
                          },
                          child: const Text('Batal'),
                        ),
                        TextButton(
                          onPressed: () {
                            setState(() {
                              tasks.remove(task);
                            });

                            saveTasksToSharedPreferences();

                            showSnackbar('Tugas berhasil dihapus');
                            Navigator.of(context).pop();

                            cancelNotification(task);
                          },
                          child: const Text('Hapus'),
                        ),
                      ],
                    );
                  },
                );
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

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Tugas App',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      home: const TugasPage(),
    );
  }
}
