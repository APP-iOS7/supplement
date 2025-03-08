import 'dart:async';
import 'package:flutter/material.dart';
import 'package:supplementary_app/models/recommend_item_model.dart';
import 'package:supplementary_app/services/store_service.dart';

class RecommendationProvider extends ChangeNotifier {
  final StoreService _storeService;
  List<RecommendItemModel> _recommendations = [];
  StreamSubscription<List<RecommendItemModel>>? _subscription;

  RecommendationProvider(this._storeService) {
    _startListening();
  }

  List<RecommendItemModel> get recommendations => _recommendations;

  void _startListening() {
    _subscription = _storeService.streamRecommendations().listen((data) {
      _recommendations = data;
      notifyListeners();
    });
  }

  @override
  void dispose() {
    _subscription?.cancel();
    super.dispose();
  }
}
