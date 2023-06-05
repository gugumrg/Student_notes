import 'package:flutter/material.dart';

class SearchPage extends StatefulWidget {
  @override
  _SearchPageState createState() => _SearchPageState();
}

class _SearchPageState extends State<SearchPage> {
  List<String> dataList = [
    'Data 1',
    'Data 2',
    'Data 3',
    'Data 4',
    'Data 5',
    'Data 6',
    'Data 7',
  ];

  List<String> searchResults = [];

  @override
  void initState() {
    super.initState();
    searchResults = dataList; // Menampilkan semua data saat pertama kali dibuka
  }

  void _performSearch(String query) {
    List<String> results = [];

    if (query.isNotEmpty) {
      for (var item in dataList) {
        if (item.toLowerCase().contains(query.toLowerCase())) {
          results.add(item);
        }
      }
    } else {
      results = dataList; // Menampilkan semua data jika query kosong
    }

    setState(() {
      searchResults = results;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Search'),
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: TextField(
              onChanged: (value) => _performSearch(value),
              decoration: InputDecoration(
                labelText: 'Cari',
                prefixIcon: Icon(Icons.search),
              ),
            ),
          ),
          Expanded(
            child: ListView.builder(
              itemCount: searchResults.length,
              itemBuilder: (context, index) {
                return ListTile(
                  title: Text(searchResults[index]),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
