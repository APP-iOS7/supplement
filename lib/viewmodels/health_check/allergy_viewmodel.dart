import 'package:flutter/material.dart';
import 'package:supplementary_app/providers/supplement_survey_provider.dart';

class AllergyViewModel extends ChangeNotifier {
  final SupplementSurveyProvider _surveyProvider;

  AllergyViewModel({required SupplementSurveyProvider surveyProvider})
    : _surveyProvider = surveyProvider;

  final List<String> allergyTypes = ['견과류', '갑각류', '대두', '글루텐', '특정 알러지'];
  List<String> selectedAllergies = [];
  String specificAllergyInput = '';
  bool? _hasAllergy;

  bool? get hasAllergy => _hasAllergy;

  bool get canProceed =>
      _hasAllergy != null &&
      (_hasAllergy == false || selectedAllergies.isNotEmpty) &&
      (!selectedAllergies.contains('특정 알러지') ||
          specificAllergyInput.isNotEmpty);

  void setHasAllergy() {
    _hasAllergy = true;
    notifyListeners();
  }

  void setHasNoAllergy() {
    _hasAllergy = false;
    selectedAllergies.clear();
    specificAllergyInput = '';
    notifyListeners();
  }

  void toggleAllergySelection(String type, bool selected) {
    if (selected) {
      selectedAllergies.add(type);
    } else {
      selectedAllergies.remove(type);
      if (type == '특정 알러지') {
        clearSpecificAllergyInput();
      }
    }
    notifyListeners();
  }

  void setSpecificAllergyInput(String input) {
    specificAllergyInput = input.trim();
    notifyListeners();
  }

  void clearSpecificAllergyInput() {
    specificAllergyInput = '';
    notifyListeners();
  }

  void addToSurvey() {
    if (_hasAllergy == null) return;

    if (_hasAllergy == false) {
      _surveyProvider.addAlergies([]);
      return;
    }

    List<String> allergies = List.from(selectedAllergies);
    if (allergies.contains('특정 알러지') && specificAllergyInput.isNotEmpty) {
      allergies.remove('특정 알러지');
      allergies.add(specificAllergyInput);
    }
    _surveyProvider.addAlergies(allergies);
  }
}
