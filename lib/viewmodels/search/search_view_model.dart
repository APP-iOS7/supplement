import 'package:flutter/material.dart';
import 'package:supplementary_app/services/naver_service.dart';
import 'package:supplementary_app/models/naver_search_Item_model.dart';

class SearchViewModel extends ChangeNotifier {
  final TextEditingController controller = TextEditingController();
  final NaverService _naverService = NaverService();
  Future<List<SearchItem>>? searchFuture;

  Future<List<SearchItem>> search() async {
    try {
      final results = await _naverService.searchNaverShopping(controller.text);
      notifyListeners();
      return results.where((item) => item.category2 == "건강식품").toList();
    } catch (e) {
      print('검색 실패: $e');
      notifyListeners();
      return [];
    }
  }

  void executeSearch() {
    searchFuture = search();
    notifyListeners();
  }
}
