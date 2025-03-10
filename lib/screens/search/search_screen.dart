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
          return _SearchScreen(viewModel: viewModel);
        },
      ),
    );
  }
}

class _SearchScreen extends StatelessWidget {
  const _SearchScreen({required this.viewModel});
  final SearchViewModel viewModel;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: SafeArea(
          child: Column(
            children: [
              _buildSearchBar(context),
              const SizedBox(height: 20),
              _buildSearchResults(context),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildSearchBar(BuildContext context) {
    return Row(
      children: [
        Expanded(child: _buildSearchTextField(context)),
        const SizedBox(width: 10),
        _buildSearchButton(context),
      ],
    );
  }

  Widget _buildSearchTextField(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(30),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            spreadRadius: 2,
            blurRadius: 5,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: TextField(
        controller: viewModel.controller,
        decoration: const InputDecoration(
          hintText: 'Search...',
          border: InputBorder.none,
          prefixIcon: Icon(Icons.search),
          contentPadding: EdgeInsets.symmetric(horizontal: 20, vertical: 15),
        ),
      ),
    );
  }

  Widget _buildSearchResults(BuildContext context) {
    if (viewModel.searchFuture == null) {
      return const Expanded(child: Center(child: Text('검색어를 입력하세요')));
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
                style: TextStyle(
                  fontSize: 18,
                  color: Theme.of(context).colorScheme.error,
                ),
              ),
            );
          }

          if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return const Center(child: Text('검색 결과가 없습니다'));
          }

          return ListView.builder(
            itemCount: snapshot.data!.length,
            itemBuilder:
                (context, index) =>
                    _buildResultCard(snapshot.data![index], context),
          );
        },
      ),
    );
  }

  Widget _buildResultCard(SearchItem item, BuildContext context) {
    return Card(
      margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 5),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
      child: ListTile(
        leading: Image.network(item.image),
        title: Text(item.title),
        subtitle: Row(
          children: [Text('${item.lprice}원'), const Spacer(), Text(item.brand)],
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

  Widget _buildSearchButton(BuildContext context) {
    return ElevatedButton(
      onPressed: viewModel.executeSearch,
      child: Icon(Icons.search, color: Colors.white),
    );
  }
}
