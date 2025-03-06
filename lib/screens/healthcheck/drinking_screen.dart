import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:supplementary_app/providers/supplement_survey_provider.dart';
import 'package:supplementary_app/screens/healthcheck/allergy_screen.dart';
import 'package:supplementary_app/viewmodels/health_check/drinking_viewmodel.dart';

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
            _buildOptionCard('비음주', '비음주', viewModel),
            const SizedBox(height: 16),
            _buildOptionCard('음주', '음주', viewModel),
            const Spacer(),
            _buildNextButton(context, viewModel),
          ],
        ),
      ),
    );
  }

  Widget _buildOptionCard(
    String title,
    String value,
    DrinkingViewModel viewModel,
  ) {
    final isSelected = viewModel.selectedOption == value;

    return GestureDetector(
      onTap: () => viewModel.setSelectedOption(value),
      child: Container(
        width: double.infinity,
        height: 80,
        decoration: BoxDecoration(
          color: isSelected ? Colors.blue.shade50 : Colors.grey.shade100,
          borderRadius: BorderRadius.circular(16),
          border:
              isSelected
                  ? Border.all(color: Colors.deepPurple, width: 2)
                  : null,
        ),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                title,
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                ),
              ),
              if (isSelected)
                Container(
                  width: 24,
                  height: 24,
                  decoration: const BoxDecoration(
                    color: Colors.deepPurple,
                    shape: BoxShape.circle,
                  ),
                  child: const Icon(Icons.check, color: Colors.white, size: 16),
                ),
            ],
          ),
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
          backgroundColor: Colors.deepPurple,
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
