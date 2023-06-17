import 'package:flutter/material.dart';

class SeninPage extends StatefulWidget {
  static List<Map<String, String>> jadwalSenin = [];

  static void addJadwal(String namaJadwal, String jamJadwal) {
    jadwalSenin.add({
      'nama': namaJadwal,
      'jam': jamJadwal,
    });
  }

  @override
  _SeninPageState createState() => _SeninPageState();
}

class _SeninPageState extends State<SeninPage> {
  TextEditingController _textEditingController = TextEditingController();
  TextEditingController _jamEditingController = TextEditingController();
  int _selectedIndex = -1;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Senin'),
      ),
      body: ListView.builder(
        itemCount: SeninPage.jadwalSenin.length,
        itemBuilder: (context, index) {
          final jadwal = SeninPage.jadwalSenin[index];
          final namaJadwal = jadwal['nama'];
          final jamJadwal = jadwal['jam'];

          return ListTile(
            title: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(namaJadwal!),
                Text(
                  'Jam: $jamJadwal',
                  style: TextStyle(
                    fontSize: 12,
                    color: Colors.grey,
                  ),
                ),
              ],
            ),
            onTap: () {
              setState(() {
                _textEditingController.text = namaJadwal;
                _jamEditingController.text = jamJadwal!;
                _selectedIndex = index;
              });
              showDialog(
                context: context,
                builder: (context) => AlertDialog(
                  title: const Text('Edit Jadwal'),
                  content: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      TextFormField(
                        controller: _textEditingController,
                        decoration: const InputDecoration(
                          labelText: 'Nama Jadwal',
                        ),
                      ),
                      TextFormField(
                        controller: _jamEditingController,
                        decoration: const InputDecoration(
                          labelText: 'Jam Jadwal',
                        ),
                      ),
                    ],
                  ),
                  actions: [
                    TextButton(
                      onPressed: () {
                        Navigator.pop(context);
                      },
                      child: const Text('Batal'),
                    ),
                    TextButton(
                      onPressed: () {
                        setState(() {
                          SeninPage.jadwalSenin[_selectedIndex]['nama'] =
                              _textEditingController.text;
                          SeninPage.jadwalSenin[_selectedIndex]['jam'] =
                              _jamEditingController.text;
                        });
                        Navigator.pop(context);
                      },
                      child: const Text('Simpan'),
                    ),
                  ],
                ),
              );
            },
            trailing: IconButton(
              icon: const Icon(Icons.delete),
              onPressed: () {
                setState(() {
                  SeninPage.jadwalSenin.removeAt(index);
                });
              },
            ),
          );
        },
      ),
    );
  }
}
