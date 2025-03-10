import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:supplementary_app/providers/supplement_survey_provider.dart';
import 'package:supplementary_app/screens/healthcheck/exercise_frequency_screen.dart';
import 'package:supplementary_app/viewmodels/health_check/medication_viewmodel.dart';
import 'package:supplementary_app/widgets/option_card.dart';
import 'package:supplementary_app/widgets/next_button.dart';

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
      child: const _MedicationScreenView(),
    );
  }
}

class _MedicationScreenView extends StatelessWidget {
  const _MedicationScreenView();

  @override
  Widget build(BuildContext context) {
    final viewModel = Provider.of<MedicationViewModel>(context);

    return Scaffold(
      appBar: AppBar(),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              '복용중인 약이 있다면\n알려주세요',
              style: Theme.of(context).textTheme.headlineMedium,
            ),
            const SizedBox(height: 10),
            Text(
              '영양제와 함께 복용시 주의해야 할\n약물이 있는지 확인해드릴게요',
              style: Theme.of(
                context,
              ).textTheme.bodyMedium?.copyWith(color: Colors.grey),
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
                        color: Theme.of(context).colorScheme.surface,
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(
                          color: Theme.of(context).colorScheme.outline,
                        ),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                '복용중인 약을 입력해주세요',
                                style: Theme.of(context).textTheme.titleMedium
                                    ?.copyWith(fontWeight: FontWeight.bold),
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
                                style: Theme.of(context).textTheme.bodyMedium,
                              ),
                            ),
                          const SizedBox(height: 8),
                          Text(
                            '여러 약을 복용 중이라면 쉼표(,)로 구분해주세요',
                            style: Theme.of(
                              context,
                            ).textTheme.bodySmall?.copyWith(color: Colors.grey),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              )
            else
              const Spacer(),
            NextButton(
              canProceed: viewModel.isNextButtonEnabled,
              nextPage: const ExerciseFrequencyScreen(),
              onTap: viewModel.addToSurvey,
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
                  side: const BorderSide(color: Colors.black, width: 1.0),
                ),
                child: const Text(
                  '취소',
                  style: TextStyle(
                    color: Colors.black,
                    fontSize: 16,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
              ElevatedButton(
                onPressed: () {
                  viewModel.setMedicationInput(controller.text);
                  Navigator.pop(context);
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Theme.of(context).colorScheme.primary,
                ),
                child: const Text(
                  '확인',
                  style: TextStyle(
                    color: Colors.black,
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ],
          ),
    );
  }
}
