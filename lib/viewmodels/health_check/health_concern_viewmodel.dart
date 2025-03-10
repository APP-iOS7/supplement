import 'package:flutter/material.dart';
import 'package:supplementary_app/providers/supplement_survey_provider.dart';

class HealthConcern {
  final String title;
  final String iconPath;
  bool isSelected;

  HealthConcern({
    required this.title,
    required this.iconPath,
    this.isSelected = false,
  });
}

class HealthConcernViewModel extends ChangeNotifier {
  final SupplementSurveyProvider _surveyProvider;

  HealthConcernViewModel({required SupplementSurveyProvider surveyProvider})
    : _surveyProvider = surveyProvider;

  final List<HealthConcern> healthConcerns = [
    HealthConcern(title: '면역력 강화', iconPath: 'assets/icons/immune.png'),
    HealthConcern(title: '체중 감량/근육 증가', iconPath: 'assets/icons/muscle.png'),
    HealthConcern(title: '피로 회복', iconPath: 'assets/icons/tiredness.png'),
    HealthConcern(title: '피부 건강', iconPath: 'assets/icons/depilation.png'),
    HealthConcern(title: '심혈관 건강', iconPath: 'assets/icons/heart.png'),
    HealthConcern(title: '뇌 기능 & 기억력', iconPath: 'assets/icons/brainstorm.png'),
    HealthConcern(title: '눈 건강', iconPath: 'assets/icons/eyes.png'),
    HealthConcern(title: '소화 건강 / 장 건강', iconPath: 'assets/icons/stomach.png'),
    HealthConcern(title: '혈당 조절', iconPath: 'assets/icons/sugarblood.png'),
    HealthConcern(title: '갱년기 건강', iconPath: 'assets/icons/menopause.png'),
    HealthConcern(title: '스트레스 완화', iconPath: 'assets/icons/headache.png'),
    HealthConcern(title: '치아 건강', iconPath: 'assets/icons/tooth.png'),
  ];

  int _selectedCount = 0;
  final int maxSelections = 3;

  int get selectedCount => _selectedCount;

  void toggleSelection(int index) {
    if (healthConcerns[index].isSelected) {
      healthConcerns[index].isSelected = false;
      _selectedCount--;
    } else if (_selectedCount < maxSelections) {
      healthConcerns[index].isSelected = true;
      _selectedCount++;
    }
    notifyListeners();
  }

  void addToSurvey() {
    List<String> selectedConcerns =
        healthConcerns
            .where((concern) => concern.isSelected)
            .map((concern) => concern.title)
            .toList();

    _surveyProvider.addGoals(selectedConcerns);
  }
}
