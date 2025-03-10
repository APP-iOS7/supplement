import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:supplementary_app/providers/supplement_survey_provider.dart';
import 'package:supplementary_app/screens/healthcheck/medication_screen.dart';
import 'package:supplementary_app/viewmodels/health_check/allergy_viewmodel.dart';
import 'package:supplementary_app/widgets/option_card.dart';
import 'package:supplementary_app/widgets/next_button.dart';

class AllergyScreen extends StatelessWidget {
  const AllergyScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create:
          (_) => AllergyViewModel(
            surveyProvider: Provider.of<SupplementSurveyProvider>(
              context,
              listen: false,
            ),
          ),
      child: Consumer<AllergyViewModel>(
        builder: (context, viewModel, child) {
          return _AllergyScreen(viewModel: viewModel);
        },
      ),
    );
  }
}

class _AllergyScreen extends StatelessWidget {
  const _AllergyScreen({required this.viewModel});
  final AllergyViewModel viewModel;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildHeader(),
            const SizedBox(height: 30),
            OptionCard(
              title: '알러지가 없어요',
              value: '알러지가 없어요',
              selectedValue: viewModel.selectedOption ?? '',
              onTap: viewModel.selectOption,
            ),
            const SizedBox(height: 16),
            OptionCard(
              title: '알러지가 있어요',
              value: '알러지가 있어요',
              selectedValue: viewModel.selectedOption ?? '',
              onTap: viewModel.selectOption,
            ),
            if (viewModel.selectedOption == '알러지가 있어요')
              Expanded(child: _buildAllergySelectionSection(context, viewModel))
            else
              const Spacer(),
            NextButton(
              canProceed: viewModel.isNextButtonEnabled,
              nextPage: const MedicationScreen(),
              onTap: viewModel.addToSurvey,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildHeader() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: const [
        Text(
          '갖고있는 알러지가 있다면 \n선택해주세요',
          style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
        ),
        SizedBox(height: 10),
        Text(
          '각 상태에서 피해야 하는 영양성분을 분석해드릴게요',
          style: TextStyle(color: Colors.grey, fontSize: 16),
        ),
      ],
    );
  }

  Widget _buildAllergySelectionSection(
    BuildContext context,
    AllergyViewModel viewModel,
  ) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const SizedBox(height: 20),
        Expanded(
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildAllergyTypeChips(context, viewModel),
                if (viewModel.selectedAllergies.contains('특정 알러지') &&
                    viewModel.selectedAllergies.isNotEmpty)
                  _buildSpecificAllergyInput(context, viewModel),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildAllergyTypeChips(
    BuildContext context,
    AllergyViewModel viewModel,
  ) {
    return Wrap(
      spacing: 8,
      runSpacing: 8,
      children:
          viewModel.allergyTypes.map((type) {
            final isSelected = viewModel.selectedAllergies.contains(type);
            return _buildFilterChip(context, viewModel, type, isSelected);
          }).toList(),
    );
  }

  Widget _buildFilterChip(
    BuildContext context,
    AllergyViewModel viewModel,
    String type,
    bool isSelected,
  ) {
    return FilterChip(
      selected: isSelected,
      backgroundColor: Theme.of(context).colorScheme.surface,
      selectedColor: Theme.of(context).colorScheme.primaryContainer,
      checkmarkColor: Theme.of(context).colorScheme.error,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(20),
        side:
            isSelected
                ? BorderSide(color: Theme.of(context).colorScheme.primary)
                : BorderSide.none,
      ),
      label: Text(type, style: Theme.of(context).textTheme.bodyMedium),
      onSelected: (selected) {
        viewModel.toggleAllergySelection(type, selected);
        if (selected && type == '특정 알러지') {
          _showSpecificAllergyDialog(context, viewModel);
        }
      },
    );
  }

  Widget _buildSpecificAllergyInput(
    BuildContext context,
    AllergyViewModel viewModel,
  ) {
    return Padding(
      padding: const EdgeInsets.only(top: 16.0),
      child: Container(
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: Theme.of(
            context,
          ).colorScheme.primaryContainer.withOpacity(0.3),
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: Theme.of(context).colorScheme.primary.withOpacity(0.5),
          ),
        ),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              '특정 알러지:',
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                fontWeight: FontWeight.bold,
                color: Theme.of(context).colorScheme.primary,
              ),
            ),
            const SizedBox(width: 8),
            Expanded(
              child: Text(
                viewModel.specificAllergyInput,
                style: Theme.of(context).textTheme.bodyMedium,
              ),
            ),
            IconButton(
              icon: const Icon(Icons.edit, size: 18),
              color: Theme.of(context).colorScheme.primary,
              onPressed: () => _showSpecificAllergyDialog(context, viewModel),
            ),
          ],
        ),
      ),
    );
  }

  void _showSpecificAllergyDialog(
    BuildContext context,
    AllergyViewModel viewModel,
  ) {
    final controller = TextEditingController(
      text: viewModel.specificAllergyInput,
    );

    showDialog(
      context: context,
      builder:
          (context) => AlertDialog(
            title: const Text('특정 알러지 입력'),
            content: TextField(
              controller: controller,
              decoration: const InputDecoration(
                hintText: '예: 꽃가루, 동물 등',
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
                  viewModel.setSpecificAllergyInput(controller.text);
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
