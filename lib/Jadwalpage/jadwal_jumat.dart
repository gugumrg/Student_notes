import 'package:flutter/material.dart';

class JumatPage extends StatefulWidget {
  static List<Map<String, String>> jadwalJumat = [];

  static void addJadwal(String namaJadwal) {
    jadwalJumat.add({
      'nama': namaJadwal,
    });
  }

  @override
  _JumatPageState createState() => _JumatPageState();
}

class _JumatPageState extends State<JumatPage> {
  TextEditingController _textEditingController = TextEditingController();
  int _selectedIndex = -1;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Jumat'),
      ),
      body: ListView.builder(
        itemCount: JumatPage.jadwalJumat.length,
        itemBuilder: (context, index) {
          final jadwal = JumatPage.jadwalJumat[index];
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
                          JumatPage.jadwalJumat[_selectedIndex]['nama'] =
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
                  JumatPage.jadwalJumat.removeAt(index);
                });
              },
            ),
          );
        },
      ),
    );
  }
}
