import 'package:flutter/material.dart';
import '../services/db_service.dart';
import '../models/book.dart';
import '../widgets/book_card.dart';

class FavoritesPage extends StatefulWidget {
  const FavoritesPage({Key? key}) : super(key: key);

  @override
  _FavoritesPageState createState() => _FavoritesPageState();
}

class _FavoritesPageState extends State<FavoritesPage> {
  final DatabaseService _dbService = DatabaseService();
  List<Book> _favoriteBooks = [];
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    _loadFavorites();
  }

  Future<void> _loadFavorites() async {
    setState(() {
      _isLoading = true;
    });

    try {
      final books = await _dbService.getBooks();
      setState(() {
        _favoriteBooks = books;
      });
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  Future<void> _removeFavorite(Book book) async {
    await _dbService.deleteBook(book.id);
    await _loadFavorites();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Livres favoris'),
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : _favoriteBooks.isEmpty
          ? const Center(child: Text('Aucun livre favori'))
          : GridView.builder(
        padding: const EdgeInsets.all(8.0),
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
          childAspectRatio: 0.7,
          crossAxisSpacing: 8.0,
          mainAxisSpacing: 8.0,
        ),
        itemCount: _favoriteBooks.length,
        itemBuilder: (context, index) {
          final book = _favoriteBooks[index];
          return BookCard(
            book: book,
            isFavorite: true,
            onToggleFavorite: () => _removeFavorite(book),
          );
        },
      ),
    );
  }
}