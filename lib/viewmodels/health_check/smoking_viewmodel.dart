import 'package:flutter/material.dart';
import 'package:supplementary_app/providers/supplement_survey_provider.dart';

class SmokingViewModel extends ChangeNotifier {
  final SupplementSurveyProvider _surveyProvider;
  bool? _isSmoker;
  
  // 다크모드에서 사용할 텍스트 색상 추가
  final Color darkModeTextColor = Colors.black;

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
  
  // 다크모드에 따른 텍스트 색상을 반환하는 메서드
  Color getTextColor(BuildContext context, bool isSelected) {
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;
    if (isSelected) {
      return Colors.white; // 선택된 경우 항상 흰색
    } else {
      return isDarkMode ? darkModeTextColor : Colors.black; // 다크모드면 검정색, 아니면 기본 검정색
    }
  }
}
