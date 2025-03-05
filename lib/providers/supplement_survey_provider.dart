import 'package:flutter/material.dart';
import 'package:supplementary_app/models/supplement_survey_model.dart';

class SupplementSurveyProvider with ChangeNotifier {
  SupplementSurveyModel? supplementSurveyModel;

  void startSurvey() {
    supplementSurveyModel = SupplementSurveyModel();
    notifyListeners();
  }

  void addGoals(List<String> goals) {
    if (supplementSurveyModel != null) {
      supplementSurveyModel!.goal.addAll(goals);
      notifyListeners();
    }
  }

  void addSmokingAndDrinking(bool isSmoker, bool isDrinker) {
    if (supplementSurveyModel != null) {
      supplementSurveyModel!.isSmoker = isSmoker;
      supplementSurveyModel!.isDerinker = isDrinker;
      notifyListeners();
    }
  }

  void addAlergies(List<String> alergies) {
    if (supplementSurveyModel != null) {
      supplementSurveyModel!.alergy.addAll(alergies);
      notifyListeners();
    }
  }

  void addPrescribedDrugs(List<String> prescribedDrugs) {
    if (supplementSurveyModel != null) {
      supplementSurveyModel!.prescribedDrugs.addAll(prescribedDrugs);
      notifyListeners();
    }
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

