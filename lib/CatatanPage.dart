import 'package:flutter/material.dart';

class CatatanPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text('Catatan'),
        ),
        body: const Center(
          child: Text('Halaman Catatan'),
        ),
        floatingActionButton: FloatingActionButton(
          onPressed: () {
            // Aksi ketika tombol "add" ditekan
          },
          child: const Icon(Icons.add),
        ));
  }
}
