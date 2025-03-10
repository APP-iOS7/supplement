import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:supplementary_app/providers/supplement_survey_provider.dart';
import 'package:supplementary_app/screens/healthcheck/drinking_screen.dart';
import 'package:supplementary_app/viewmodels/health_check/health_check_style_viewmodel.dart';
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
      child: _SmokingScreen(),
    );
  }
}

class _SmokingScreen extends StatelessWidget {
  final styleViewModel = HealthCheckStyleViewModel();
  
  @override
  Widget build(BuildContext context) {
    final viewModel = Provider.of<SmokingViewModel>(context);
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;

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
            // _buildOptionCard 대신 OptionCard 위젯 사용
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
                child: Text(
                  '다음',
                  style: styleViewModel.buttonTextStyle,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  // 이 메서드는 더 이상 사용되지 않으므로 제거하거나 수정할 수 있습니다
  Widget _buildOptionCard(
    BuildContext context,
    bool isDarkMode,
    String value,
    SmokingViewModel viewModel,
  ) {
    final isSelected = value == viewModel.selectedOption;
    
    return GestureDetector(
      onTap: () => viewModel.setSelectedOption(value), // selectOption에서 setSelectedOption으로 변경
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 20),
        decoration: BoxDecoration(
          color: isSelected 
              ? Theme.of(context).colorScheme.primary 
              : Colors.white, // 이미 primary color로 설정되어 있음
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: isSelected 
                ? Theme.of(context).colorScheme.primary 
                : Colors.grey.withOpacity(0.3),
          ),
        ),
        child: Text(
          value,
          style: styleViewModel.optionTextStyle,
        ),
      ),
    );
  }
}
