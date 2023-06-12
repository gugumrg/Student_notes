import 'package:flutter/material.dart';

class KamisPage extends StatefulWidget {
  static List<Map<String, String>> jadwalKamis = [];

  static void addJadwal(String namaJadwal) {
    jadwalKamis.add({
      'nama': namaJadwal,
    });
  }

  @override
  _KamisPageState createState() => _KamisPageState();
}

class _KamisPageState extends State<KamisPage> {
  TextEditingController _textEditingController = TextEditingController();
  int _selectedIndex = -1;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Kamis'),
      ),
      body: ListView.builder(
        itemCount: KamisPage.jadwalKamis.length,
        itemBuilder: (context, index) {
          final jadwal = KamisPage.jadwalKamis[index];
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
                          KamisPage.jadwalKamis[_selectedIndex]['nama'] =
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
                  KamisPage.jadwalKamis.removeAt(index);
                });
              },
            ),
          );
        },
      ),
    );
  }
}
