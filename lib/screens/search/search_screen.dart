import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:supplementary_app/viewmodels/search_view_model.dart';

class SearchScreen extends StatelessWidget {
  const SearchScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => SearchViewModel(),
      child: Consumer<SearchViewModel>(
        builder: (context, viewModel, child) {
          return Scaffold(
            appBar: AppBar(
              title: const Text(
                'Search',
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 22),
              ),
              centerTitle: true,
              backgroundColor: Colors.deepPurpleAccent,
            ),
            body: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                children: [
                  Row(
                    children: [
                      Expanded(
                        child: Container(
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(30),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.grey,
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
                              border: InputBorder.none,
                              prefixIcon: const Icon(
                                Icons.search,
                                color: Colors.deepPurpleAccent,
                              ),
                              contentPadding: const EdgeInsets.symmetric(
                                horizontal: 20,
                                vertical: 15,
                              ),
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(width: 10),
                      ElevatedButton(
                        onPressed: viewModel.search,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.deepPurpleAccent,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(30),
                          ),
                          padding: const EdgeInsets.symmetric(
                            horizontal: 20,
                            vertical: 15,
                          ),
                        ),
                        child: const Icon(Icons.search, color: Colors.white),
                      ),
                    ],
                  ),
                  const SizedBox(height: 10),
                  SizedBox(
                    height: 50,
                    child: ListView.builder(
                      scrollDirection: Axis.horizontal,
                      itemCount: viewModel.searchHistory.length,
                      itemBuilder: (context, index) {
                        return Chip(
                          label: Text(viewModel.searchHistory[index]),
                          onDeleted: () {
                            viewModel.removeHistoryItem(index);
                          },
                          deleteIcon: const Icon(Icons.close),
                        );
                      },
                    ),
                  ),
                  const SizedBox(height: 20),
                  viewModel.isLoading
                      ? const CircularProgressIndicator()
                      : Expanded(
                        child:
                            viewModel.searchResults.isEmpty
                                ? const Center(
                                  child: Text(
                                    'No results found',
                                    style: TextStyle(
                                      fontSize: 18,
                                      color: Colors.grey,
                                    ),
                                  ),
                                )
                                : ListView.builder(
                                  itemCount: viewModel.searchResults.length,
                                  itemBuilder: (context, index) {
                                    final item = viewModel.searchResults[index];
                                    return Card(
                                      elevation: 3,
                                      margin: const EdgeInsets.symmetric(
                                        vertical: 8,
                                        horizontal: 5,
                                      ),
                                      shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(15),
                                      ),
                                      child: ListTile(
                                        leading: Image.network(item.image),
                                        title: Text(
                                          item.title,
                                          style: const TextStyle(
                                            fontSize: 18,
                                            fontWeight: FontWeight.w500,
                                          ),
                                        ),
                                        subtitle: Text(item.mallName),
                                      ),
                                    );
                                  },
                                ),
                      ),
                ],
              ),
            ),
            backgroundColor: Colors.grey[100],
          );
        },
      ),
    );
  }
}
