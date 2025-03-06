import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:supplementary_app/screens/healthcheck/smoking_screen.dart';
import 'package:supplementary_app/viewmodels/health_concern_viewmodel.dart';

class HealthConcernScreen extends StatelessWidget {
  const HealthConcernScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => HealthConcernViewModel(),
      child: _HealthConcernScreen(),
    );
  }
}

class _HealthConcernScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final viewModel = context.watch<HealthConcernViewModel>();

    return Scaffold(
      appBar: AppBar(),
      body: Column(
        children: [
          Padding(
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
          ),
          Expanded(
            child: GridView.builder(
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
                return GestureDetector(
                  onTap: () => viewModel.toggleSelection(index),
                  child: Container(
                    decoration: BoxDecoration(
                      color: concern['color'],
                      borderRadius: BorderRadius.circular(16),
                      border:
                          concern['isSelected']
                              ? Border.all(color: Colors.blue, width: 2)
                              : null,
                    ),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        if (concern['tag'].isNotEmpty)
                          Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 8,
                              vertical: 2,
                            ),
                            decoration: BoxDecoration(
                              color: Colors.purple.shade300,
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: Text(
                              concern['tag'],
                              style: const TextStyle(
                                color: Colors.white,
                                fontSize: 12,
                              ),
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
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: ElevatedButton(
              onPressed:
                  viewModel.selectedCount > 0
                      ? () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => const SmokingScreen(),
                          ),
                        );
                      }
                      : null,
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.purple,
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
                      color: Colors.white,
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const Spacer(),
                  Text(
                    '${viewModel.selectedCount}/${viewModel.maxSelections}',
                    style: const TextStyle(color: Colors.white, fontSize: 16),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
