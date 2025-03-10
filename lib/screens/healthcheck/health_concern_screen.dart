import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:supplementary_app/providers/supplement_survey_provider.dart';
import 'package:supplementary_app/screens/healthcheck/smoking_screen.dart';
import 'package:supplementary_app/viewmodels/health_check/health_concern_viewmodel.dart';

class HealthConcernScreen extends StatelessWidget {
  const HealthConcernScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create:
          (_) => HealthConcernViewModel(
            surveyProvider: Provider.of<SupplementSurveyProvider>(
              context,
              listen: false,
            ),
          ),
      child: const _HealthConcernScreen(),
    );
  }
}

class _HealthConcernScreen extends StatelessWidget {
  const _HealthConcernScreen();

  @override
  Widget build(BuildContext context) {
    final viewModel = Provider.of<HealthConcernViewModel>(context);

    return Scaffold(
      appBar: AppBar(),
      body: Column(
        children: [
          Expanded(
            child: SingleChildScrollView(
              child: Column(
                children: [
                  _buildTitle(context, viewModel),
                  _buildGridView(context, viewModel),
                ],
              ),
            ),
          ),
          _buildButton(context, viewModel),
        ],
      ),
    );
  }

  Widget _buildTitle(BuildContext context, HealthConcernViewModel viewModel) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 20, 20, 0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            '고민되시거나 개선하고 싶은\n건강고민을 선택해주세요',
            style: Theme.of(context).textTheme.headlineMedium,
          ),
          const SizedBox(height: 10),
          Text(
            '최대 ${viewModel.maxSelections}개 선택',
            style: Theme.of(
              context,
            ).textTheme.bodyMedium?.copyWith(color: Colors.grey),
          ),
        ],
      ),
    );
  }

  Widget _buildGridView(
    BuildContext context,
    HealthConcernViewModel viewModel,
  ) {
    return GridView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      padding: const EdgeInsets.all(16),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 3,
        childAspectRatio: 0.85,
        crossAxisSpacing: 12,
        mainAxisSpacing: 12,
      ),
      itemCount: viewModel.healthConcerns.length,
      itemBuilder: (context, index) {
        final concern = viewModel.healthConcerns[index];
        return _buildGridItem(context, concern, viewModel, index);
      },
    );
  }

  Widget _buildGridItem(
    BuildContext context,
    HealthConcern concern,
    HealthConcernViewModel viewModel,
    int index,
  ) {
    final theme = Theme.of(context);

    return GestureDetector(
      onTap: () => viewModel.toggleSelection(index),
      child: Container(
        decoration: BoxDecoration(
          color:
              concern.isSelected
                  ? theme.colorScheme.primaryContainer
                  : theme.colorScheme.surface,
          borderRadius: BorderRadius.circular(16),
          border:
              concern.isSelected
                  ? Border.all(color: theme.colorScheme.primary, width: 2)
                  : null,
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Image.asset(concern.iconPath, width: 60, height: 60),
            const SizedBox(height: 8),
            Text(
              concern.title,
              style: theme.textTheme.bodyMedium?.copyWith(
                fontWeight: FontWeight.bold,
              ),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildButton(BuildContext context, HealthConcernViewModel viewModel) {
    final theme = Theme.of(context);

    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: ElevatedButton(
        onPressed:
            viewModel.selectedCount > 0
                ? () {
                  viewModel.addToSurvey();
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const SmokingScreen(),
                    ),
                  );
                }
                : null,
        style: ElevatedButton.styleFrom(
          backgroundColor: theme.colorScheme.primary,
          minimumSize: const Size(double.infinity, 56),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              '확인',
              style: theme.textTheme.titleLarge?.copyWith(
                color: theme.colorScheme.onPrimary,
                fontWeight: FontWeight.bold,
              ),
            ),
            const Spacer(),
            Text('${viewModel.selectedCount}/${viewModel.maxSelections}'),
          ],
        ),
      ),
    );
  }
}
