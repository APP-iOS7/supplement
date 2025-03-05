import 'package:flutter/material.dart';

class HealthConcernViewModel extends ChangeNotifier {
  final List<Map<String, dynamic>> healthConcerns = [
    {
      'title': '면역력 강화',
      'icon': 'assets/icons/immune.png',
      'color': const Color.fromARGB(255, 255, 231, 247),
      'isSelected': false,
      'tag': '',
    },
    {
      'title': '체중 감량/근육 증가',
      'fontSize': 1,
      'icon': 'assets/icons/muscle.png',
      'color': const Color.fromARGB(255, 255, 231, 247),
      'isSelected': false,
      'tag': '',
    },
    {
      'title': '피로 회복',
      'icon': 'assets/icons/tiredness.png',
      'color': const Color.fromARGB(255, 255, 231, 247),
      'isSelected': false,
      'tag': '',
    },
    {
      'title': '피부 건강',
      'icon': 'assets/icons/depilation.png',
      'color': const Color.fromARGB(255, 255, 231, 247),
      'isSelected': false,
      'tag': '',
    },
    {
      'title': '심혈관 건강',
      'icon': 'assets/icons/heart.png',
      'color': const Color.fromARGB(255, 255, 231, 247),
      'isSelected': false,
      'tag': '',
    },
    {
      'title': '뇌 기능 & 기억력',
      'icon': 'assets/icons/brainstorm.png',
      'color': const Color.fromARGB(255, 255, 231, 247),
      'isSelected': false,
      'tag': '',
    },
    {
      'title': '눈 건강',
      'icon': 'assets/icons/eyes.png',
      'color': const Color.fromARGB(255, 255, 231, 247),
      'isSelected': false,
      'tag': '',
    },
    {
      'title': '소화 건강 / 장 건강',
      'icon': 'assets/icons/stomach.png',
      'color': const Color.fromARGB(255, 255, 231, 247),
      'isSelected': false,
      'tag': '',
    },
    {
      'title': '혈당 조절',
      'icon': 'assets/icons/sugarblood.png',
      'color': const Color.fromARGB(255, 255, 231, 247),
      'isSelected': false,
      'tag': '',
    },
    {
      'title': '갱년기 건강',
      'icon': 'assets/icons/menopause.png',
      'color': const Color.fromARGB(255, 255, 231, 247),
      'isSelected': false,
      'tag': '',
    },
    {
      'title': '스트레스 완화',
      'icon': 'assets/icons/headache.png',
      'color': const Color.fromARGB(255, 255, 231, 247),
      'isSelected': false,
      'tag': '',
    },
    {
      'title': '치아 건강',
      'icon': 'assets/icons/tooth.png',
      'color': const Color.fromARGB(255, 255, 231, 247),
      'isSelected': false,
      'tag': '',
    },
  ];

  int _selectedCount = 0;
  final int maxSelections = 8;

  int get selectedCount => _selectedCount;

  void toggleSelection(int index) {
    if (healthConcerns[index]['isSelected']) {
      healthConcerns[index]['isSelected'] = false;
      _selectedCount--;
    } else if (_selectedCount < maxSelections) {
      healthConcerns[index]['isSelected'] = true;
      _selectedCount++;
    }
    notifyListeners();
  }
}
