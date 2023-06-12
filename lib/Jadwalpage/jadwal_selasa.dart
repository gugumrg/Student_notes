import 'package:flutter/material.dart';

class SelasaPage extends StatefulWidget {
  static List<Map<String, String>> jadwalSelasa = [];

  static void addJadwal(String namaJadwal) {
    jadwalSelasa.add({
      'nama': namaJadwal,
    });
  }

  @override
  _SelasaPageState createState() => _SelasaPageState();
}

class _SelasaPageState extends State<SelasaPage> {
  TextEditingController _textEditingController = TextEditingController();
  int _selectedIndex = -1;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Selasa'),
      ),
      body: ListView.builder(
        itemCount: SelasaPage.jadwalSelasa.length,
        itemBuilder: (context, index) {
          final jadwal = SelasaPage.jadwalSelasa[index];
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
                          SelasaPage.jadwalSelasa[_selectedIndex]['nama'] =
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
                  SelasaPage.jadwalSelasa.removeAt(index);
                });
              },
            ),
          );
        },
      ),
    );
  }
}
