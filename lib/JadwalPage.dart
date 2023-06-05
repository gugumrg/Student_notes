import 'package:flutter/material.dart';

class JadwalPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Jadwal'),
      ),
      body: GridView.count(
        crossAxisCount: 2,
        padding: EdgeInsets.all(20.0),
        children: const [
          DayCard(day: 'Senin', icon: Icons.calendar_today),
          DayCard(day: 'Selasa', icon: Icons.calendar_today),
          DayCard(day: 'Rabu', icon: Icons.calendar_today),
          DayCard(day: 'Kamis', icon: Icons.calendar_today),
          DayCard(day: 'Jumat', icon: Icons.calendar_today),
          DayCard(day: 'Sabtu', icon: Icons.calendar_today),
        ],
      ),
    );
  }
}

class DayCard extends StatelessWidget {
  final String day;
  final IconData icon;

  const DayCard({required this.day, required this.icon});

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 2.0,
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
            style: const TextStyle(
              fontSize: 18.0,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }
}
