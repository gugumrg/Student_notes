import 'package:flutter/material.dart';
import 'TugasPage.dart';
import 'JadwalPage.dart';
import 'ChecklistPage.dart';
import 'CatatanPage.dart';

class HomeScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false, // Menghilangkan tulisan "debug"
      title: 'Student Notes',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: Scaffold(
        appBar: AppBar(
          title: const Text('Student Notes'),
        ),
        body: GridView.count(
          crossAxisCount: 2,
          padding: const EdgeInsets.all(20.0),
          children: [
            MenuCard(
              icon: Icons.schedule,
              title: 'Jadwal',
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => JadwalPage()),
                );
              },
            ),
            MenuCard(
              icon: Icons.assignment,
              title: 'Tugas',
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const TugasPages()),
                );
              },
            ),
            MenuCard(
              icon: Icons.edit_note,
              title: 'Catatan',
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => CatatanPage()),
                );
              },
            ),
            MenuCard(
              icon: Icons.checklist,
              title: 'Checklist',
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => ChecklistPage()),
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}

class MenuCard extends StatelessWidget {
  final IconData icon;
  final String title;
  final VoidCallback onTap;

  const MenuCard({
    required this.icon,
    required this.title,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Card(
        elevation: 2.0,
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
              title,
              style: const TextStyle(
                fontSize: 16.0,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
