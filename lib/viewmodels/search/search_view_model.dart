import 'package:flutter/material.dart';
import 'package:supplementary_app/models/item_detail_model.dart';
import 'package:supplementary_app/services/naver_service.dart';
import 'package:supplementary_app/models/naver_search_Item_model.dart';
import 'package:supplementary_app/services/gemini_service.dart';

class SearchViewModel extends ChangeNotifier {
  final TextEditingController controller = TextEditingController();
  final NaverService _naverService = NaverService();
  final GeminiService _geminiService = GeminiService();
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

  Future<ItemDetail> fetchItemDetail(
    String productName,
    String imageUrl,
    String price,
  ) async {
    try {
      final itemDetail = await _geminiService.getDetailByName(
        productName,
        imageUrl,
        price,
      );
      notifyListeners();
      return itemDetail;
    } catch (e) {
      print('아이템 상세 정보 가져오기 실패: $e');
      throw '디테일 fetchItemDetail에 문제 생김 문제: $e';
    }
  }

  void executeSearch() {
    searchFuture = search();
    notifyListeners();
  }
}
