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
      child: Column(
        children: [
          Expanded(
            child: book.imageUrl != null
                ? Image.network(book.imageUrl!, fit: BoxFit.cover)
                : const Icon(Icons.book, size: 50),
          ),
          ListTile(
            title: Text(book.title, maxLines: 2),
            subtitle: Text(book.author),
            trailing: IconButton(
              icon: Icon(
                isFavorite ? Icons.favorite : Icons.favorite_border,
                color: isFavorite ? Colors.red : null,
              ),
              onPressed: onToggleFavorite,
            ),
          ),
        ],
      ),
    );
  }
}