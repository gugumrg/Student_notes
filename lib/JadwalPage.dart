import 'package:flutter/material.dart';

class JadwalPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text('Jadwal'),
        ),
        body: const Center(
          child: Text('Halaman Jadwal'),
        ),
        floatingActionButton: FloatingActionButton(
          onPressed: () {
            // Aksi ketika tombol "add" ditekan
          },
          child: const Icon(Icons.add),
        ));
  }
}
