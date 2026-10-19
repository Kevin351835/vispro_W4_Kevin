import 'package:flutter/material.dart';
import '../data/drama_repository.dart';

class DetailScreen extends StatefulWidget {
  final String dramaId;

  const DetailScreen({super.key, required this.dramaId});

  @override
  State<DetailScreen> createState() => _DetailScreenState();
}

class _DetailScreenState extends State<DetailScreen> {
  late final DramaRepository _repository;

  @override
  void initState() {
    super.initState();
    _repository = DramaRepository();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final drama = _repository.getAllDramas().firstWhere((d) => d.id == widget.dramaId);

    return Scaffold(
      appBar: AppBar(
        title: Text(drama.title),
        actions: [
          IconButton(
            key: const Key('order-button'),
            icon: Icon(
              drama.isBookmarked ? Icons.bookmark : Icons.bookmark_border,
              color: drama.isBookmarked ? theme.colorScheme.primary : theme.colorScheme.onSurfaceVariant,
            ),
            tooltip: drama.isBookmarked ? 'Hapus Bookmark' : 'Tambah Bookmark',
            onPressed: () {
              setState(() {
                _repository.toggleBookmark(drama.id);
              });
            },
          ),
        ],
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                drama.mandarinTitle,
                style: theme.textTheme.headlineLarge,
              ),
              const SizedBox(height: 8),
              Chip(
                label: Text(drama.genre),
                backgroundColor: theme.colorScheme.secondaryContainer,
              ),
              const SizedBox(height: 16),
              Row(
                children: [
                  Icon(Icons.movie, color: theme.colorScheme.primary),
                  const SizedBox(width: 8),
                  Text('${drama.totalEpisodes} Eps'),
                  const SizedBox(width: 24),
                  Icon(Icons.calendar_today, color: theme.colorScheme.primary),
                  const SizedBox(width: 8),
                  Text('Rilis ${drama.releaseYear}'),
                ],
              ),
              const SizedBox(height: 24),
              Text(
                'Pemeran Utama:',
                style: theme.textTheme.titleSmall?.copyWith(fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 8),
              Wrap(
                spacing: 8,
                children: drama.cast.split(',').map((actor) {
                  return Chip(
                    avatar: const Icon(Icons.person, size: 18),
                    label: Text(actor.trim()),
                  );
                }).toList(),
              ),
            ],
          ),
        ),
      ),
    );
  }
}