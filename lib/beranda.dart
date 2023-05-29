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
      title: 'Home',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: Scaffold(
        appBar: AppBar(
          title: Text('Home'),
        ),
        body: GridView.count(
          crossAxisCount: 2,
          padding: EdgeInsets.all(20.0),
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
                  MaterialPageRoute(builder: (context) => TugasPages()),
                );
              },
            ),
            MenuCard(
              icon: Icons.note,
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
            SizedBox(height: 8.0),
            Text(
              title,
              style: TextStyle(
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
