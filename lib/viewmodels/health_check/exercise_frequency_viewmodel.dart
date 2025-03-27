import 'package:flutter/material.dart';
import 'package:supplementary_app/providers/supplement_survey_provider.dart';

class ExerciseFrequencyViewModel extends ChangeNotifier {
  final SupplementSurveyProvider _surveyProvider;
  int? _selectedOption;
  int? get selectedOption => _selectedOption;

  ExerciseFrequencyViewModel({required SupplementSurveyProvider surveyProvider})
    : _surveyProvider = surveyProvider;

  final List<Map<String, dynamic>> exerciseOptions = [
    {'title': '거의 안 함', 'value': 0},
    {'title': '가볍게 주 1~2회', 'value': 1},
    {'title': '중강도 운동 주 3~4회', 'value': 3},
    {'title': '고강도 운동 주 5회 이상', 'value': 5},
  ];

  void selectOption(int value) {
    _selectedOption = value;
    notifyListeners();
  }

  void addToSurvey() {
    if (_selectedOption != null) {
      _surveyProvider.exerciseFrequencyPerWeek(_selectedOption!);
    }
  }
}
