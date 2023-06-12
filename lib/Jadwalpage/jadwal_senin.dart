import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SeninPage extends StatefulWidget {
  static List<Map<String, dynamic>> jadwalSenin = [];

  const SeninPage({Key? key}) : super(key: key);

  static void addJadwal(String namaJadwal, String jam) {
    jadwalSenin.add({
      'nama': namaJadwal,
      'jam': jam,
    });
  }

  @override
  _SeninPageState createState() => _SeninPageState();
}

class _SeninPageState extends State<SeninPage> {
  TextEditingController _textEditingController = TextEditingController();
  TextEditingController _jamEditingController = TextEditingController();
  int _selectedIndex = -1;
  FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
      FlutterLocalNotificationsPlugin();

  @override
  void initState() {
    super.initState();
    initializeNotifications();
    loadJadwalSenin();
  }

  void initializeNotifications() async {
    var initializationSettingsAndroid =
        const AndroidInitializationSettings('@mipmap/ic_launcher');
    var initializationSettings =
        InitializationSettings(android: initializationSettingsAndroid);
    await flutterLocalNotificationsPlugin.initialize(initializationSettings);
  }

  Future<void> showNotification(String title, String body) async {
    var androidPlatformChannelSpecifics = const AndroidNotificationDetails(
      'Learn Student',
      'Tugas Hampir melewati Deadline, Segera Kerjakan',
      importance: Importance.max,
      priority: Priority.high,
    );
    var platformChannelSpecifics =
        NotificationDetails(android: androidPlatformChannelSpecifics);
    await flutterLocalNotificationsPlugin.show(
        0, title, body, platformChannelSpecifics,
        payload: 'notification_payload');
  }

  Future<void> loadJadwalSenin() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      List<String>? jadwalSeninString = prefs.getStringList('jadwalSenin');
      SeninPage.jadwalSenin = jadwalSeninString?.map((jadwal) {
            Map<String, dynamic> jadwalMap = Map<String, dynamic>.from(
                jadwal.split(',').asMap().map((index, value) {
              if (index == 0) {
                return MapEntry('nama', value);
              } else {
                return MapEntry('jam', value);
              }
            }));
            return jadwalMap;
          }).toList() ??
          [];
    });
  }

  Future<void> saveJadwalSenin() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    List<String> jadwalSeninString = SeninPage.jadwalSenin
        .map((jadwal) => '${jadwal['nama']},${jadwal['jam']}')
        .toList();
    await prefs.setStringList('jadwalSenin', jadwalSeninString);
  }

  void addJadwalToList(String namaJadwal, String jamJadwal) {
    setState(() {
      SeninPage.addJadwal(namaJadwal, jamJadwal);
    });
    saveJadwalSenin();
  }

  void refreshJadwalList() {
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Senin'),
      ),
      body: ListView.builder(
        itemCount: SeninPage.jadwalSenin.length,
        itemBuilder: (context, index) {
          final jadwal = SeninPage.jadwalSenin[index];
          final namaJadwal = jadwal['nama'];
          final jamJadwal = jadwal['jam'];

          return Card(
            elevation: 2.0,
            child: ListTile(
              title: Text(
                namaJadwal ?? '',
                style: const TextStyle(
                  fontWeight: FontWeight.bold,
                ),
              ),
              subtitle: Text(
                jamJadwal ?? '',
                style: const TextStyle(
                  color: Colors.grey,
                ),
              ),
              onTap: () {
                setState(() {
                  _textEditingController.text = namaJadwal ?? '';
                  _jamEditingController.text = jamJadwal ?? '';
                  _selectedIndex = index;
                });
                showDialog(
                  context: context,
                  builder: (context) => AlertDialog(
                    title: const Text('Edit Jadwal'),
                    content: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        TextFormField(
                          controller: _textEditingController,
                          decoration: const InputDecoration(
                            labelText: 'Nama Jadwal',
                          ),
                        ),
                        TextFormField(
                          controller: _jamEditingController,
                          decoration: const InputDecoration(
                            labelText: 'Jam',
                          ),
                        ),
                      ],
                    ),
                    actions: [
                      TextButton(
                        onPressed: () {
                          setState(() {
                            SeninPage.jadwalSenin[_selectedIndex]['nama'] =
                                _textEditingController.text;
                            SeninPage.jadwalSenin[_selectedIndex]['jam'] =
                                _jamEditingController.text;
                          });
                          saveJadwalSenin();
                          Navigator.pop(context);
                        },
                        child: const Text('Simpan'),
                      ),
                      TextButton(
                        onPressed: () {
                          Navigator.pop(context);
                        },
                        child: const Text('Batal'),
                      ),
                    ],
                  ),
                );
              },
              trailing: IconButton(
                icon: const Icon(Icons.delete),
                onPressed: () {
                  setState(() {
                    SeninPage.jadwalSenin.removeAt(index);
                  });
                  saveJadwalSenin();
                },
              ),
            ),
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => JadwalPage(callback: addJadwalToList),
            ),
          );
        },
        child: const Icon(Icons.add),
      ),
    );
  }
}

class JadwalPage extends StatelessWidget {
  final Function callback;
  final TextEditingController _namaJadwalController = TextEditingController();
  final TextEditingController _jamJadwalController = TextEditingController();

  JadwalPage({required this.callback});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Tambah Jadwal'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            TextFormField(
              controller: _namaJadwalController,
              decoration: const InputDecoration(
                labelText: 'Nama Jadwal',
              ),
            ),
            TextFormField(
              controller: _jamJadwalController,
              decoration: const InputDecoration(
                labelText: 'Jam',
              ),
            ),
            ElevatedButton(
              onPressed: () {
                String namaJadwal = _namaJadwalController.text;
                String jamJadwal = _jamJadwalController.text;
                callback(namaJadwal, jamJadwal);
                Navigator.pop(context);
              },
              child: const Text('Tambah'),
            ),
          ],
        ),
      ),
    );
  }
}
