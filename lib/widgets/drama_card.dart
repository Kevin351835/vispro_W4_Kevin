import 'package:flutter/material.dart';
import '../data/drama_model.dart';

class DramaCard extends StatelessWidget {
  final DramaModel drama;
  final VoidCallback onTap;
  final VoidCallback onBookmarkToggle;

  const DramaCard({
    super.key,
    required this.drama,
    required this.onTap,
    required this.onBookmarkToggle,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Card(
      child: ListTile(
        onTap: onTap,
        title: Text(
          drama.title,
          style: theme.textTheme.titleMedium?.copyWith(
            fontWeight: FontWeight.bold,
          ),
        ),
        subtitle: Text(
          '${drama.mandarinTitle} • Rilis ${drama.releaseYear}\n${drama.cast}',
          maxLines: 2,
          overflow: TextOverflow.ellipsis,
        ),
        trailing: IconButton(
          icon: Icon(
            drama.isBookmarked ? Icons.bookmark : Icons.bookmark_border,
            color: drama.isBookmarked ? theme.colorScheme.primary : null,
          ),
          onPressed: onBookmarkToggle,
        ),
      ),
    );
  }
}