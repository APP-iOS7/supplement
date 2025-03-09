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
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;
    
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: SafeArea(
          child: Column(
            children: [
              _buildSearchBar(context),
              const SizedBox(height: 20),
              _buildSearchResults(),
            ],
          ),
        ),
      ),
      backgroundColor: isDarkMode ? Colors.black : Colors.grey[100],
    );
  }

  Widget _buildSearchBar(BuildContext context) {
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;
    
    return Row(
      children: [
        Expanded(child: _buildSearchTextField(context)),
        const SizedBox(width: 10),
        _buildSearchButton(context),
      ],
    );
  }

  Widget _buildSearchTextField(BuildContext context) {
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;
    
    return Container(
      decoration: BoxDecoration(
        color: isDarkMode ? Colors.grey[800] : Colors.white,
        borderRadius: BorderRadius.circular(30),
        boxShadow: [
          BoxShadow(
            color: isDarkMode ? Colors.black54 : Colors.grey,
            spreadRadius: 2,
            blurRadius: 5,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: TextField(
        controller: viewModel.controller,
        decoration: InputDecoration(
          hintText: 'Search...',
          hintStyle: TextStyle(
            color: isDarkMode ? Colors.grey[400] : Colors.grey[600],
          ),
          border: InputBorder.none,
          prefixIcon: Icon(
            Icons.search,
            color: Theme.of(context).colorScheme.primary,
          ),
          contentPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 15),
        ),
        style: TextStyle(
          color: isDarkMode ? Colors.white : Colors.black, // 다크모드에서는 흰색, 라이트모드에서는 검정색
        ),
      ),
    );
  }

  Widget _buildSearchResults() {
    return Builder(
      builder: (context) {
        final isDarkMode = Theme.of(context).brightness == Brightness.dark;
        
        if (viewModel.searchFuture == null) {
          return Expanded(
            child: Center(
              child: Text(
                '검색어를 입력하세요',
                style: TextStyle(
                  fontSize: 18, 
                  color: isDarkMode ? Colors.grey[400] : Colors.grey[600],
                ),
              ),
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
                    style: TextStyle(
                      fontSize: 18, 
                      color: Colors.red,
                    ),
                  ),
                );
              }

              if (!snapshot.hasData || snapshot.data!.isEmpty) {
                return Center(
                  child: Text(
                    '검색 결과가 없습니다',
                    style: TextStyle(
                      fontSize: 18, 
                      color: isDarkMode ? Colors.grey[400] : Colors.grey[600],
                    ),
                  ),
                );
              }

              return ListView.builder(
                itemCount: snapshot.data!.length,
                itemBuilder: (context, index) =>
                    _buildResultCard(snapshot.data![index], context),
              );
            },
          ),
        );
      },
    );
  }

  Widget _buildResultCard(SearchItem item, BuildContext context) {
      final isDarkMode = Theme.of(context).brightness == Brightness.dark;
      
      return Card(
        elevation: 3,
        margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 5),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
        color: isDarkMode ? Colors.grey[850] : Colors.white,
        child: ListTile(
          leading: Image.network(item.image),
          title: Text(
            item.title,
            style: TextStyle(
              fontSize: 18, 
              fontWeight: FontWeight.w500,
              color: isDarkMode ? Colors.white : Colors.black,
            ),
          ),
          subtitle: Row(
            children: [
              Text(
                '${item.lprice}원', 
                style: TextStyle(color: isDarkMode ? Colors.grey[400] : Colors.grey[700]),
              ), 
              const Spacer(), 
              Text(
                item.brand,
                style: TextStyle(color: isDarkMode ? Colors.grey[400] : Colors.grey[700]),
              ),
            ],
          ),
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => ItemDetailScreen(
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
        style: ElevatedButton.styleFrom(
          backgroundColor: Theme.of(context).colorScheme.primary,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 15),
        ),
        child: const Icon(Icons.search, color: Colors.white),
      );
    }
}

