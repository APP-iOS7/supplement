class SupplementSurveyModel {
  final List<String> goal = [];
  final bool? isSmoker;
  final bool? isDerinker;
  final List<String>? alergy;
  final List<String>? prescribedDrugs;
  final int? exerciseFrequencyPerWeek;

  SupplementSurveyModel({
    required this.isSmoker,
    required this.isDerinker,
    required this.alergy,
    required this.prescribedDrugs,
    required this.exerciseFrequencyPerWeek,
  });
}
