import 'package:flutter/material.dart';
import 'package:supplementary_app/providers/supplement_survey_provider.dart';

class DrinkingViewModel extends ChangeNotifier {
  final SupplementSurveyProvider _surveyProvider;
  bool? _isDrinker;

  DrinkingViewModel({required SupplementSurveyProvider surveyProvider})
    : _surveyProvider = surveyProvider;

  bool? get isDrinker => _isDrinker;

  void setToDrinker(bool value) {
    if (value) {
      _isDrinker = true;
      notifyListeners();
    }
  }

  void setToNonDrinker(bool value) {
    if (!value) {
      _isDrinker = false;
      notifyListeners();
    }
  }

  void saveDrinkingStatus() {
    if (_isDrinker != null) {
      _surveyProvider.updateDrinkingStatus(_isDrinker!);
    }
  }
}
