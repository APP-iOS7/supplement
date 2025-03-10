import 'package:flutter/material.dart';
import 'package:supplementary_app/providers/supplement_survey_provider.dart';

class SmokingViewModel extends ChangeNotifier {
  final SupplementSurveyProvider _surveyProvider;
  bool? _isSmoker;

  SmokingViewModel({required SupplementSurveyProvider surveyProvider})
    : _surveyProvider = surveyProvider;

  bool? get isSmoker => _isSmoker;

  void setToSmoker() {
    _isSmoker = true;
    notifyListeners();
  }

  void setToNonSmoker() {
    _isSmoker = false;
    notifyListeners();
  }

  void saveSmokingStatus() {
    if (_isSmoker != null) {
      _surveyProvider.addSmokingStatus(_isSmoker!);
    }
  }
}
