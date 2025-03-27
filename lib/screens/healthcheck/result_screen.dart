import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:supplementary_app/models/recommend_item_model.dart';
import 'package:supplementary_app/viewmodels/health_check/result_viewmodel.dart';
import 'package:supplementary_app/screens/main_screen.dart';
import 'package:supplementary_app/widgets/loading.dart';

class ResultScreen extends StatelessWidget {
  const ResultScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) => ResultViewModel(context),
      child: Consumer<ResultViewModel>(
        builder: (context, viewModel, child) {
          return _ResultScreen(viewModel: viewModel);
        },
      ),
    );
  }
}

class _ResultScreen extends StatelessWidget {
  const _ResultScreen({required this.viewModel});
  final ResultViewModel viewModel;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: FutureBuilder<RecommendItemModel>(
        future: viewModel.getRecommendations(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Loading();
          }

          if (snapshot.hasError) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text('오류가 발생했습니다: ${snapshot.error}'),
                  ElevatedButton(
                    onPressed: () {
                      Navigator.pushReplacement(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const ResultScreen(),
                        ),
                      );
                    },
                    child: const Text('다시 시도'),
                  ),
                ],
              ),
            );
          }

          if (!snapshot.hasData) {
            return const Center(child: Text('추천 결과가 없습니다.'));
          }

          return Column(
            children: [
              SizedBox(height: 120),
              Expanded(
                child: ListView.builder(
                  padding: const EdgeInsets.all(16),
                  itemCount: 1,
                  itemBuilder: (context, index) {
                    return _RecommendationCard(recommendation: snapshot.data!);
                  },
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(16.0),
                child: ElevatedButton(
                  onPressed: () {
                    Navigator.pushAndRemoveUntil(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const MainScreen(),
                      ),
                      (route) => false,
                    );
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Theme.of(context).colorScheme.primary,
                    minimumSize: const Size(double.infinity, 56),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(16),
                    ),
                  ),
                  child: Text(
                    '홈으로 돌아가기',
                    style: Theme.of(context).textTheme.titleLarge?.copyWith(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}

class _RecommendationCard extends StatelessWidget {
  final RecommendItemModel recommendation;

  const _RecommendationCard({required this.recommendation});

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.only(bottom: 16),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            if (recommendation.imageLink != null)
              Center(
                child: Image.network(
                  recommendation.imageLink!,
                  height: 200,
                  fit: BoxFit.contain,
                ),
              ),
            const SizedBox(height: 16),
            Text(
              recommendation.name,
              style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            _buildInfoRow('제조사', recommendation.manufacturer),
            _buildInfoRow('주요 효과', recommendation.mainEffect),
            _buildInfoRow('섭취 방법', recommendation.dosageAndForm),
            _buildInfoRow('가격', recommendation.price),
            _buildInfoRow('주요 성분', recommendation.ingredients.join(', ')),
            _buildInfoRow('보관 방법', recommendation.storage),
            _buildInfoRow('주의사항', recommendation.caution),
          ],
        ),
      ),
    );
  }

  Widget _buildInfoRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 80,
            child: Text(
              label,
              style: const TextStyle(
                fontWeight: FontWeight.bold,
                color: Colors.grey,
              ),
            ),
          ),
          Expanded(child: Text(value)),
        ],
      ),
    );
  }
}
