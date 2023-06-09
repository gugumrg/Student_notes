import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SearchPage extends StatefulWidget {
  @override
  _SearchPageState createState() => _SearchPageState();
}

class _SearchPageState extends State<SearchPage> {
  final TextEditingController _searchController = TextEditingController();
  List<Map<String, String>> _notes = [];
  List<ChecklistItem> _checklistItems = [];
  List<Map<String, String>> _searchResults = [];

  @override
  void initState() {
    super.initState();
    _loadData();
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  Future<void> _loadData() async {
    await _loadNotes();
    await _loadChecklistItems();
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

  Future<void> _loadChecklistItems() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    List<String> storedItems = prefs.getStringList('checklistItems') ?? [];
    setState(() {
      _checklistItems =
          storedItems.map((item) => ChecklistItem(item, false)).toList();
    });
  }

  void _searchData(String keyword) {
    setState(() {
      _searchResults = [];

      // Cari di data catatan
      for (var note in _notes) {
        if (note['judul']!.contains(keyword) ||
            note['deskripsi']!.contains(keyword)) {
          _searchResults.add(note);
        }
      }

      // Cari di data checklist
      for (var item in _checklistItems) {
        if (item.title.contains(keyword)) {
          _searchResults.add({'judul': item.title, 'deskripsi': ''});
        }
      }
    });
  }

  void _navigateToPage(Map<String, String> data) {
    if (data.containsKey('judul')) {
      // Data adalah catatan
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => CatatanDetailPage(
            judul: data['judul']!,
            deskripsi: data['deskripsi']!,
          ),
        ),
      );
    } else {
      // Data adalah checklist
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => ChecklistDetailPage(data['title']!),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Search'),
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: TextField(
              controller: _searchController,
              decoration: const InputDecoration(
                labelText: 'Cari',
                border: OutlineInputBorder(),
              ),
              onChanged: (value) {
                _searchData(value);
              },
            ),
          ),
          Expanded(
            child: _searchResults.isNotEmpty
                ? ListView.builder(
                    itemCount: _searchResults.length,
                    itemBuilder: (context, index) {
                      Map<String, String> result = _searchResults[index];
                      return ListTile(
                        title: Text(result['judul']!),
                        subtitle: Text(result['deskripsi']!),
                        onTap: () {
                          _navigateToPage(result);
                        },
                      );
                    },
                  )
                : const Center(
                    child: Text('Tidak ada hasil'),
                  ),
          ),
        ],
      ),
    );
  }
}

class CatatanDetailPage extends StatelessWidget {
  final String judul;
  final String deskripsi;

  const CatatanDetailPage({
    Key? key,
    required this.judul,
    required this.deskripsi,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Detail Catatan'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Judul: $judul',
              style: const TextStyle(
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 8.0),
            Text('Deskripsi: $deskripsi'),
          ],
        ),
      ),
    );
  }
}

class ChecklistDetailPage extends StatelessWidget {
  final String title;

  const ChecklistDetailPage(this.title);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Detail Checklist'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Title: $title',
              style: const TextStyle(
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class ChecklistItem {
  final String title;
  bool checked;

  ChecklistItem(this.title, this.checked);
}
