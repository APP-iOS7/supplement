import 'package:flutter/material.dart';
import 'package:supplementary_app/models/item_detail_model.dart';
import 'package:supplementary_app/services/gemini_service.dart';

class ItemDetailViewModel extends ChangeNotifier {
  final GeminiService _geminiService = GeminiService();

  ItemDetail? _itemDetail;
  bool _isLoading = false;
  String? _error;

  ItemDetail? get itemDetail => _itemDetail;
  bool get isLoading => _isLoading;
  String? get error => _error;

  Future<void> fetchItemDetail(String itemTitle) async {
    _isLoading = true;
    _error = null;
    notifyListeners();

    try {
      _itemDetail = await _geminiService.getDetailByName(itemTitle);
    } catch (e) {
      _error = e.toString();
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }
}
