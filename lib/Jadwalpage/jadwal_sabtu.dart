import 'package:flutter/material.dart';

class SabtuPage extends StatefulWidget {
  static List<Map<String, String>> jadwalSabtu = [];

  static void addJadwal(String namaJadwal, String jamJadwal) {
    jadwalSabtu.add({
      'nama': namaJadwal,
      'jam': jamJadwal,
    });
  }

  @override
  _SabtuPageState createState() => _SabtuPageState();
}

class _SabtuPageState extends State<SabtuPage> {
  TextEditingController _textEditingController = TextEditingController();
  TextEditingController _jamEditingController = TextEditingController();
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
                        Navigator.pop(context);
                      },
                      child: const Text('Batal'),
                    ),
                    TextButton(
                      onPressed: () {
                        setState(() {
                          SabtuPage.jadwalSabtu[_selectedIndex]['nama'] =
                              _textEditingController.text;
                          SabtuPage.jadwalSabtu[_selectedIndex]['jam'] =
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
