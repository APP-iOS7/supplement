import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:supplementary_app/providers/supplement_survey_provider.dart';
import 'package:supplementary_app/screens/healthcheck/allergy_screen.dart';
import 'package:supplementary_app/viewmodels/health_check/drinking_viewmodel.dart';
import 'package:supplementary_app/widgets/option_card.dart';

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

    return Scaffold(
      appBar: AppBar(),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              '음주 여부에 대해\n알려주세요',
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 10),
            const Text(
              '음주를 하시는 경우 조심해야 할\n영양 성분이 있어요',
              style: TextStyle(color: Colors.grey, fontSize: 16),
            ),
            const SizedBox(height: 30),
            OptionCard(
              title: '비음주',
              value: '비음주',
              selectedValue: viewModel.selectedOption ?? '',
              onTap: viewModel.setSelectedOption,
            ),
            const SizedBox(height: 16),
            OptionCard(
              title: '음주',
              value: '음주',
              selectedValue: viewModel.selectedOption ?? '',
              onTap: viewModel.setSelectedOption,
            ),
            const Spacer(),
            _buildNextButton(context, viewModel),
          ],
        ),
      ),
    );
  }

  Widget _buildNextButton(BuildContext context, DrinkingViewModel viewModel) {
    return SizedBox(
      width: double.infinity,
      height: 56,
      child: ElevatedButton(
        onPressed:
            viewModel.selectedOption != null
                ? () {
                  viewModel.saveDrinkingStatus();
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const AllergyScreen(),
                    ),
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
          '다음',
          style: TextStyle(
            color: Colors.white,
            fontSize: 18,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    );
  }
}
