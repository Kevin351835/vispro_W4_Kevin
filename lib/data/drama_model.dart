class DramaModel {
  final String id;
  final String title;
  final String mandarinTitle;
  final int releaseYear;
  final int totalEpisodes;
  final String cast;
  final String genre;
  bool isBookmarked;

  DramaModel({
    required this.id,
    required this.title,
    required this.mandarinTitle,
    required this.releaseYear,
    required this.totalEpisodes,
    required this.cast,
    required this.genre,
    this.isBookmarked = false,
  });
}