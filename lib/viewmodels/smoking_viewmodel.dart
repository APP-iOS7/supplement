import 'package:flutter/material.dart';
import 'package:supplementary_app/providers/supplement_survey_provider.dart';

class SmokingViewModel extends ChangeNotifier {
  final SupplementSurveyProvider _surveyProvider;
  bool? _isSmoker;

  SmokingViewModel({required SupplementSurveyProvider surveyProvider})
    : _surveyProvider = surveyProvider;

  bool? get isSmoker => _isSmoker;
  String? get selectedOption =>
      _isSmoker == null
          ? null
          : _isSmoker!
          ? '흡연'
          : '비흡연';

  void setSelectedOption(String value) {
    _isSmoker = value == '흡연';
    notifyListeners();
  }

  void saveSmokingStatus() {
    if (_isSmoker != null) {
      _surveyProvider.addSmokingStatus(_isSmoker!);
    }
  }
}
