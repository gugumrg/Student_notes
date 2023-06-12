import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SeninPage extends StatefulWidget {
  static List<String> jadwalSenin = [];

  static Future<void> addJadwal(String namaJadwal) async {
    jadwalSenin.add(namaJadwal);
    await _saveJadwalSenin();
  }

  static Future<void> _saveJadwalSenin() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setStringList('jadwalSenin', jadwalSenin);
  }

  static Future<void> loadJadwalSenin() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    jadwalSenin = prefs.getStringList('jadwalSenin') ?? [];
  }

  static Future<void> deleteJadwalSenin(int index) async {
    jadwalSenin.removeAt(index);
    await _saveJadwalSenin();
  }

  @override
  _SeninPageState createState() => _SeninPageState();
}

class _SeninPageState extends State<SeninPage> {
  @override
  void initState() {
    super.initState();
    SeninPage.loadJadwalSenin();
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
          return ListTile(
            title: Text(SeninPage.jadwalSenin[index]),
            onTap: () {
              // Tambahkan logika pengeditan jadwal
            },
            trailing: IconButton(
              icon: const Icon(Icons.delete),
              onPressed: () {
                setState(() {
                  SeninPage.deleteJadwalSenin(index);
                });
              },
            ),
          );
        },
      ),
    );
  }
}
