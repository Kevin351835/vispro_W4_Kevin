import 'package:flutter/material.dart';
import '../core/empty_state.dart';
import '../data/drama_model.dart';
import '../data/drama_repository.dart';
import '../widgets/category_bar.dart';
import '../widgets/drama_card.dart';
import 'detail_screen.dart';
import 'bookmark_screen.dart';

class DiscoveryScreen extends StatefulWidget {
  final List<DramaModel>? initialDramas;
  const DiscoveryScreen({super.key, this.initialDramas});

  @override
  State<DiscoveryScreen> createState() => _DiscoveryScreenState();
}

class _DiscoveryScreenState extends State<DiscoveryScreen> {
  final _repository = DramaRepository();
  String _selectedCategory = 'Semua';
  String _searchQuery = '';

  List<DramaModel> get _filteredDramas {
    final baseList = widget.initialDramas ?? 
        (DramaRepository.isEmptyTestMode ? [] : _repository.getAllDramas());

    return baseList.where((drama) {
      final matchesCategory = _selectedCategory == 'Semua' ||
          drama.genre.toLowerCase().contains(_selectedCategory.toLowerCase());
      final query = _searchQuery.toLowerCase();
      final matchesSearch = drama.title.toLowerCase().contains(query) ||
          drama.mandarinTitle.toLowerCase().contains(query) ||
          drama.cast.toLowerCase().contains(query);
      return matchesCategory && matchesSearch;
    }).toList();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('C-Drama Lore Hub'),
        actions: [
          IconButton(
            icon: const Icon(Icons.bookmark),
            onPressed: () async {
              await Navigator.push(
                context,
                MaterialPageRoute(builder: (_) => const BookmarkScreen()),
              );
              setState(() {});
            },
          ),
        ],
      ),
      body: SafeArea(
        child: LayoutBuilder(
          builder: (context, constraints) {
            final isTablet = constraints.maxWidth >= 600;

            if (_filteredDramas.isEmpty) {
              return Column(
                children: [
                  _buildSearchField(),
                  CategoryBar(
                    selectedCategory: _selectedCategory,
                    onCategorySelected: (cat) => setState(() => _selectedCategory = cat),
                  ),
                  const Expanded(
                    child: EmptyStateWidget(
                      key: Key('empty-state'),
                      message: 'Drama tidak ditemukan',
                    ),
                  ),
                ],
              );
            }

            return CustomScrollView(
              slivers: [
                SliverToBoxAdapter(child: _buildSearchField()),
                SliverToBoxAdapter(
                  child: CategoryBar(
                    selectedCategory: _selectedCategory,
                    onCategorySelected: (cat) => setState(() => _selectedCategory = cat),
                  ),
                ),
                const SliverToBoxAdapter(child: SizedBox(height: 8)),
                isTablet ? _buildTabletGrid() : _buildMobileList(),
              ],
            );
          },
        ),
      ),
      bottomNavigationBar: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(12.0),
          child: ElevatedButton(
            key: const Key('order-button'),
            onPressed: () {},
            style: ElevatedButton.styleFrom(minimumSize: const Size.fromHeight(48)),
            child: const Text('Order / Bookmark Drama'),
          ),
        ),
      ),
    );
  }

  Widget _buildSearchField() => Padding(
        padding: const EdgeInsets.all(16.0),
        child: TextField(
          key: const Key('search-field'),
          decoration: const InputDecoration(
            hintText: 'Cari judul, mandarin, atau pemain...',
            prefixIcon: Icon(Icons.search),
            border: OutlineInputBorder(),
          ),
          onChanged: (value) => setState(() => _searchQuery = value),
        ),
      );

  Widget _buildTabletGrid() => SliverPadding(
        padding: const EdgeInsets.all(8.0),
        sliver: SliverGrid(
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2,
            childAspectRatio: 1.2,
            crossAxisSpacing: 8,
            mainAxisSpacing: 8,
          ),
          delegate: SliverChildBuilderDelegate(
            (context, index) {
              final drama = _filteredDramas[index];
              return Card(
                key: ValueKey('tablet-${drama.id}'),
                child: InkWell(
                  onTap: () => _openDetail(drama.id),
                  child: Padding(
                    padding: const EdgeInsets.all(12.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(drama.title, style: Theme.of(context).textTheme.titleMedium),
                        const SizedBox(height: 4),
                        Text(drama.genre),
                      ],
                    ),
                  ),
                ),
              );
            },
            childCount: _filteredDramas.length,
          ),
        ),
      );

  Widget _buildMobileList() => SliverList(
        delegate: SliverChildBuilderDelegate(
          (context, index) => DramaCard(
            drama: _filteredDramas[index],
            onTap: () => _openDetail(_filteredDramas[index].id),
            onBookmarkToggle: () => setState(() {
              _repository.toggleBookmark(_filteredDramas[index].id);
            }),
          ),
          childCount: _filteredDramas.length,
        ),
      );

  Future<void> _openDetail(String dramaId) async {
    await Navigator.push(
      context,
      MaterialPageRoute(builder: (_) => DetailScreen(dramaId: dramaId)),
    );
    setState(() {});
  }
}