import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:supplementary_app/models/item_detail_model.dart';
import 'package:supplementary_app/viewmodels/search/item_detail_view_model.dart';

class ItemDetailScreen extends StatelessWidget {
  final String itemTitle;

  const ItemDetailScreen({super.key, required this.itemTitle});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) {
        final viewModel = ItemDetailViewModel();
        viewModel.fetchItemDetail(itemTitle);
        return viewModel;
      },
      child: Consumer<ItemDetailViewModel>(
        builder: (context, viewModel, child) {
          if (viewModel.isLoading) {
            return const Scaffold(
              body: Center(child: CircularProgressIndicator()),
            );
          }

          if (viewModel.error != null) {
            return Scaffold(
              appBar: AppBar(title: const Text('상세 정보')),
              body: Center(
                child: Text(
                  '오류가 발생했습니다: ${viewModel.error}',
                  style: const TextStyle(fontSize: 18, color: Colors.red),
                ),
              ),
            );
          }

          if (viewModel.itemDetail == null) {
            return Scaffold(
              appBar: AppBar(title: Text('상세 정보')),
              body: Center(
                child: Text(
                  '정보를 불러올 수 없습니다',
                  style: TextStyle(fontSize: 18, color: Colors.grey),
                ),
              ),
            );
          }

          return Scaffold(
            appBar: AppBar(title: Text(viewModel.itemDetail!.name)),
            body: _buildDetailContent(viewModel.itemDetail!),
          );
        },
      ),
    );
  }

  Widget _buildDetailContent(ItemDetail itemDetail) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            itemDetail.name,
            style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 20),
          _buildPriceSection(itemDetail.price),
          _buildSection('제조사', itemDetail.manufacturer),
          _buildSection('설명', itemDetail.description),
          _buildSection('성분', itemDetail.ingredients.join(', ')),
          _buildSection('기능성', itemDetail.functionality),
          _buildSection('복용법', itemDetail.dosage),
          _buildSection('부작용', itemDetail.sideEffects),
          _buildSection('주의사항', itemDetail.caution),
          _buildRatingSection(itemDetail.rating),
          _buildReviewsSection(itemDetail.reviews),
        ],
      ),
    );
  }

  Widget _buildPriceSection(String price) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16.0),
      child: Text(
        '가격: $price원',
        style: const TextStyle(
          fontSize: 20,
          color: Colors.blue,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }

  Widget _buildRatingSection(double rating) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 16.0),
      child: Row(
        children: [
          const Text('평점: ', style: TextStyle(fontSize: 18)),
          Text(
            rating.toString(),
            style: const TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: Colors.orange,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildReviewsSection(List<String> reviews) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          '리뷰',
          style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 8),
        ...reviews.map(
          (review) => Card(
            margin: const EdgeInsets.symmetric(vertical: 4),
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Text(review),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildSection(String title, String content) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 4),
          Text(content, style: const TextStyle(fontSize: 16)),
        ],
      ),
    );
  }
}
