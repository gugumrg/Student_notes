import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ChecklistPage extends StatefulWidget {
  const ChecklistPage({Key? key});

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
        title: const Text('Tasks'),
      ),
      body: ListView.builder(
        itemCount: checklistItems.length,
        itemBuilder: (context, index) {
          final item = checklistItems[index];
          return Dismissible(
            key: Key(item.title),
            direction: DismissDirection.horizontal,
            onDismissed: (direction) {
              _removeChecklistItem(index);
            },
            background: Container(
              color: Colors.red,
              alignment: Alignment.centerRight,
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              child: const Icon(Icons.delete, color: Colors.white),
            ),
            child: Padding(
              padding: const EdgeInsets.symmetric(
                horizontal: 16.0,
                vertical: 8.0,
              ),
              child: Container(
                decoration: BoxDecoration(
                  color: item.checked ? Colors.grey[400] : Colors.white,
                  borderRadius: BorderRadius.circular(12.0),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.grey.withOpacity(0.3),
                      spreadRadius: 1,
                      blurRadius: 3,
                      offset: const Offset(0, 2),
                    ),
                  ],
                ),
                child: ListTile(
                  title: Text(
                    item.title,
                    style: TextStyle(
                      decoration: item.checked
                          ? TextDecoration.lineThrough
                          : TextDecoration.none,
                      fontSize: 18.0,
                      fontWeight: FontWeight.bold,
                      color: item.checked ? Colors.white : Colors.black,
                    ),
                  ),
                  trailing: Checkbox(
                    value: item.checked,
                    onChanged: (value) {
                      _toggleChecklistItem(index);
                    },
                    activeColor: Colors.blue,
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
                title: const Text('Tambah Task'),
                content: TextField(
                  controller: textEditingController,
                  decoration: const InputDecoration(
                    labelText: 'Isi Task',
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
