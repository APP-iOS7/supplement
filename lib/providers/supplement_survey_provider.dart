import 'package:flutter/material.dart';
import 'package:supplementary_app/models/supplement_survey_model.dart';

class SupplementSurveyProvider with ChangeNotifier {
  SupplementSurveyModel? supplementSurveyModel;

  void _initSurvey() {
    supplementSurveyModel = SupplementSurveyModel();
    print('survey initiated');
    notifyListeners();
  }

  void addGoals(List<String> goals) {
    _initSurvey();
    if (supplementSurveyModel != null) {
      supplementSurveyModel!.goal.addAll(goals);
      print('$goals added');
      notifyListeners();
    }
  }

  void updateSmokingStatus(bool isSmoker) {
    if (supplementSurveyModel != null) {
      supplementSurveyModel!.isSmoker = isSmoker;
      print('smoker: $isSmoker');
      notifyListeners();
    }
  }

  void updateDrinkingStatus(bool isDrinker) {
    if (supplementSurveyModel != null) {
      supplementSurveyModel!.isDrinker = isDrinker;
      print('$isDrinker');
      notifyListeners();
    }
  }

  void addAlergies(List<String> alergies) {
    if (supplementSurveyModel != null) {
      supplementSurveyModel!.alergy.addAll(alergies);
      print(alergies);
      notifyListeners();
    }
  }

  void addPrescribedDrugs(List<String> prescribedDrugs) {
    if (supplementSurveyModel != null) {
      supplementSurveyModel!.prescribedDrugs.addAll(prescribedDrugs);
      notifyListeners();
    }
    print('${supplementSurveyModel?.prescribedDrugs}');
  }

  void exerciseFrequencyPerWeek(int frequency) {
    if (supplementSurveyModel != null) {
      supplementSurveyModel!.exerciseFrequencyPerWeek = frequency;
      notifyListeners();
    }
  }

  void removeSurveyModel() {
    supplementSurveyModel = null;
  }
}
