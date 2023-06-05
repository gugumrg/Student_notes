import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class CatatanPage extends StatefulWidget {
  const CatatanPage({Key? key});

  @override
  _CatatanPageState createState() => _CatatanPageState();
}

class _CatatanPageState extends State<CatatanPage> {
  final TextEditingController _judulController = TextEditingController();
  final TextEditingController _deskripsiController = TextEditingController();
  List<Map<String, String>> _notes = [];
  int _selectedNoteIndex = -1;

  @override
  void initState() {
    super.initState();
    _loadNotes();
  }

  @override
  void dispose() {
    _judulController.dispose();
    _deskripsiController.dispose();
    super.dispose();
  }

  Future<void> _loadNotes() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    List<String> notesJson = prefs.getStringList('notes') ?? [];
    List<Map<String, String>> notes = notesJson
        .map((note) => Map<String, String>.from(jsonDecode(note)))
        .toList();
    setState(() {
      _notes = notes;
    });
  }

  Future<void> _saveNotes() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    List<String> notesJson = _notes.map((note) => jsonEncode(note)).toList();
    await prefs.setStringList('notes', notesJson);
  }

  void _addNote() {
    String judul = _judulController.text;
    String deskripsi = _deskripsiController.text;
    if (judul.isNotEmpty && deskripsi.isNotEmpty) {
      setState(() {
        _notes.add({'judul': judul, 'deskripsi': deskripsi});
        _judulController.clear();
        _deskripsiController.clear();
      });
      _saveNotes();
      Navigator.pop(context);
    }
  }

  void _deleteNoteAtIndex(int index) {
    setState(() {
      _notes.removeAt(index);
      _selectedNoteIndex = -1;
    });
    _saveNotes();
  }

  void _showNoteDetails(int index) {
    setState(() {
      _selectedNoteIndex = index;
      _judulController.text = _notes[index]['judul']!;
      _deskripsiController.text = _notes[index]['deskripsi']!;
    });
    _showEditNoteDialog();
  }

  void _updateNote() {
    String judul = _judulController.text;
    String deskripsi = _deskripsiController.text;
    if (judul.isNotEmpty && deskripsi.isNotEmpty && _selectedNoteIndex != -1) {
      setState(() {
        _notes[_selectedNoteIndex] = {'judul': judul, 'deskripsi': deskripsi};
        _selectedNoteIndex = -1;
        _judulController.clear();
        _deskripsiController.clear();
      });
      _saveNotes();
      Navigator.pop(context);
    }
  }

  void _showAddNoteDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Tambah Catatan'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: _judulController,
                decoration: const InputDecoration(
                  labelText: 'Judul',
                  border: OutlineInputBorder(),
                ),
              ),
              const SizedBox(height: 16.0),
              TextField(
                controller: _deskripsiController,
                decoration: const InputDecoration(
                  labelText: 'Deskripsi',
                  border: OutlineInputBorder(),
                ),
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('Batal'),
            ),
            TextButton(
              onPressed: _addNote,
              child: const Text('Simpan'),
            ),
          ],
        );
      },
    );
  }

  void _showEditNoteDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Edit Catatan'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: _judulController,
                decoration: const InputDecoration(
                  labelText: 'Judul',
                  border: OutlineInputBorder(),
                ),
              ),
              const SizedBox(height: 16.0),
              TextField(
                controller: _deskripsiController,
                decoration: const InputDecoration(
                  labelText: 'Deskripsi',
                  border: OutlineInputBorder(),
                ),
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('Batal'),
            ),
            TextButton(
              onPressed: _updateNote,
              child: const Text('Simpan'),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Catatan'),
      ),
      body: _notes.isEmpty
          ? const Center(
              child: Text('Tidak ada catatan'),
            )
          : Column(
              children: [
                Expanded(
                  child: ListView.builder(
                    itemCount: _notes.length,
                    itemBuilder: (context, index) {
                      Map<String, String> note = _notes[index];
                      return ListTile(
                        title: Text(
                          note['judul']!,
                          style: _selectedNoteIndex == index
                              ? const TextStyle(
                                  decoration: TextDecoration.lineThrough)
                              : null,
                        ),
                        subtitle: Text(
                          note['deskripsi']!,
                          style: _selectedNoteIndex == index
                              ? const TextStyle(
                                  decoration: TextDecoration.lineThrough)
                              : null,
                        ),
                        trailing: IconButton(
                          icon: const Icon(Icons.delete),
                          onPressed: () => _deleteNoteAtIndex(index),
                        ),
                        onTap: () => _showNoteDetails(index),
                      );
                    },
                  ),
                ),
              ],
            ),
      floatingActionButton: FloatingActionButton(
        onPressed: _showAddNoteDialog,
        child: const Icon(Icons.add),
      ),
    );
  }
}
