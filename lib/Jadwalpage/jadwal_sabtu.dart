import 'package:flutter/material.dart';

class SabtuPage extends StatefulWidget {
  static List<Map<String, String>> jadwalSabtu = [];

  static void addJadwal(String namaJadwal) {
    jadwalSabtu.add({
      'nama': namaJadwal,
    });
  }

  @override
  _SabtuPageState createState() => _SabtuPageState();
}

class _SabtuPageState extends State<SabtuPage> {
  TextEditingController _textEditingController = TextEditingController();
  int _selectedIndex = -1;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Sabtu'),
      ),
      body: ListView.builder(
        itemCount: SabtuPage.jadwalSabtu.length,
        itemBuilder: (context, index) {
          final jadwal = SabtuPage.jadwalSabtu[index];
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
                          SabtuPage.jadwalSabtu[_selectedIndex]['nama'] =
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
                  SabtuPage.jadwalSabtu.removeAt(index);
                });
              },
            ),
          );
        },
      ),
    );
  }
}
