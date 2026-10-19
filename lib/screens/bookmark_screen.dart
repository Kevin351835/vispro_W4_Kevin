import 'package:flutter/material.dart';
import '../core/empty_state.dart';
import '../data/drama_repository.dart';
import '../widgets/drama_card.dart';
import 'detail_screen.dart';

class BookmarkScreen extends StatefulWidget {
  const BookmarkScreen({super.key});

  @override
  State<BookmarkScreen> createState() => _BookmarkScreenState();
}

class _BookmarkScreenState extends State<BookmarkScreen> {
  final _repository = DramaRepository();

  @override
  Widget build(BuildContext context) {
    final bookmarkedDramas = _repository.getBookmarkedDramas();

    return Scaffold(
      appBar: AppBar(
        title: const Text('Favorit Saya'),
      ),
      body: bookmarkedDramas.isEmpty
          ? const EmptyStateWidget(
              message: 'Belum ada drama favorit yang disimpan',
              icon: Icons.bookmark_border,
            )
          : ListView.builder(
              itemCount: bookmarkedDramas.length,
              itemBuilder: (context, index) {
                final drama = bookmarkedDramas[index];
                return DramaCard(
                  drama: drama,
                  onTap: () async {
                    await Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) => DetailScreen(dramaId: drama.id),
                      ),
                    );
                    setState(() {});
                  },
                  onBookmarkToggle: () {
                    setState(() {
                      _repository.toggleBookmark(drama.id);
                    });
                  },
                );
              },
            ),
    );
  }
}