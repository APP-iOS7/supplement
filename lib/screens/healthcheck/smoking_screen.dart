import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:supplementary_app/providers/supplement_survey_provider.dart';
import 'package:supplementary_app/screens/healthcheck/drinking_screen.dart';
import 'package:supplementary_app/viewmodels/health_check/smoking_viewmodel.dart';
import 'package:supplementary_app/widgets/next_button.dart';
import 'package:supplementary_app/widgets/option_cards.dart';

class SmokingScreen extends StatelessWidget {
  const SmokingScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create:
          (_) => SmokingViewModel(
            surveyProvider: Provider.of<SupplementSurveyProvider>(
              context,
              listen: false,
            ),
          ),
      child: const _SmokingScreen(),
    );
  }
}

class _SmokingScreen extends StatelessWidget {
  const _SmokingScreen();

  @override
  Widget build(BuildContext context) {
    final viewModel = Provider.of<SmokingViewModel>(context);
    final theme = Theme.of(context);

    return Scaffold(
      appBar: AppBar(),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('흡연 여부에 대해\n알려주세요', style: theme.textTheme.headlineMedium),
            const SizedBox(height: 10),
            Text(
              '흡연을 하시는 경우 조심해야 할\n영양 성분이 있어요',
              style: theme.textTheme.bodyMedium?.copyWith(color: Colors.grey),
            ),
            const SizedBox(height: 30),
            SurveyOptionCard(
              title: '비흡연',
              value: false,
              selectedValue: viewModel.isSmoker,
              onTap: viewModel.setToNonSmoker,
            ),
            const SizedBox(height: 16),
            SurveyOptionCard(
              title: '흡연',
              value: true,
              selectedValue: viewModel.isSmoker,
              onTap: viewModel.setToSmoker,
            ),
            const Spacer(),
            NextButton(
              canProceed: viewModel.isSmoker != null,
              nextPage: const DrinkingScreen(),
              onTap: viewModel.saveSmokingStatus,
            ),
          ],
        ),
      ),
    );
  }
}
