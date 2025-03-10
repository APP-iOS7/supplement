import 'package:flutter/material.dart';
import 'package:supplementary_app/providers/supplement_survey_provider.dart';

class MedicationViewModel extends ChangeNotifier {
  final SupplementSurveyProvider _surveyProvider;
  bool? _hasMedication;
  String medicationInput = '';

  MedicationViewModel({required SupplementSurveyProvider surveyProvider})
    : _surveyProvider = surveyProvider;

  bool? get hasMedication => _hasMedication;

  bool get canProceed =>
      _hasMedication != null &&
      (_hasMedication == false || medicationInput.isNotEmpty);

  void setHasMedication() {
    _hasMedication = true;
    notifyListeners();
  }

  void setHasNoMedication() {
    _hasMedication = false;
    medicationInput = '';
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
    if (_hasMedication == null) return;

    if (_hasMedication == false) {
      _surveyProvider.addPrescribedDrugs([]);
      return;
    }

    if (medicationInput.isNotEmpty) {
      final medications =
          medicationInput
              .split(',')
              .map((e) => e.trim())
              .where((e) => e.isNotEmpty)
              .toList();
      _surveyProvider.addPrescribedDrugs(medications);
    }
  }
}
