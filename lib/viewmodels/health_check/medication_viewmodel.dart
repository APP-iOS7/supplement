import 'package:flutter/material.dart';
import 'package:supplementary_app/providers/supplement_survey_provider.dart';

class MedicationViewModel extends ChangeNotifier {
  final SupplementSurveyProvider _surveyProvider;

  MedicationViewModel({required SupplementSurveyProvider surveyProvider})
    : _surveyProvider = surveyProvider;

  String? selectedOption;
  String medicationInput = '';

  bool get isNextButtonEnabled =>
      selectedOption != null &&
      (selectedOption != '복용중인 약 있음' || medicationInput.isNotEmpty);

  void selectOption(String value) {
    selectedOption = value;
    if (value == '복용중인 약 없음') {
      medicationInput = '';
    }
    notifyListeners();
  }

  void setMedicationInput(String input) {
    medicationInput = input.trim();
    notifyListeners();
  }

  void clearMedicationInput() {
    medicationInput = '';
    notifyListeners();
  }

  void addToSurvey() {
    List<String> medications = [];
    if (selectedOption == '복용중인 약 있음' && medicationInput.isNotEmpty) {
      medications =
          medicationInput
              .split(',')
              .map((e) => e.trim())
              .where((e) => e.isNotEmpty)
              .toList();
    }
    _surveyProvider.addPrescribedDrugs(medications);
  }
}
