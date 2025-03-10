import 'package:flutter/material.dart';
import 'package:supplementary_app/models/item_detail_model.dart';
import 'package:supplementary_app/services/gemini_service.dart';

class ItemDetailViewModel {
  final BuildContext context;
  final String itemTitle;
  final String imageUrl;
  final String price;
  final GeminiService _geminiService = GeminiService();

  ItemDetailViewModel({
    required this.context,
    required this.itemTitle,
    required this.imageUrl,
    required this.price,
  });

  Future<ItemDetail> getItemDetail() async {
    return await _geminiService.getDetailByName(itemTitle, imageUrl, price);
  }
}
