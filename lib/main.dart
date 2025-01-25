import 'package:flutter/material.dart';
import 'package:shelfie/screens/book_selection_screen.dart';
import 'package:shelfie/screens/bookshelf_screen.dart';
import 'package:shelfie/screens/share_screen.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Shelfie',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      initialRoute: '/',
      routes: {
        '/': (context) => BookSelectionScreen(),
        '/organize': (context) => BookshelfScreen(),
        '/share': (context) => ShareScreen(),
      },
    );
  }
}
