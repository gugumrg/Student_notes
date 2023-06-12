import 'package:flutter/material.dart';

class RabuPage extends StatefulWidget {
  static List<Map<String, String>> jadwalRabu = [];

  static void addJadwal(String namaJadwal, String jamJadwal) {
    jadwalRabu.add({
      'nama': namaJadwal,
      'jam': jamJadwal,
    });
  }

  @override
  _RabuPageState createState() => _RabuPageState();
}

class _RabuPageState extends State<RabuPage> {
  TextEditingController _textEditingController = TextEditingController();
  TextEditingController _jamEditingController = TextEditingController();
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
                          RabuPage.jadwalRabu[_selectedIndex]['nama'] =
                              _textEditingController.text;
                          RabuPage.jadwalRabu[_selectedIndex]['jam'] =
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
