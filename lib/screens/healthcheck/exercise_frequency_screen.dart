import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:supplementary_app/providers/supplement_survey_provider.dart';
import 'package:supplementary_app/screens/healthcheck/result_screen.dart';
import 'package:supplementary_app/viewmodels/health_check/exercise_frequency_viewmodel.dart';
import 'package:supplementary_app/widgets/exercise_option_card.dart';
import 'package:supplementary_app/widgets/next_button.dart';

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
      child: const _ExerciseFrequencyScreen(),
    );
  }
}

class _ExerciseFrequencyScreen extends StatelessWidget {
  const _ExerciseFrequencyScreen();

  @override
  Widget build(BuildContext context) {
    final viewModel = Provider.of<ExerciseFrequencyViewModel>(context);
    final theme = Theme.of(context);

    return Scaffold(
      appBar: AppBar(),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('운동 빈도', style: theme.textTheme.headlineMedium),
            const SizedBox(height: 10),
            Text(
              '운동을 얼마나 자주 하나요?',
              style: theme.textTheme.bodyMedium?.copyWith(color: Colors.grey),
            ),
            const SizedBox(height: 30),
            ...viewModel.exerciseOptions.map(
              (option) => Padding(
                padding: const EdgeInsets.only(bottom: 16.0),
                child: ExerciseOptionCard(
                  title: option['title']!,
                  value: option['value']!,
                  selectedValue: viewModel.selectedOption ?? '',
                  onTap: viewModel.selectOption,
                ),
              ),
            ),
            const Spacer(),
            NextButton(
              canProceed: viewModel.selectedOption != null,
              nextPage: const ResultScreen(),
              onTap: viewModel.addToSurvey,
            ),
          ],
        ),
      ),
    );
  }
}
