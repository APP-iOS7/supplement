import 'package:flutter/material.dart';
import 'package:supplementary_app/providers/supplement_survey_provider.dart';

class AllergyViewModel extends ChangeNotifier {
  final SupplementSurveyProvider _surveyProvider;

  AllergyViewModel({required SupplementSurveyProvider surveyProvider})
    : _surveyProvider = surveyProvider;

  String? selectedOption;
  final List<String> allergyTypes = ['견과류', '갑각류', '대두', '글루텐', '특정 알러지'];
  List<String> selectedAllergies = [];
  String specificAllergyInput = '';

  bool get isNextButtonEnabled =>
      selectedOption != null &&
      (selectedOption != '알러지가 있어요' || selectedAllergies.isNotEmpty) &&
      (!selectedAllergies.contains('특정 알러지') ||
          specificAllergyInput.isNotEmpty);

  void setSelectedOption(String option) {
    selectedOption = option;
    if (option == '알러지가 없어요') {
      selectedAllergies.clear();
      specificAllergyInput = '';
    }
    notifyListeners();
  }

  void toggleAllergy(String type) {
    if (selectedAllergies.contains(type)) {
      selectedAllergies.remove(type);
      if (type == '특정 알러지') {
        specificAllergyInput = '';
      }
    } else {
      selectedAllergies.add(type);
    }
    notifyListeners();
  }

  void setSpecificAllergy(String input) {
    specificAllergyInput = input;
    notifyListeners();
  }

  void clearAllergies() {
    selectedAllergies.clear();
    notifyListeners();
  }

  void clearSpecificAllergyInput() {
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

  void addToSurvey() {
    List<String> allergies = List.from(selectedAllergies);
    if (allergies.contains('특정 알러지') && specificAllergyInput.isNotEmpty) {
      allergies.add(specificAllergyInput);
    }
    allergies.remove('특정 알러지');
    _surveyProvider.addAlergies(allergies);
  }

  void selectOption(String value) {
    selectedOption = value;
    if (value == '알러지가 없어요') {
      clearAllergies();
      clearSpecificAllergyInput();
    }
    notifyListeners();
  }
}
