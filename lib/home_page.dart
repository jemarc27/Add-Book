import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'add_book_page.dart';

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  List books = [];

  Future<void> fetchBooks() async {
    final res = await http.get(Uri.parse('http://10.0.2.2:3000/api/books'));
    if (res.statusCode == 200) {
      setState(() {
        books = jsonDecode(res.body);
      });
    }
  }

  Future<void> deleteBook(String id) async {
    final res = await http.delete(
      Uri.parse('http://10.0.2.2:3000/api/books/$id'),
    );
    if (res.statusCode == 200) {
      fetchBooks();
    }
  }

  @override
  void initState() {
    super.initState();
    fetchBooks();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('📚 Book Viewer')),
      body: ListView.builder(
        itemCount: books.length,
        itemBuilder: (_, index) {
          final book = books[index];
          return ListTile(
            title: Text(book['title']),
            subtitle: Text('${book['author']} (${book['publishedYear']})'),
            trailing: IconButton(
              icon: Icon(Icons.delete, color: Colors.red),
              onPressed: () => deleteBook(book['_id'] ?? book['id'] ?? ''),
            ),
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.add),
        onPressed: () async {
          await Navigator.push(
            context,
            MaterialPageRoute(builder: (_) => AddBookPage()),
          );
          fetchBooks(); // Refresh on return
        },
      ),
    );
  }
}
