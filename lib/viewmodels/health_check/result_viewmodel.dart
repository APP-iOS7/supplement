import 'dart:async';
import 'package:flutter/material.dart';
import 'package:supplementary_app/models/gemini_answer_model.dart';
import 'package:supplementary_app/providers/supplement_survey_provider.dart';
import 'package:supplementary_app/providers/user_provider.dart';
import 'package:supplementary_app/services/gemini_service.dart';
import 'package:supplementary_app/services/naver_service.dart';

class ResultViewModel extends ChangeNotifier {
  final GeminiService _geminiService = GeminiService();
  final NaverService _naverService = NaverService();
  final UserProvider _userProvider;
  final SupplementSurveyProvider _surveyProvider;

  ResultViewModel({
    required UserProvider userProvider,
    required SupplementSurveyProvider surveyProvider,
  }) : _userProvider = userProvider,
       _surveyProvider = surveyProvider;

  Future<AnswerModel> getRecommendations() async {
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

    return recommendation;
  }
}
