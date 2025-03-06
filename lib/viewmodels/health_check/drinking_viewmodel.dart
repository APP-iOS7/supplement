import 'package:flutter/material.dart';
import 'package:supplementary_app/providers/supplement_survey_provider.dart';

class DrinkingViewModel extends ChangeNotifier {
  final SupplementSurveyProvider _surveyProvider;
  bool? _isDrinker;

  DrinkingViewModel({required SupplementSurveyProvider surveyProvider})
    : _surveyProvider = surveyProvider;

  bool? get isDrinker => _isDrinker;
  String? get selectedOption =>
      _isDrinker == null
          ? null
          : _isDrinker!
          ? '음주'
          : '비음주';

  void setSelectedOption(String value) {
    _isDrinker = value == '음주';
    notifyListeners();
  }

  void saveDrinkingStatus() {
    if (_isDrinker != null) {
      _surveyProvider.addDrinkingStatus(_isDrinker!);
    }
  }
}
