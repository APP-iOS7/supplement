import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:supplementary_app/providers/supplement_survey_provider.dart';
import 'package:supplementary_app/screens/healthcheck/allergy_screen.dart';
import 'package:supplementary_app/viewmodels/health_check/drinking_viewmodel.dart';
import 'package:supplementary_app/viewmodels/health_check/health_check_style_viewmodel.dart';
import 'package:supplementary_app/widgets/option_card.dart'; // 추가

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
      child: Consumer<DrinkingViewModel>(
        builder: (context, viewModel, child) {
          return _DrinkingScreen(viewModel: viewModel); // const 제거
        },
      ),
    );
  }
}

class _DrinkingScreen extends StatelessWidget {
  _DrinkingScreen({required this.viewModel}); // const 제거
  final DrinkingViewModel viewModel;
  final styleViewModel = HealthCheckStyleViewModel();

  @override
  Widget build(BuildContext context) {
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;
    
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
            // _buildOptionCard 대신 OptionCard 위젯 사용
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

  Widget _buildOptionCard(
    BuildContext context,
    bool isDarkMode,
    String value,
    DrinkingViewModel viewModel,
  ) {
    final isSelected = value == viewModel.selectedOption;
    
    return GestureDetector(
      onTap: () => viewModel.setSelectedOption(value),
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 20),
        decoration: BoxDecoration(
          color: isSelected 
              ? Theme.of(context).colorScheme.primary 
              : Colors.white, // 항상 흰색 배경
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: isSelected 
                ? Theme.of(context).colorScheme.primary 
                : Colors.grey.withOpacity(0.3),
          ),
        ),
        child: Text(
          value,
          style: styleViewModel.optionTextStyle, // 수정
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
        child: Text(
          '다음',
          style: styleViewModel.buttonTextStyle, // 수정
        ),
      ),
    );
  }
}
