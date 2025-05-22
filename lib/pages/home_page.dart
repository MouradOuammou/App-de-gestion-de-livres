import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/books_provider.dart';
import '../widgets/book_card.dart';
import 'favorites_page.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final TextEditingController _searchController = TextEditingController();
  final FocusNode _searchFocusNode = FocusNode();

  @override
  void dispose() {
    _searchController.dispose();
    _searchFocusNode.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final booksProvider = Provider.of<BooksProvider>(context);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Recherche de livres'),
        centerTitle: true,
        actions: [
          IconButton(
            icon: Badge(
              isLabelVisible: booksProvider.favorites.isNotEmpty,
              label: Text(booksProvider.favorites.length.toString()),
              child: const Icon(Icons.favorite),
            ),
            onPressed: () => Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => const FavoritesPage()),
            ),
          ),
        ],
      ),
      body: CustomScrollView(
        slivers: [
          SliverPadding(
            padding: const EdgeInsets.all(16.0),
            sliver: SliverToBoxAdapter(
              child: TextField(
                controller: _searchController,
                focusNode: _searchFocusNode,
                decoration: InputDecoration(
                  labelText: 'Titre, auteur ou ISBN',
                  hintText: 'Ex: Flutter, Stephen King...',
                  prefixIcon: const Icon(Icons.search),
                  suffixIcon: _searchController.text.isNotEmpty
                      ? IconButton(
                    icon: const Icon(Icons.clear),
                    onPressed: () {
                      _searchController.clear();
                      booksProvider.clearSearch();
                      _searchFocusNode.requestFocus();
                    },
                  )
                      : null,
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  filled: true,
                  fillColor: theme.colorScheme.surfaceVariant.withOpacity(0.5),
                ),
                onSubmitted: (value) {
                  if (value.trim().isNotEmpty) {
                    booksProvider.searchBooks(value.trim());
                  }
                },
              ),
            ),
          ),
          Consumer<BooksProvider>(
            builder: (context, provider, _) {
              if (provider.isLoading) {
                return const SliverFillRemaining(
                  child: Center(child: CircularProgressIndicator()),
                );
              }

              if (provider.error.isNotEmpty) {
                return SliverFillRemaining(
                  child: Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          Icons.error_outline,
                          size: 48,
                          color: theme.colorScheme.error,
                        ),
                        const SizedBox(height: 16),
                        Text(
                          provider.error,
                          style: theme.textTheme.bodyLarge,
                          textAlign: TextAlign.center,
                        ),
                        const SizedBox(height: 16),
                        FilledButton(
                          onPressed: () => provider.searchBooks(_searchController.text),
                          child: const Text('Réessayer'),
                        ),
                      ],
                    ),
                  ),
                );
              }

              if (provider.searchResults.isEmpty && _searchController.text.isNotEmpty) {
                return SliverFillRemaining(
                  child: Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          Icons.search_off,
                          size: 48,
                          color: theme.colorScheme.onSurface.withOpacity(0.5),
                        ),
                        const SizedBox(height: 16),
                        Text(
                          'Aucun résultat trouvé',
                          style: theme.textTheme.titleMedium,
                        ),
                        Text(
                          'Essayez avec d\'autres mots-clés',
                          style: theme.textTheme.bodyMedium,
                        ),
                      ],
                    ),
                  ),
                );
              }

              if (provider.searchResults.isEmpty) {
                return SliverFillRemaining(
                  child: Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          Icons.auto_stories,
                          size: 48,
                          color: theme.colorScheme.primary,
                        ),
                        const SizedBox(height: 16),
                        Text(
                          'Recherchez des livres',
                          style: theme.textTheme.titleMedium,
                        ),
                        Text(
                          'Utilisez la barre de recherche ci-dessus',
                          style: theme.textTheme.bodyMedium,
                        ),
                      ],
                    ),
                  ),
                );
              }

              return SliverPadding(
                padding: const EdgeInsets.symmetric(horizontal: 16.0),
                sliver: SliverGrid(
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2,
                    mainAxisSpacing: 16,
                    crossAxisSpacing: 16,
                    childAspectRatio: 0.7,
                  ),
                  delegate: SliverChildBuilderDelegate(
                        (context, index) {
                      final book = provider.searchResults[index];
                      return BookCard(
                        book: book,
                        isFavorite: provider.isFavorite(book.id),
                        onToggleFavorite: () => provider.toggleFavorite(book),
                      );
                    },
                    childCount: provider.searchResults.length,
                  ),
                ),
              );
            },
          ),
        ],
      ),
      floatingActionButton: _searchController.text.isNotEmpty
          ? FloatingActionButton(
        onPressed: () {
          final currentPosition = Scrollable.of(context).position;
          if (currentPosition.pixels > 200) {
            currentPosition.animateTo(
              0,
              duration: const Duration(milliseconds: 500),
              curve: Curves.easeInOut,
            );
          }
        },
        child: const Icon(Icons.arrow_upward),
      )
          : null,
    );
  }
}