class Book {
  final int id;
  final String title;
  final String author;
  final String coverUrl;
  final Series? series;

  Book({
    required this.id,
    required this.title,
    required this.author,
    required this.coverUrl,
    this.series,
  });

  factory Book.fromJson(Map<String, dynamic> json) {
    return Book(
      id: json['id'],
      title: json['title'],
      author: json['author'],
      coverUrl: json['cover_url'],
      series: json['series'] != null ? Series.fromJson(json['series']) : null,
    );
  }
}

class Series {
  final int id;
  final int index;
  final String title;

  Series({
    required this.id,
    required this.index,
    required this.title,
  });

  factory Series.fromJson(Map<String, dynamic> json) {
    return Series(
      id: json['id'],
      index: json['index'],
      title: json['title'],
    );
  }
}
