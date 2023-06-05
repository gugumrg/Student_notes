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
        title: Text('Jadwal'),
      ),
      body: GridView.count(
        crossAxisCount: 2,
        padding: EdgeInsets.all(20.0),
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
            SizedBox(height: 8.0),
            Text(
              day,
              style: TextStyle(
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
