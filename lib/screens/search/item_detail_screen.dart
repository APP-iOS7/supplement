import 'package:flutter/material.dart';
import 'package:supplementary_app/models/item_detail_model.dart';
import 'package:supplementary_app/viewmodels/search/item_detail_view_model.dart';
import 'package:supplementary_app/widgets/loading.dart';

class ItemDetailScreen extends StatelessWidget {
  final String itemTitle;
  final String imageUrl;
  final String price;

  const ItemDetailScreen({
    super.key,
    required this.itemTitle,
    required this.imageUrl,
    required this.price,
  });

  @override
  Widget build(BuildContext context) {
    final viewModel = ItemDetailViewModel(
      context: context,
      itemTitle: itemTitle,
      imageUrl: imageUrl,
      price: price,
    );

    return Scaffold(
      appBar: AppBar(title: const Text('상세 정보')),
      body: FutureBuilder<ItemDetail>(
        future: viewModel.getItemDetail(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Loading();
          }

          if (snapshot.hasError) {
            return Center(
              child: Text(
                '오류가 발생했습니다: ${snapshot.error}',
                style: const TextStyle(fontSize: 18, color: Colors.red),
              ),
            );
          }

          if (!snapshot.hasData) {
            return const Center(
              child: Text(
                '정보를 불러올 수 없습니다',
                style: TextStyle(fontSize: 18, color: Colors.grey),
              ),
            );
          }

          final itemDetail = snapshot.data!;
          return _buildDetailContent(itemDetail, imageUrl);
        },
      ),
    );
  }
}

Widget _buildDetailContent(ItemDetail itemDetail, String imageUrl) {
  return SingleChildScrollView(
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        _buildImageSection(imageUrl),
        Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildTitleSection(itemDetail.name),
              const SizedBox(height: 16),
              _buildPriceAndRatingRow(itemDetail),
              const SizedBox(height: 24),
              _buildInfoCard('제품 정보', [
                _buildInfoRow('제조사', itemDetail.manufacturer),
                _buildInfoRow('설명', itemDetail.description),
              ]),
              const SizedBox(height: 16),
              _buildInfoCard('성분 및 기능', [
                _buildInfoRow('성분', itemDetail.ingredients.join(', ')),
                _buildInfoRow('기능성', itemDetail.functionality),
              ]),
              const SizedBox(height: 16),
              _buildInfoCard('복용 정보', [
                _buildInfoRow('복용법', itemDetail.dosage),
                _buildInfoRow('부작용', itemDetail.sideEffects),
                _buildInfoRow('주의사항', itemDetail.caution),
              ]),
            ],
          ),
        ),
      ],
    ),
  );
}

Widget _buildImageSection(String imageUrl) {
  return Container(
    height: 300,
    decoration: BoxDecoration(
      color: Colors.white,
      boxShadow: [
        BoxShadow(
          color: Colors.black.withOpacity(0.1),
          blurRadius: 8,
          offset: const Offset(0, 2),
        ),
      ],
    ),
    child: Stack(
      children: [
        Center(
          child: Image.network(imageUrl, fit: BoxFit.contain, height: 250),
        ),
        Positioned(
          bottom: 0,
          left: 0,
          right: 0,
          child: Container(
            height: 50,
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.bottomCenter,
                end: Alignment.topCenter,
                colors: [
                  Colors.white.withOpacity(0.8),
                  Colors.white.withOpacity(0.0),
                ],
              ),
            ),
          ),
        ),
      ],
    ),
  );
}

Widget _buildTitleSection(String name) {
  return Text(
    name,
    style: const TextStyle(
      fontSize: 24,
      fontWeight: FontWeight.bold,
      color: Colors.black87,
    ),
  );
}

Widget _buildPriceAndRatingRow(ItemDetail itemDetail) {
  return Row(
    mainAxisAlignment: MainAxisAlignment.spaceBetween,
    children: [
      Container(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
        decoration: BoxDecoration(
          color: Colors.blue.shade50,
          borderRadius: BorderRadius.circular(8),
        ),
        child: Text(
          itemDetail.price,
          style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
            color: Colors.blue.shade700,
          ),
        ),
      ),
      Container(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
        decoration: BoxDecoration(
          color: Colors.orange.shade50,
          borderRadius: BorderRadius.circular(8),
        ),
        child: Row(
          children: [
            const Icon(Icons.star, color: Colors.orange, size: 20),
            const SizedBox(width: 4),
            Text(
              itemDetail.rating.toString(),
              style: const TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: Colors.orange,
              ),
            ),
          ],
        ),
      ),
    ],
  );
}

Widget _buildInfoCard(String title, List<Widget> content) {
  return Card(
    elevation: 2,
    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
    child: Padding(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: const TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: Colors.black87,
            ),
          ),
          const SizedBox(height: 12),
          ...content,
        ],
      ),
    ),
  );
}

Widget _buildInfoRow(String label, String content) {
  return Padding(
    padding: const EdgeInsets.only(bottom: 12),
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w500,
            color: Colors.grey.shade600,
          ),
        ),
        const SizedBox(height: 4),
        Text(
          content,
          style: const TextStyle(fontSize: 16, color: Colors.black87),
        ),
      ],
    ),
  );
}
