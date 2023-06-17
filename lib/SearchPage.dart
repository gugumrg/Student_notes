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
  List<String> _tasks = [];
  List<String> _schedules = [];
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
    await _loadTasks();
    await _loadSchedules();
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

  Future<void> _loadTasks() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    List<String> storedTasks = prefs.getStringList('tasks') ?? [];
    setState(() {
      _tasks = storedTasks;
    });
  }

  Future<void> _loadSchedules() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    List<String> storedSchedules = prefs.getStringList('schedules') ?? [];
    setState(() {
      _schedules = storedSchedules;
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

      // Cari di data tasks
      for (var task in _tasks) {
        if (task.contains(keyword)) {
          _searchResults.add({'judul': task, 'deskripsi': ''});
        }
      }

      // Cari di data schedules
      for (var schedule in _schedules) {
        if (schedule.contains(keyword)) {
          _searchResults.add({'judul': schedule, 'deskripsi': ''});
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
      // Data adalah checklist, tugas, atau jadwal
      String title = data['title']!;
      if (_checklistItems.any((item) => item.title == title)) {
        // Data adalah checklist
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => ChecklistDetailPage(title),
          ),
        );
      } else if (_tasks.contains(title)) {
        // Data adalah tugas
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => TaskDetailPage(title),
          ),
        );
      } else if (_schedules.contains(title)) {
        // Data adalah jadwal
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => ScheduleDetailPage(title),
          ),
        );
      }
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
                prefixIcon: Icon(Icons.search),
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
                      String category = _notes.contains(result)
                          ? 'Catatan'
                          : _checklistItems
                                  .any((item) => item.title == result['judul'])
                              ? 'Checklist'
                              : _tasks.contains(result['judul'])
                                  ? 'Tugas'
                                  : 'Jadwal';

                      Color chipColor =
                          category == 'Tugas' ? Colors.orange : Colors.blue;

                      return Card(
                        child: ListTile(
                          title: Text(
                            result['judul']!,
                            style: const TextStyle(fontWeight: FontWeight.bold),
                          ),
                          subtitle: Text(result['deskripsi']!),
                          trailing: Chip(
                            label: Text(
                              category,
                              style: const TextStyle(color: Colors.white),
                            ),
                            backgroundColor: chipColor,
                          ),
                          onTap: () {
                            _navigateToPage(result);
                          },
                        ),
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
              'Judul: $title',
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

class TaskDetailPage extends StatelessWidget {
  final String title;

  const TaskDetailPage(this.title);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Detail Tugas'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Judul: $title',
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

class ScheduleDetailPage extends StatelessWidget {
  final String title;

  const ScheduleDetailPage(this.title);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Detail Jadwal'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Judul: $title',
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
  String title;
  bool isDone;

  ChecklistItem(this.title, this.isDone);
}
