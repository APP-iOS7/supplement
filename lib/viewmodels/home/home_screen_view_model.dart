import 'dart:async';
import 'package:flutter/material.dart';
import 'package:supplementary_app/models/recommend_item_model.dart';
import 'package:supplementary_app/services/store_service.dart';

class HomeScreenViewModel with ChangeNotifier {
  HomeScreenViewModel({required this.context}) {
    _initRecommendations();
  }

  final BuildContext context;
  final StoreService _storeService = StoreService();
  List<RecommendItemModel> _recommendList = [];
  StreamSubscription<List<RecommendItemModel>>? _subscription;

  List<RecommendItemModel> get recommendList => _recommendList;

  void _initRecommendations() {
    _subscription = _storeService.streamRecommendations().listen((data) {
      _recommendList = data;
      notifyListeners();
    });
  }

  @override
  void dispose() {
    _subscription?.cancel();
    super.dispose();
  }
}
