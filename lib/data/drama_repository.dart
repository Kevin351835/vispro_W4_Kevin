import 'drama_model.dart';
import 'xianxia_data.dart';
import 'wuxia_data.dart';
import 'palace_data.dart';

class DramaRepository {
  static final DramaRepository _instance = DramaRepository._internal();
  factory DramaRepository() => _instance;
  DramaRepository._internal();

  static bool isEmptyTestMode = false;

  final List<DramaModel> _allDramas = [
    ...xianxiaDramas,
    ...wuxiaDramas,
    ...palaceDramas,
  ];

  List<DramaModel> getAllDramas() {
    if (isEmptyTestMode) return [];
    return _allDramas;
  }

  List<DramaModel> getBookmarkedDramas() {
    if (isEmptyTestMode) return [];
    return _allDramas.where((drama) => drama.isBookmarked).toList();
  }

  void toggleBookmark(String id) {
    final index = _allDramas.indexWhere((drama) => drama.id == id);
    if (index != -1) {
      _allDramas[index].isBookmarked = !_allDramas[index].isBookmarked;
    }
  }
}