import 'package:flutter/material.dart';

class CatatanPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text('Catatan'),
        ),
        body: Center(
          child: Text('Halaman Catatan'),
        ),
        floatingActionButton: FloatingActionButton(
          onPressed: () {
            // Aksi ketika tombol "add" ditekan
          },
          child: Icon(Icons.add),
        ));
  }
}
