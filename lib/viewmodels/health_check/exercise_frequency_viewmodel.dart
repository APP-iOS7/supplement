import 'package:flutter/material.dart';
import 'package:supplementary_app/providers/supplement_survey_provider.dart';

class ExerciseFrequencyViewModel extends ChangeNotifier {
  final SupplementSurveyProvider _surveyProvider;
  String? selectedOption;

  ExerciseFrequencyViewModel({required SupplementSurveyProvider surveyProvider})
    : _surveyProvider = surveyProvider;

  final List<Map<String, String>> exerciseOptions = [
    {'title': '거의 안 함', 'value': '거의 안 함'},
    {'title': '가볍게 주 1~2회', 'value': '가볍게 주 1~2회'},
    {'title': '중강도 운동 주 3~4회', 'value': '중강도 운동 주 3~4회'},
    {'title': '고강도 운동 주 5회 이상', 'value': '고강도 운동 주 5회 이상'},
  ];

  void selectOption(String value) {
    selectedOption = value;
    notifyListeners();
  }

  void addToSurvey() {
    if (selectedOption != null) {
      final frequency = _convertToFrequency(selectedOption!);
      _surveyProvider.exerciseFrequencyPerWeek(frequency);
    }
  }

  int _convertToFrequency(String option) {
    switch (option) {
      case '거의 안 함':
        return 0;
      case '가볍게 주 1~2회':
        return 2;
      case '중강도 운동 주 3~4회':
        return 4;
      case '고강도 운동 주 5회 이상':
        return 5;
      default:
        return 0;
    }
  }
}
