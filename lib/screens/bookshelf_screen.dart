import 'package:flutter/material.dart';
import 'package:shelfie/widgets/bookshelf_rack.dart';
import 'package:shelfie/models/book.dart';

class BookshelfScreen extends StatefulWidget {
  @override
  _BookshelfScreenState createState() => _BookshelfScreenState();
}

class _BookshelfScreenState extends State<BookshelfScreen> with SingleTickerProviderStateMixin {
  late List<Book> _books;
  late AnimationController _controller;
  late Animation<double> _fadeAnimation;
  final GlobalKey _shelfKey = GlobalKey();

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: Duration(milliseconds: 1000),
      vsync: this,
    );
    _fadeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(_controller);
    _controller.forward();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _books = ModalRoute.of(context)!.settings.arguments as List<Book>;
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              Color(0xFF1A1A2E),
              Color(0xFF16213E),
              Color(0xFF0F3460),
            ],
          ),
        ),
        child: SafeArea(
          child: Stack(
            children: [
              // iOS-style back button
              Positioned(
                top: 16,
                left: 16,
                child: GestureDetector(
                  onTap: () => Navigator.pop(context),
                  child: Container(
                    padding: EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      color: Colors.white.withOpacity(0.2),
                      shape: BoxShape.circle,
                    ),
                    child: Icon(Icons.arrow_back_ios_new, color: Colors.white, size: 20),
                  ),
                ),
              ),
              Column(
                children: [
                  Expanded(
                    child: RepaintBoundary(
                      key: _shelfKey,
                      child: FadeTransition(
                        opacity: _fadeAnimation,
                        child: LayoutBuilder(
                          builder: (context, constraints) {
                            return SingleChildScrollView(
                              child: ConstrainedBox(
                                constraints: BoxConstraints(minHeight: constraints.maxHeight),
                                child: Column(
                                  children: [
                                    SizedBox(height: 40),
                                    Text(
                                      'MY SHELFIE',
                                      style: TextStyle(
                                        color: Colors.white,
                                        fontSize: 32,
                                        fontWeight: FontWeight.bold,
                                        letterSpacing: 2,
                                        shadows: [
                                          Shadow(
                                            offset: Offset(0, 2),
                                            blurRadius: 4,
                                            color: Colors.black.withOpacity(0.3),
                                          ),
                                        ],
                                      ),
                                    ),
                                    SizedBox(height: 60),
                                    // First shelf
                                    Padding(
                                      padding: EdgeInsets.symmetric(horizontal: 20),
                                      child: ShelfRack(
                                        books: _books.take(3).toList(),
                                        onReorder: (oldIndex, newIndex) {
                                          setState(() {
                                            if (newIndex > oldIndex) newIndex -= 1;
                                            final book = _books.removeAt(oldIndex);
                                            _books.insert(newIndex, book);
                                          });
                                        },
                                      ),
                                    ),
                                    SizedBox(height: 40),
                                    // Second shelf
                                    Padding(
                                      padding: EdgeInsets.symmetric(horizontal: 20),
                                      child: ShelfRack(
                                        books: _books.skip(3).toList(),
                                        onReorder: (oldIndex, newIndex) {
                                          setState(() {
                                            if (newIndex > oldIndex) newIndex -= 1;
                                            final book = _books.removeAt(oldIndex + 3);
                                            _books.insert(newIndex + 3, book);
                                          });
                                        },
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            );
                          },
                        ),
                      ),
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.all(20),
                    child: ElevatedButton(
                      onPressed: () => Navigator.pushNamed(
                        context,
                        '/share',
                        arguments: _shelfKey,
                      ),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.white,
                        minimumSize: Size(200, 50),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(25),
                        ),
                        elevation: 4,
                      ),
                      child: Text(
                        'Download',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: Color(0xFF1A1A2E),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}

