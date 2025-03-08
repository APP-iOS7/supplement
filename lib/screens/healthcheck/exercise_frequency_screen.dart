import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:supplementary_app/providers/supplement_survey_provider.dart';
import 'package:supplementary_app/screens/healthcheck/result_screen.dart';
import 'package:supplementary_app/viewmodels/health_check/exercise_frequency_viewmodel.dart';
import 'package:supplementary_app/widgets/option_card.dart';

class ExerciseFrequencyScreen extends StatelessWidget {
  const ExerciseFrequencyScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create:
          (_) => ExerciseFrequencyViewModel(
            surveyProvider: Provider.of<SupplementSurveyProvider>(
              context,
              listen: false,
            ),
          ),
      child: Consumer<ExerciseFrequencyViewModel>(
        builder: (context, viewModel, child) {
          return _ExerciseFrequencyScreen(viewModel: viewModel);
        },
      ),
    );
  }
}

class _ExerciseFrequencyScreen extends StatelessWidget {
  const _ExerciseFrequencyScreen({required this.viewModel});
  final ExerciseFrequencyViewModel viewModel;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              '운동 빈도',
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 10),
            const Text(
              '운동을 얼마나 자주 하나요?',
              style: TextStyle(color: Colors.grey, fontSize: 16),
            ),
            const SizedBox(height: 30),

            ...viewModel.exerciseOptions.map(
              (option) => Column(
                children: [
                  OptionCard(
                    title: option['title']!,
                    value: option['value']!,
                    selectedValue: viewModel.selectedOption ?? '',
                    onTap: viewModel.selectOption,
                  ),
                  const SizedBox(height: 16),
                ],
              ),
            ),

            const Spacer(),

            SizedBox(
              width: double.infinity,
              height: 56,
              child: ElevatedButton(
                onPressed:
                    viewModel.selectedOption != null
                        ? () {
                          viewModel.addToSurvey();
                          Navigator.pushAndRemoveUntil(
                            context,
                            MaterialPageRoute(
                              builder: (context) => const ResultScreen(),
                            ),
                            (route) => false,
                          );
                        }
                        : null,
                style: ElevatedButton.styleFrom(
                  backgroundColor: Theme.of(context).colorScheme.primary,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                child: const Text(
                  '결과 보기',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
