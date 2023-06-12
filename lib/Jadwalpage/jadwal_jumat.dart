import 'package:flutter/material.dart';

class JumatPage extends StatefulWidget {
  static List<Map<String, String>> jadwalJumat = [];

  static void addJadwal(String namaJadwal, String jamJadwal) {
    jadwalJumat.add({
      'nama': namaJadwal,
      'jam': jamJadwal,
    });
  }

  @override
  _JumatPageState createState() => _JumatPageState();
}

class _JumatPageState extends State<JumatPage> {
  TextEditingController _textEditingController = TextEditingController();
  TextEditingController _jamEditingController = TextEditingController();
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
          final jamJadwal = jadwal['jam'];

          return ListTile(
            title: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(namaJadwal!),
                Text(
                  'Jam: $jamJadwal',
                  style: const TextStyle(
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
                        setState(() {
                          JumatPage.jadwalJumat[_selectedIndex]['nama'] =
                              _textEditingController.text;
                          JumatPage.jadwalJumat[_selectedIndex]['jam'] =
                              _jamEditingController.text;
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
