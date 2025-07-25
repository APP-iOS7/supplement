import 'dart:async';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:supplementary_app/models/recommend_item_model.dart';
import 'package:supplementary_app/providers/supplement_survey_provider.dart';
import 'package:supplementary_app/providers/user_provider.dart';
import 'package:supplementary_app/services/gemini_service.dart';
import 'package:supplementary_app/services/naver_service.dart';
import 'package:supplementary_app/services/store_service.dart';

class ResultViewModel extends ChangeNotifier {
  final GeminiService _geminiService = GeminiService();
  final NaverService _naverService = NaverService();
  final UserProvider _userProvider;
  final SupplementSurveyProvider _surveyProvider;

  ResultViewModel(BuildContext context)
    : _userProvider = Provider.of<UserProvider>(context, listen: false),
      _surveyProvider = Provider.of<SupplementSurveyProvider>(
        context,
        listen: false,
      );

  Future<RecommendItemModel> getRecommendations() async {
    final recommendation = await _geminiService.getRecommendSupplement(
      user: _userProvider.user!,
      survey: _surveyProvider.supplementSurveyModel!,
    );

    try {
      final imageUrl = await _naverService.getImageUrlFromNaverShopping(
        recommendation.name,
      );
      recommendation.imageLink = imageUrl;
    } catch (e) {
      print('이미지 로딩 실패: ${recommendation.name}');
    }
    await StoreService().saveToMyRecommendaions(
      _userProvider.user!.uid,
      recommendation,
    );
    return recommendation;
  }
}
