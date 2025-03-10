import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:supplementary_app/providers/supplement_survey_provider.dart';
import 'package:supplementary_app/screens/healthcheck/medication_screen.dart';
import 'package:supplementary_app/viewmodels/health_check/allergy_viewmodel.dart';
import 'package:supplementary_app/widgets/option_cards.dart';
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
      child: const _AllergyScreen(),
    );
  }
}

class _AllergyScreen extends StatelessWidget {
  const _AllergyScreen();

  @override
  Widget build(BuildContext context) {
    final viewModel = Provider.of<AllergyViewModel>(context);
    final theme = Theme.of(context);

    return Scaffold(
      appBar: AppBar(),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              '갖고있는 알러지가 있다면\n선택해주세요',
              style: theme.textTheme.headlineMedium,
            ),
            const SizedBox(height: 10),
            Text(
              '각 상태에서 피해야 하는 영양성분을 분석해드릴게요',
              style: theme.textTheme.bodyMedium?.copyWith(color: Colors.grey),
            ),
            const SizedBox(height: 30),
            SurveyOptionCard(
              title: '알러지가 없어요',
              value: false,
              selectedValue: viewModel.hasAllergy,
              onTap: viewModel.setHasNoAllergy,
            ),
            const SizedBox(height: 16),
            SurveyOptionCard(
              title: '알러지가 있어요',
              value: true,
              selectedValue: viewModel.hasAllergy,
              onTap: viewModel.setHasAllergy,
            ),
            if (viewModel.hasAllergy == true)
              Expanded(child: _buildAllergySelectionSection(context, viewModel))
            else
              const Spacer(),
            NextButton(
              canProceed: viewModel.canProceed,
              nextPage: const MedicationScreen(),
              onTap: viewModel.addToSurvey,
            ),
          ],
        ),
      ),
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
                if (viewModel.selectedAllergies.contains('특정 알러지'))
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
    final theme = Theme.of(context);
    return FilterChip(
      selected: isSelected,
      backgroundColor: theme.colorScheme.surface,
      selectedColor: theme.colorScheme.primaryContainer,
      checkmarkColor: theme.colorScheme.primary,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(20),
        side:
            isSelected
                ? BorderSide(color: theme.colorScheme.primary)
                : BorderSide.none,
      ),
      label: Text(
        type,
        style: theme.textTheme.bodyMedium?.copyWith(
          color:
              isSelected
                  ? theme.colorScheme.primary
                  : theme.colorScheme.onSurface,
          fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
        ),
      ),
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
    final theme = Theme.of(context);
    return Padding(
      padding: const EdgeInsets.only(top: 16.0),
      child: Container(
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: theme.colorScheme.primaryContainer.withOpacity(0.3),
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: theme.colorScheme.primary.withOpacity(0.5)),
        ),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              '특정 알러지:',
              style: theme.textTheme.bodyMedium?.copyWith(
                fontWeight: FontWeight.bold,
                color: theme.colorScheme.primary,
              ),
            ),
            const SizedBox(width: 8),
            Expanded(
              child: Text(
                viewModel.specificAllergyInput,
                style: theme.textTheme.bodyMedium,
              ),
            ),
            IconButton(
              icon: const Icon(Icons.edit, size: 18),
              color: theme.colorScheme.primary,
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
    final theme = Theme.of(context);
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
                  side: BorderSide(
                    color: theme.colorScheme.onSurface,
                    width: 1.0,
                  ),
                ),
                child: Text(
                  '취소',
                  style: theme.textTheme.labelLarge?.copyWith(
                    color: theme.colorScheme.onSurface,
                  ),
                ),
              ),
              ElevatedButton(
                onPressed: () {
                  viewModel.setSpecificAllergyInput(controller.text);
                  Navigator.pop(context);
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: theme.colorScheme.primary,
                ),
                child: Text(
                  '확인',
                  style: theme.textTheme.labelLarge?.copyWith(
                    color: theme.colorScheme.onPrimary,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ],
          ),
    );
  }
}
