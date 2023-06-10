import 'package:flutter/material.dart';
import 'TugasPage.dart';
import 'JadwalPage.dart';
import 'ChecklistPage.dart';
import 'CatatanPage.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({Key? key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false, // Menghilangkan tulisan "debug"
      title: 'Learn Student',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: Scaffold(
        appBar: AppBar(
          title: const Text('Learn Student'),
        ),
        body: GridView.count(
          crossAxisCount: 2,
          padding: const EdgeInsets.all(20.0),
          mainAxisSpacing: 20.0, // Jarak vertikal antara kotak menu
          crossAxisSpacing: 20.0, // Jarak horizontal antara kotak menu
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
                  MaterialPageRoute(builder: (context) => const CatatanPage()),
                );
              },
            ),
            MenuCard(
              icon: Icons.checklist,
              title: 'Checklist',
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => const ChecklistPage()),
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
    Key? key,
    required this.icon,
    required this.title,
    required this.onTap,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(16.0), // Jarak dalam kotak menu
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(10.0),
          boxShadow: const [
            BoxShadow(
              color: Colors.black12,
              offset: Offset(0, 2),
              blurRadius: 4.0,
            ),
          ],
        ),
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
