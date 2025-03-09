import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:supplementary_app/providers/supplement_survey_provider.dart';
import 'package:supplementary_app/screens/healthcheck/exercise_frequency_screen.dart';
import 'package:supplementary_app/viewmodels/health_check/medication_viewmodel.dart';
import 'package:supplementary_app/widgets/option_card.dart';
import 'package:supplementary_app/viewmodels/health_check/health_check_style_viewmodel.dart'; // 추가

class MedicationScreen extends StatelessWidget {
  const MedicationScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create:
          (_) => MedicationViewModel(
            surveyProvider: Provider.of<SupplementSurveyProvider>(
              context,
              listen: false,
            ),
          ),
      child: _MedicationScreenView(), // const 제거
    );
  }
}

class _MedicationScreenView extends StatelessWidget {
  _MedicationScreenView(); // const 제거
  final styleViewModel = HealthCheckStyleViewModel();

  @override
  Widget build(BuildContext context) {
    final viewModel = Provider.of<MedicationViewModel>(context);
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      appBar: AppBar(),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              '복용중인 약이 있다면\n알려주세요',
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 10),
            const Text(
              '영양제와 함께 복용시 주의해야 할\n약물이 있는지 확인해드릴게요',
              style: TextStyle(color: Colors.grey, fontSize: 16),
            ),
            const SizedBox(height: 30),
            OptionCard(
              title: '복용중인 약 없음',
              value: '복용중인 약 없음',
              selectedValue: viewModel.selectedOption ?? '',
              onTap: viewModel.selectOption,
            ),
            const SizedBox(height: 16),
            OptionCard(
              title: '복용중인 약 있음',
              value: '복용중인 약 있음',
              selectedValue: viewModel.selectedOption ?? '',
              onTap: viewModel.selectOption,
            ),
            
            if (viewModel.selectedOption == '복용중인 약 있음')
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const SizedBox(height: 20),
                    Container(
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: Colors.grey.shade100,
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(color: Colors.grey.shade300),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                '복용중인 약을 입력해주세요',
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 16,
                                  color: isDarkMode ? Colors.black : Colors.black,
                                ),
                              ),
                              IconButton(
                                icon: const Icon(Icons.edit, size: 20),
                                color: Theme.of(context).colorScheme.primary,
                                onPressed:
                                    () => _showMedicationDialog(
                                      context,
                                      viewModel,
                                    ),
                              ),
                            ],
                          ),
                          if (viewModel.medicationInput.isNotEmpty)
                            Padding(
                              padding: const EdgeInsets.only(top: 8.0),
                              child: Text(
                                viewModel.medicationInput,
                                style: const TextStyle(
                                  fontSize: 16,
                                  color: Colors.black87,
                                ),
                              ),
                            ),
                          const SizedBox(height: 8),
                          const Text(
                            '여러 약을 복용 중이라면 쉼표(,)로 구분해주세요',
                            style: TextStyle(color: Colors.grey, fontSize: 12),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              )
            else
              const Spacer(),

            SizedBox(
              width: double.infinity,
              height: 56,
              child: ElevatedButton(
                onPressed:
                    viewModel.isNextButtonEnabled
                        ? () {
                          viewModel.addToSurvey();
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder:
                                  (context) => const ExerciseFrequencyScreen(),
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
                  style: const TextStyle(
                    color: Colors.black,
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                  ), // 직접 검정색 스타일 지정
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _showMedicationDialog(
    BuildContext context,
    MedicationViewModel viewModel,
  ) {
    final controller = TextEditingController(text: viewModel.medicationInput);

    showDialog(
      context: context,
      builder:
          (context) => AlertDialog(
            title: const Text('복용중인 약 입력'),
            content: TextField(
              controller: controller,
              decoration: const InputDecoration(
                hintText: '예: 혈압약, 당뇨약, 항생제 등',
                border: OutlineInputBorder(),
              ),
              maxLines: 3,
              autofocus: true,
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(context),
                style: TextButton.styleFrom(
                  side: const BorderSide(color: Colors.black, width: 1.0), // 검정색 테두리 추가
                ),
                child: Text('취소', style: styleViewModel.optionTextStyle), // 수정
              ),
              ElevatedButton(
                onPressed: () {
                  viewModel.setMedicationInput(controller.text);
                  Navigator.pop(context);
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Color.fromARGB(255, 81, 186, 123),
                ),
                child: Text('확인', style: styleViewModel.buttonTextStyle), // 수정
              ),
            ],
          ),
    );
  }
}
