import 'package:flutter/material.dart';
import '../models/book.dart';

class BookCard extends StatelessWidget {
  final Book book;
  final bool isFavorite;
  final VoidCallback? onToggleFavorite;

  const BookCard({
    required this.book,
    required this.isFavorite,
    this.onToggleFavorite,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 3,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Expanded(
            child: ClipRRect(
              borderRadius: const BorderRadius.vertical(top: Radius.circular(12)),
              child: book.imageUrl != null
                  ? Image.network(book.imageUrl!, fit: BoxFit.cover)
                  : const Icon(Icons.book, size: 50),
            ),
          ),
          ListTile(
            title: Text(
              book.title,
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
              style: const TextStyle(fontWeight: FontWeight.bold),
            ),
            subtitle: Text(
              book.author,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
            trailing: IconButton(
              icon: Icon(
                isFavorite ? Icons.favorite : Icons.favorite_border,
                color: isFavorite ? Colors.red : Colors.grey,
              ),
              onPressed: onToggleFavorite,
              splashRadius: 24,
              tooltip: isFavorite ? 'Retirer des favoris' : 'Ajouter aux favoris',
            ),
          ),
        ],
      ),
    );
  }
}
