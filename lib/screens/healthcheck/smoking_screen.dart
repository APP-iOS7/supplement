import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:supplementary_app/providers/supplement_survey_provider.dart';
import 'package:supplementary_app/screens/healthcheck/drinking_screen.dart';
import 'package:supplementary_app/viewmodels/health_check/smoking_viewmodel.dart';
import 'package:supplementary_app/widgets/option_card.dart';

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
      child: const _SmokingScreenContent(),
    );
  }
}

class _SmokingScreenContent extends StatelessWidget {
  const _SmokingScreenContent();

  @override
  Widget build(BuildContext context) {
    final viewModel = Provider.of<SmokingViewModel>(context);

    return Scaffold(
      appBar: AppBar(),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              '흡연 여부에 대해\n알려주세요',
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 10),
            const Text(
              '흡연을 하시는 경우 조심해야 할\n영양 성분이 있어요',
              style: TextStyle(color: Colors.grey, fontSize: 16),
            ),
            const SizedBox(height: 30),
            OptionCard(
              title: '비흡연',
              value: '비흡연',
              selectedValue: viewModel.selectedOption ?? '',
              onTap: viewModel.setSelectedOption,
            ),
            const SizedBox(height: 16),
            OptionCard(
              title: '흡연',
              value: '흡연',
              selectedValue: viewModel.selectedOption ?? '',
              onTap: viewModel.setSelectedOption,
            ),
            const Spacer(),
            SizedBox(
              width: double.infinity,
              height: 56,
              child: ElevatedButton(
                onPressed:
                    viewModel.selectedOption != null
                        ? () {
                          viewModel.saveSmokingStatus();
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => const DrinkingScreen(),
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
            ),
          ],
        ),
      ),
    );
  }
}
