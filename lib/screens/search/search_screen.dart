import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:supplementary_app/models/naver_search_Item_model.dart';
import 'package:supplementary_app/viewmodels/search/search_view_model.dart';
import 'package:supplementary_app/screens/search/item_detail_screen.dart';
import 'package:supplementary_app/widgets/loading.dart';

class SearchScreen extends StatelessWidget {
  const SearchScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => SearchViewModel(),
      child: Consumer<SearchViewModel>(
        builder: (context, viewModel, child) {
          return Scaffold(
            appBar: AppBar(title: Text('Search')),
            body: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                children: [
                  _buildSearchBar(viewModel),
                  const SizedBox(height: 20),
                  _buildSearchResults(viewModel),
                ],
              ),
            ),
            backgroundColor: Colors.grey[100],
          );
        },
      ),
    );
  }

  Widget _buildSearchBar(SearchViewModel viewModel) {
    return Row(
      children: [
        Expanded(child: _buildSearchTextField(viewModel)),
        const SizedBox(width: 10),
        _buildSearchButton(viewModel),
      ],
    );
  }

  Widget _buildSearchTextField(SearchViewModel viewModel) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(30),
        boxShadow: const [
          BoxShadow(
            color: Colors.grey,
            spreadRadius: 2,
            blurRadius: 5,
            offset: Offset(0, 2),
          ),
        ],
      ),
      child: TextField(
        controller: viewModel.controller,
        decoration: const InputDecoration(
          hintText: 'Search...',
          border: InputBorder.none,
          prefixIcon: Icon(Icons.search, color: Colors.deepPurpleAccent),
          contentPadding: EdgeInsets.symmetric(horizontal: 20, vertical: 15),
        ),
      ),
    );
  }

  Widget _buildSearchButton(SearchViewModel viewModel) {
    return ElevatedButton(
      onPressed: viewModel.executeSearch,
      style: ElevatedButton.styleFrom(
        backgroundColor: Colors.deepPurpleAccent,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 15),
      ),
      child: const Icon(Icons.search, color: Colors.white),
    );
  }

  Widget _buildSearchResults(SearchViewModel viewModel) {
    if (viewModel.searchFuture == null) {
      return const Center(
        child: Text(
          '검색어를 입력하세요',
          style: TextStyle(fontSize: 18, color: Colors.grey),
        ),
      );
    }

    return Expanded(
      child: FutureBuilder<List<SearchItem>>(
        future: viewModel.searchFuture,
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

          if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return const Center(
              child: Text(
                '검색 결과가 없습니다',
                style: TextStyle(fontSize: 18, color: Colors.grey),
              ),
            );
          }

          return ListView.builder(
            itemCount: snapshot.data!.length,
            itemBuilder:
                (context, index) =>
                    _buildResultCard(snapshot.data![index], context, viewModel),
          );
        },
      ),
    );
  }

  Widget _buildResultCard(
    SearchItem item,
    BuildContext context,
    SearchViewModel viewModel,
  ) {
    return Card(
      elevation: 3,
      margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 5),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
      child: ListTile(
        leading: Image.network(item.image),
        title: Text(
          item.title,
          style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w500),
        ),
        subtitle: Row(
          children: [Text('${item.lprice}원'), Spacer(), Text(item.brand)],
        ),
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder:
                  (context) => ItemDetailScreen(
                    itemTitle: item.title,
                    imageUrl: item.image,
                    price: item.lprice,
                  ),
            ),
          );
        },
      ),
    );
  }
}
