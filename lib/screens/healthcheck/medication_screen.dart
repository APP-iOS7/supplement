import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:supplementary_app/providers/supplement_survey_provider.dart';
import 'package:supplementary_app/screens/healthcheck/exercise_frequency_screen.dart';
import 'package:supplementary_app/viewmodels/health_check/medication_viewmodel.dart';

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
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Navigator.of(context).pop(),
        ),
        title: const Text('', style: TextStyle(color: Colors.grey)),
        centerTitle: true,
        backgroundColor: Colors.transparent,
        elevation: 0,
      ),
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
            _buildOptionCard('복용중인 약 없음', '복용중인 약 없음', viewModel),
            const SizedBox(height: 16),
            _buildOptionCard('복용중인 약 있음', '복용중인 약 있음', viewModel),

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
                              const Text(
                                '복용중인 약을 입력해주세요',
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 16,
                                ),
                              ),
                              IconButton(
                                icon: const Icon(Icons.edit, size: 20),
                                color: Colors.deepPurple,
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
                child: const Text('취소'),
              ),
              ElevatedButton(
                onPressed: () {
                  viewModel.setMedicationInput(controller.text);
                  Navigator.pop(context);
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.deepPurple,
                ),
                child: const Text('확인', style: TextStyle(color: Colors.white)),
              ),
            ],
          ),
    );
  }

  Widget _buildOptionCard(
    String title,
    String value,
    MedicationViewModel viewModel,
  ) {
    final isSelected = viewModel.selectedOption == value;
    return GestureDetector(
      onTap: () => viewModel.selectOption(value),
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
}
