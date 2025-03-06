import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:supplementary_app/viewmodels/search/search_view_model.dart';

class SearchScreen extends StatelessWidget {
  const SearchScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => SearchViewModel(),
      child: Consumer<SearchViewModel>(
        builder: (context, viewModel, child) {
          return Scaffold(
            appBar: _buildAppBar(),
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

  PreferredSizeWidget _buildAppBar() {
    return AppBar(
      title: const Text(
        'Search',
        style: TextStyle(fontWeight: FontWeight.bold, fontSize: 22),
      ),
      centerTitle: true,
      backgroundColor: Colors.deepPurpleAccent,
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
      onPressed: viewModel.search,
      style: ElevatedButton.styleFrom(
        backgroundColor: Colors.deepPurpleAccent,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 15),
      ),
      child: const Icon(Icons.search, color: Colors.white),
    );
  }

  Widget _buildSearchResults(SearchViewModel viewModel) {
    if (viewModel.isLoading) {
      return const CircularProgressIndicator();
    }

    return Expanded(
      child:
          viewModel.searchResults.isEmpty
              ? _buildEmptyResults()
              : _buildResultsList(viewModel),
    );
  }

  Widget _buildEmptyResults() {
    return const Center(
      child: Text(
        'No results found',
        style: TextStyle(fontSize: 18, color: Colors.grey),
      ),
    );
  }

  Widget _buildResultsList(SearchViewModel viewModel) {
    return ListView.builder(
      itemCount: viewModel.searchResults.length,
      itemBuilder:
          (context, index) => _buildResultCard(viewModel.searchResults[index]),
    );
  }

  Widget _buildResultCard(dynamic item) {
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
        subtitle: Text(item.mallName),
      ),
    );
  }
}
