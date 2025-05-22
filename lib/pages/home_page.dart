import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/books_provider.dart';
import '../widgets/book_card.dart';

class HomePage extends StatelessWidget {
  final TextEditingController _searchController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    final booksProvider = Provider.of<BooksProvider>(context);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Recherche de livres'),
        actions: [
          IconButton(
            icon: const Icon(Icons.favorite),
            onPressed: () => Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => const FavoritesPage()),
            ),
          ),
        ],
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: TextField(
              controller: _searchController,
              decoration: InputDecoration(
                labelText: 'Rechercher',
                suffixIcon: IconButton(
                  icon: const Icon(Icons.search),
                  onPressed: () => booksProvider.searchBooks(_searchController.text),
                ),
              ),
            ),
          ),
          Expanded(
            child: Consumer<BooksProvider>(
              builder: (context, provider, _) {
                if (provider.isLoading) return const Center(child: CircularProgressIndicator());
                if (provider.error.isNotEmpty) return Text(provider.error);
                return GridView.builder(
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2,
                    childAspectRatio: 0.7,
                  ),
                  itemCount: provider.searchResults.length,
                  itemBuilder: (ctx, index) => BookCard(
                    book: provider.searchResults[index],
                    isFavorite: provider.isFavorite(provider.searchResults[index].id),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}