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
    final viewModel = Provider.of<HealthConcernViewModel>(
      context,
      listen: true,
    );

    return Scaffold(
      appBar: AppBar(),
      body: Column(
        children: [
          Expanded(
            child: SingleChildScrollView(
              child: Column(
                children: [_buildHeader(viewModel), _buildGridView(viewModel)],
              ),
            ),
          ),
          _buildFooter(context, viewModel),
        ],
      ),
    );
  }

  Widget _buildHeader(HealthConcernViewModel viewModel) {
    return Padding(
      padding: const EdgeInsets.all(20.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            '고민되시거나 개선하고 싶은\n건강고민을 선택해주세요',
            style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 10),
          Text(
            '최대 ${viewModel.maxSelections}개 선택',
            style: TextStyle(color: Colors.grey, fontSize: 16),
          ),
        ],
      ),
    );
  }

  Widget _buildGridView(HealthConcernViewModel viewModel) {
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
    Map<String, dynamic> concern,
    HealthConcernViewModel viewModel,
    int index,
  ) {
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;

    return GestureDetector(
      onTap: () => viewModel.toggleSelection(index),
      child: Container(
        decoration: BoxDecoration(
          color:
              concern['isSelected']
                  ? Theme.of(context).colorScheme.primaryContainer
                  : (isDarkMode
                      ? Colors.white
                      : Color.fromARGB(255, 173, 238, 171)),
          borderRadius: BorderRadius.circular(16),
          border:
              concern['isSelected']
                  ? Border.all(
                    color: Theme.of(context).colorScheme.primary,
                    width: 2,
                  )
                  : null,
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            if (concern['tag'].isNotEmpty)
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                decoration: BoxDecoration(
                  color: Colors.purple.shade300,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Text(
                  concern['tag'],
                  style: const TextStyle(color: Colors.white, fontSize: 12),
                ),
              ),
            const SizedBox(height: 8),
            Image.asset(
              concern['icon'],
              width: 60,
              height: 60,
              errorBuilder: (context, error, stackTrace) {
                return Icon(
                  Icons.healing,
                  size: 60,
                  color: Colors.blue.shade700,
                );
              },
            ),
            const SizedBox(height: 8),
            Text(
              concern['title'],
              style: const TextStyle(
                fontSize: 13,
                fontWeight: FontWeight.bold,
                color: Colors.black, // 항상 검정색으로 설정
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildFooter(BuildContext context, HealthConcernViewModel viewModel) {
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
          backgroundColor: Theme.of(context).colorScheme.primary,
          minimumSize: const Size(double.infinity, 56),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text(
              '확인',
              style: TextStyle(
                color: Colors.black,
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            const Spacer(),
            Text(
              '${viewModel.selectedCount}/${viewModel.maxSelections}',
              style: const TextStyle(
                color: Colors.black,
                fontSize: 16,
                fontWeight: FontWeight.w500,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// 파일 하단의 buildHealthConcernItem 함수도 수정
Widget buildHealthConcernItem(BuildContext context, int index) {
  final isDarkMode = Theme.of(context).brightness == Brightness.dark;
  final viewModel = Provider.of<HealthConcernViewModel>(context);
  final concern = viewModel.healthConcerns[index];

  return GestureDetector(
    onTap: () => viewModel.toggleSelection(index),
    child: Container(
      decoration: BoxDecoration(
        color:
            concern['isSelected']
                ? Theme.of(context).colorScheme.primary
                : (isDarkMode ? Colors.white : concern['color']),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Image.asset(concern['icon'], width: 40, height: 40),
          const SizedBox(height: 8),
          Text(
            concern['title'],
            style: const TextStyle(
              fontSize: 14,
              color: Colors.black,
              fontWeight: FontWeight.bold,
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    ),
  );
}
