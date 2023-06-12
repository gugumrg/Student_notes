import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
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

class AddJadwalDialog extends StatefulWidget {
  @override
  _AddJadwalDialogState createState() => _AddJadwalDialogState();
}

class _AddJadwalDialogState extends State<AddJadwalDialog> {
  late String selectedTime;
  String? selectedDay;
  String? namaJadwal;

  @override
  void initState() {
    super.initState();
    selectedTime = '';
  }

  Future<void> showTimePickerDialog() async {
    TimeOfDay? pickedTime = await showTimePicker(
      context: context,
      initialTime: TimeOfDay.now(),
    );

    if (pickedTime != null) {
      setState(() {
        selectedTime = pickedTime.format(context);
      });
    }
  }

  void addJadwalToDay() {
    if (namaJadwal != null && selectedDay != null) {
      switch (selectedDay) {
        case 'Senin':
          SeninPage.addJadwal(namaJadwal!, selectedTime);
          break;
        case 'Selasa':
          SelasaPage.addJadwal(namaJadwal!, selectedTime);
          break;
        case 'Rabu':
          RabuPage.addJadwal(namaJadwal!, selectedTime);
          break;
        case 'Kamis':
          KamisPage.addJadwal(namaJadwal!, selectedTime);
          break;
        case 'Jumat':
          JumatPage.addJadwal(namaJadwal!, selectedTime);
          break;
        case 'Sabtu':
          SabtuPage.addJadwal(namaJadwal!, selectedTime);
          break;
      }

      Navigator.pop(context);
    }
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text('Tambah Jadwal'),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          TextFormField(
            decoration: const InputDecoration(labelText: 'Nama Jadwal'),
            onChanged: (value) {
              setState(() {
                namaJadwal = value;
              });
            },
          ),
          const SizedBox(height: 16.0),
          DropdownButtonFormField<String>(
            decoration: const InputDecoration(labelText: 'Hari'),
            value: selectedDay,
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
              setState(() {
                selectedDay = newValue;
              });
            },
          ),
          const SizedBox(height: 16.0),
          Row(
            children: [
              Expanded(
                child: TextFormField(
                  decoration: const InputDecoration(labelText: 'Jam'),
                  readOnly: true,
                  controller: TextEditingController(text: selectedTime),
                  onTap: showTimePickerDialog,
                ),
              ),
              const SizedBox(width: 8.0),
              IconButton(
                onPressed: showTimePickerDialog,
                icon: const Icon(Icons.access_time),
              ),
            ],
          ),
        ],
      ),
      actions: [
        TextButton(
          onPressed: addJadwalToDay,
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
