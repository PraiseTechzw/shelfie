import 'package:http/http.dart' as http;
import 'dart:convert';
import '../models/book.dart';

class BookService {
  final String _baseUrl = 'https://doomscrolling-poc.vercel.app/books/books_list.json';

  Future<List<Book>> getBooks() async {
    try {
      final response = await http.get(Uri.parse(_baseUrl));
      
      if (response.statusCode == 200) {
        final Map<String, dynamic> jsonResponse = json.decode(response.body);
        final List<dynamic> booksData = jsonResponse['data']['books'];
        return booksData.map((bookJson) => Book.fromJson(bookJson)).toList();
      } else {
        throw Exception('Failed to load books: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Failed to connect to the server or parse data: $e');
    }
  }
}

