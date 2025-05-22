import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../widgets/book_card.dart';

class FavoritesPage extends StatelessWidget {
  const FavoritesPage({super.key});

  @override
  Widget build(BuildContext context) {
    final booksProvider = Provider.of<BooksProvider>(context);

    return Scaffold(
      appBar: AppBar(title: const Text('Favoris')),
      body: RefreshIndicator(
        onRefresh: () => booksProvider.loadFavorites(),
        child: Consumer<BooksProvider>(
          builder: (context, provider, _) {
            if (provider.favorites.isEmpty) {
              return const Center(child: Text('Aucun favori'));
            }
            return GridView.builder(
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                childAspectRatio: 0.7,
              ),
              itemCount: provider.favorites.length,
              itemBuilder: (ctx, index) => BookCard(
                book: provider.favorites[index],
                isFavorite: true,
              ),
            );
          },
        ),
      ),
    );
  }
}