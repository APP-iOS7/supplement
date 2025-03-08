import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:supplementary_app/providers/supplement_survey_provider.dart';
import 'package:supplementary_app/screens/healthcheck/medication_screen.dart';
import 'package:supplementary_app/viewmodels/health_check/allergy_viewmodel.dart';
import 'package:supplementary_app/widgets/option_card.dart';

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
    return Consumer<AllergyViewModel>(
      builder: (context, viewModel, child) {
        return Scaffold(
          appBar: AppBar(),
          body: Padding(
            padding: const EdgeInsets.all(20.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildHeader(),
                const SizedBox(height: 30),
                _buildOptions(context, viewModel),
                if (viewModel.selectedOption == '알러지가 있어요')
                  _buildAllergySelectionSection(context, viewModel),
                _buildNextButton(context, viewModel),
              ],
            ),
          ),
        );
      },
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

  Widget _buildOptions(BuildContext context, AllergyViewModel viewModel) {
    return Column(
      children: [
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
      ],
    );
  }

  Widget _buildAllergySelectionSection(
    BuildContext context,
    AllergyViewModel viewModel,
  ) {
    return Expanded(
      child: Column(
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
      ),
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
      backgroundColor: Colors.grey.shade100,
      selectedColor: Theme.of(context).colorScheme.primaryContainer,
      checkmarkColor: Theme.of(context).colorScheme.primary,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(20),
        side:
            isSelected
                ? BorderSide(color: Theme.of(context).colorScheme.primary)
                : BorderSide.none,
      ),
      label: Text(type),
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
              style: TextStyle(
                fontWeight: FontWeight.bold,
                color: Theme.of(context).colorScheme.primary,
              ),
            ),
            const SizedBox(width: 8),
            Expanded(
              child: Text(
                viewModel.specificAllergyInput,
                style: const TextStyle(color: Colors.black87),
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

  Widget _buildNextButton(BuildContext context, AllergyViewModel viewModel) {
    return SizedBox(
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
                      builder: (context) => const MedicationScreen(),
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
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text(
              '다음',
              style: TextStyle(
                color: Colors.white,
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            if (viewModel.selectedAllergies.isNotEmpty)
              Padding(
                padding: const EdgeInsets.only(left: 8.0),
                child: Text(
                  '${viewModel.selectedAllergies.length}개',
                  style: const TextStyle(color: Colors.white, fontSize: 16),
                ),
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
                child: const Text('취소'),
              ),
              ElevatedButton(
                onPressed: () {
                  viewModel.setSpecificAllergyInput(controller.text);
                  Navigator.pop(context);
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Theme.of(context).colorScheme.primary,
                ),
                child: const Text('확인', style: TextStyle(color: Colors.white)),
              ),
            ],
          ),
    );
  }
}
