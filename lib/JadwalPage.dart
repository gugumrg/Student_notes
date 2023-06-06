import 'package:flutter/material.dart';
import 'Jadwalpage/jadwal_senin.dart';
import 'Jadwalpage/jadwal_selasa.dart';
import 'Jadwalpage/jadwal_rabu.dart';
import 'Jadwalpage/jadwal_kamis.dart';
import 'Jadwalpage/jadwal_jumat.dart';
import 'Jadwalpage/jadwal_sabtu.dart';

class JadwalPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Jadwal'),
      ),
      body: GridView.count(
        crossAxisCount: 2,
        padding: const EdgeInsets.all(20.0),
        children: [
          DayCard(
            day: 'Senin',
            icon: Icons.calendar_today,
            page: SeninPage(),
          ),
          DayCard(
            day: 'Selasa',
            icon: Icons.calendar_today,
            page: SelasaPage(),
          ),
          DayCard(
            day: 'Rabu',
            icon: Icons.calendar_today,
            page: RabuPage(),
          ),
          DayCard(
            day: 'Kamis',
            icon: Icons.calendar_today,
            page: KamisPage(),
          ),
          DayCard(
            day: 'Jumat',
            icon: Icons.calendar_today,
            page: JumatPage(),
          ),
          DayCard(
            day: 'Sabtu',
            icon: Icons.calendar_today,
            page: SabtuPage(),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          showDialog(
            context: context,
            builder: (context) => AddJadwalDialog(),
          );
        },
        child: const Icon(Icons.add),
      ),
    );
  }
}

class DayCard extends StatelessWidget {
  final String day;
  final IconData icon;
  final Widget page;

  const DayCard({required this.day, required this.icon, required this.page});

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 2.0,
      child: InkWell(
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => page),
          );
        },
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              icon,
              size: 48.0,
              color: Colors.blue,
            ),
            const SizedBox(height: 8.0),
            Text(
              day,
              style: const TextStyle(
                fontSize: 18.0,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class AddJadwalDialog extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text('Tambah Jadwal'),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          TextFormField(
            decoration: const InputDecoration(labelText: 'Nama Jadwal'),
          ),
          const SizedBox(height: 16.0),
          DropdownButtonFormField<String>(
            decoration: const InputDecoration(labelText: 'Hari'),
            items: <String>[
              'Senin',
              'Selasa',
              'Rabu',
              'Kamis',
              'Jumat',
              'Sabtu'
            ].map<DropdownMenuItem<String>>((String value) {
              return DropdownMenuItem<String>(
                value: value,
                child: Text(value),
              );
            }).toList(),
            onChanged: (String? newValue) {
              // Kode untuk memilih hari
            },
          ),
          const SizedBox(height: 16.0),
          Row(
            children: [
              Expanded(
                child: TextFormField(
                  decoration: const InputDecoration(labelText: 'Jam'),
                ),
              ),
              const SizedBox(width: 8.0),
              IconButton(
                onPressed: () {
                  // Kode untuk memilih jam
                },
                icon: const Icon(Icons.access_time),
              ),
            ],
          ),
        ],
      ),
      actions: [
        TextButton(
          onPressed: () {
            // Kode untuk menyimpan jadwal baru
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
    );
  }
}
