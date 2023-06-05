import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ChecklistPage extends StatefulWidget {
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
        title: Text('Checklist'),
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Row(
              children: [
                Expanded(
                  child: TextFormField(
                    controller: textEditingController,
                    decoration: InputDecoration(
                      labelText: 'Tambah Checklist',
                      border: OutlineInputBorder(),
                    ),
                  ),
                ),
              ],
            ),
          ),
          Expanded(
            child: ListView.builder(
              itemCount: checklistItems.length,
              itemBuilder: (context, index) {
                final item = checklistItems[index];
                return Padding(
                  padding: const EdgeInsets.symmetric(
                      horizontal: 16.0, vertical: 8.0),
                  child: GestureDetector(
                    onTap: () {
                      _toggleChecklistItem(index);
                    },
                    child: Container(
                      decoration: BoxDecoration(
                        color: item.checked
                            ? Colors.grey[400]
                            : Colors.transparent,
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
                          icon: Icon(Icons.delete),
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
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          if (textEditingController.text.isNotEmpty) {
            _addChecklistItem(textEditingController.text);
          }
        },
        child: Icon(Icons.add),
      ),
    );
  }
}

class ChecklistItem {
  final String title;
  bool checked;

  ChecklistItem(this.title, this.checked);
}
