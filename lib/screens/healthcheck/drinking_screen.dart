import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:supplementary_app/providers/supplement_survey_provider.dart';
import 'package:supplementary_app/screens/healthcheck/allergy_screen.dart';
import 'package:supplementary_app/viewmodels/health_check/drinking_viewmodel.dart';
import 'package:supplementary_app/widgets/option_cards.dart';
import 'package:supplementary_app/widgets/next_button.dart';

class DrinkingScreen extends StatelessWidget {
  const DrinkingScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create:
          (_) => DrinkingViewModel(
            surveyProvider: Provider.of<SupplementSurveyProvider>(
              context,
              listen: false,
            ),
          ),
      child: const _DrinkingScreen(),
    );
  }
}

class _DrinkingScreen extends StatelessWidget {
  const _DrinkingScreen();

  @override
  Widget build(BuildContext context) {
    final viewModel = Provider.of<DrinkingViewModel>(context);
    final theme = Theme.of(context);

    return Scaffold(
      appBar: AppBar(),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('음주 여부에 대해\n알려주세요', style: theme.textTheme.headlineMedium),
            const SizedBox(height: 10),
            Text(
              '음주를 하시는 경우 조심해야 할\n영양 성분이 있어요',
              style: theme.textTheme.bodyMedium?.copyWith(color: Colors.grey),
            ),
            const SizedBox(height: 30),
            OptionCard<bool>(
              title: '비음주',
              value: false,
              selectedValue: viewModel.isDrinker,
              onTap: viewModel.setToNonDrinker,
            ),
            const SizedBox(height: 16),
            OptionCard<bool>(
              title: '음주',
              value: true,
              selectedValue: viewModel.isDrinker,
              onTap: viewModel.setToDrinker,
            ),
            const Spacer(),
            NextButton(
              canProceed: viewModel.isDrinker != null,
              nextPage: const AllergyScreen(),
              onTap: viewModel.saveDrinkingStatus,
            ),
          ],
        ),
      ),
    );
  }
}
