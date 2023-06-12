import 'package:flutter/material.dart';

class RabuPage extends StatefulWidget {
  static List<Map<String, String>> jadwalRabu = [];

  static void addJadwal(String namaJadwal) {
    jadwalRabu.add({
      'nama': namaJadwal,
    });
  }

  @override
  _RabuPageState createState() => _RabuPageState();
}

class _RabuPageState extends State<RabuPage> {
  TextEditingController _textEditingController = TextEditingController();
  int _selectedIndex = -1;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Rabu'),
      ),
      body: ListView.builder(
        itemCount: RabuPage.jadwalRabu.length,
        itemBuilder: (context, index) {
          final jadwal = RabuPage.jadwalRabu[index];
          final namaJadwal = jadwal['nama'];

          return ListTile(
            title: Text(namaJadwal!),
            onTap: () {
              setState(() {
                _textEditingController.text = namaJadwal!;
                _selectedIndex = index;
              });
              showDialog(
                context: context,
                builder: (context) => AlertDialog(
                  title: const Text('Edit Jadwal'),
                  content: TextFormField(
                    controller: _textEditingController,
                    decoration: const InputDecoration(
                      labelText: 'Nama Jadwal',
                    ),
                  ),
                  actions: [
                    TextButton(
                      onPressed: () {
                        setState(() {
                          RabuPage.jadwalRabu[_selectedIndex]['nama'] =
                              _textEditingController.text;
                        });
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
                ),
              );
            },
            trailing: IconButton(
              icon: const Icon(Icons.delete),
              onPressed: () {
                setState(() {
                  RabuPage.jadwalRabu.removeAt(index);
                });
              },
            ),
          );
        },
      ),
    );
  }
}
