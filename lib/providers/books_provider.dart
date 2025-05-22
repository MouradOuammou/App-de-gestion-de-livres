import 'package:flutter/foundation.dart';
import '../models/book.dart';
import '../services/api_service.dart';
import '../services/db_service.dart';

class BooksProvider with ChangeNotifier {
  final ApiService _apiService = ApiService();
  final DatabaseService _dbService = DatabaseService();

  List<Book> _searchResults = [];
  List<Book> _favorites = [];
  bool _isLoading = false;
  String _error = '';

  List<Book> get searchResults => _searchResults;
  List<Book> get favorites => _favorites;
  bool get isLoading => _isLoading;
  String get error => _error;

  bool isFavorite(String bookId) => _favorites.any((b) => b.id == bookId);

  Future<void> searchBooks(String query) async {
    _isLoading = true;
    notifyListeners();
    try {
      _searchResults = await _apiService.searchBooks(query);
      _error = '';
    } catch (e) {
      _error = 'Erreur: ${e.toString()}';
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> loadFavorites() async {
    _favorites = await _dbService.getBooks();
    notifyListeners();
  }

  Future<void> toggleFavorite(Book book) async {
    if (isFavorite(book.id)) {
      await _dbService.deleteBook(book.id);
    } else {
      await _dbService.insertBook(book);
    }
    await loadFavorites();
  }

  void clearSearch() {
    _searchResults = [];
    notifyListeners();
  }
}