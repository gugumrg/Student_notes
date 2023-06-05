import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ChecklistPage extends StatefulWidget {
  const ChecklistPage({super.key});

  @override
  _ChecklistPageState createState() => _ChecklistPageState();
}

class _ChecklistPageState extends State<ChecklistPage> {
  List<ChecklistItem> checklistItems = [];
  TextEditingController textEditingController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _loadChecklistItems();
  }

  @override
  void dispose() {
    textEditingController.dispose();
    super.dispose();
  }

  Future<void> _loadChecklistItems() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    List<String> storedItems = prefs.getStringList('checklistItems') ?? [];
    setState(() {
      checklistItems =
          storedItems.map((item) => ChecklistItem(item, false)).toList();
    });
  }

  Future<void> _saveChecklistItems() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    List<String> storedItems =
        checklistItems.map((item) => item.title).toList();
    await prefs.setStringList('checklistItems', storedItems);
  }

  void _addChecklistItem(String item) {
    setState(() {
      checklistItems.add(ChecklistItem(item, false));
      textEditingController.clear();
    });
    _saveChecklistItems();
  }

  void _toggleChecklistItem(int index) {
    setState(() {
      checklistItems[index].checked = !checklistItems[index].checked;
    });
    _saveChecklistItems();
  }

  void _removeChecklistItem(int index) {
    setState(() {
      checklistItems.removeAt(index);
    });
    _saveChecklistItems();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Checklist'),
      ),
      body: ListView.builder(
        itemCount: checklistItems.length,
        itemBuilder: (context, index) {
          final item = checklistItems[index];
          return Padding(
            padding: const EdgeInsets.symmetric(
              horizontal: 16.0,
              vertical: 8.0,
            ),
            child: GestureDetector(
              onTap: () {
                _toggleChecklistItem(index);
              },
              child: Container(
                decoration: BoxDecoration(
                  color: item.checked ? Colors.grey[400] : Colors.transparent,
                  borderRadius: BorderRadius.circular(12.0),
                  border: Border.all(
                    color: Colors.grey[400]!,
                    width: 2.0,
                  ),
                ),
                child: ListTile(
                  title: Text(
                    item.title,
                    style: TextStyle(
                      decoration: item.checked
                          ? TextDecoration.lineThrough
                          : TextDecoration.none,
                    ),
                  ),
                  trailing: IconButton(
                    icon: const Icon(Icons.delete),
                    onPressed: () {
                      _removeChecklistItem(index);
                    },
                  ),
                ),
              ),
            ),
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          showDialog(
            context: context,
            builder: (BuildContext context) {
              return AlertDialog(
                title: const Text('Tambah Checklist'),
                content: TextField(
                  controller: textEditingController,
                  decoration: const InputDecoration(
                    labelText: 'Isi Checklist',
                  ),
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
                      if (textEditingController.text.isNotEmpty) {
                        _addChecklistItem(textEditingController.text);
                      }
                      Navigator.pop(context);
                    },
                    child: const Text('Simpan'),
                  ),
                ],
              );
            },
          );
        },
        child: const Icon(Icons.add),
      ),
    );
  }
}

class ChecklistItem {
  final String title;
  bool checked;

  ChecklistItem(this.title, this.checked);
}
