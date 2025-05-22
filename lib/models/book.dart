class Book {
  final String id;
  final String title;
  final String author;
  final String? imageUrl;

  Book({
    required this.id,
    required this.title,
    required this.author,
    this.imageUrl,
  });

  factory Book.fromJson(Map<String, dynamic> json) {
    return Book(
      id: json['id'] ?? '',
      title: json['volumeInfo']['title'] ?? 'Titre inconnu',
      author: (json['volumeInfo']['authors'] as List?)?.join(', ') ?? 'Auteur inconnu',
      imageUrl: json['volumeInfo']['imageLinks']?['thumbnail'],
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'title': title,
      'author': author,
      'imageUrl': imageUrl,
    };
  }

  factory Book.fromMap(Map<String, dynamic> map) {
    return Book(
      id: map['id'],
      title: map['title'],
      author: map['author'],
      imageUrl: map['imageUrl'],
    );
  }
}