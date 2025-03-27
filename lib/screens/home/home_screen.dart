import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:supplementary_app/screens/healthcheck/health_concern_screen.dart';
import 'package:supplementary_app/screens/search/item_detail_screen.dart';
import 'package:supplementary_app/screens/banner/banner_screen.dart';
import 'package:supplementary_app/viewmodels/home/home_screen_view_model.dart';
import 'package:lottie/lottie.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) => HomeScreenViewModel(context: context),
      child: Consumer<HomeScreenViewModel>(
        builder: (context, viewModel, _) {
          return _HomeScreen(viewModel: viewModel);
        },
      ),
    );
  }
}

class _HomeScreen extends StatelessWidget {
  const _HomeScreen({required this.viewModel});
  final HomeScreenViewModel viewModel;

  static const double basePadding = 16.0;
  static const double halfPadding = 8.0;
  static const double smallPadding = 4.0;

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: SingleChildScrollView(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            const BannerScreen(),
            const Divider(),
            const SizedBox(height: halfPadding),
            Padding(
              padding: const EdgeInsets.symmetric(
                vertical: halfPadding,
                horizontal: basePadding,
              ),
              child: Text(
                '추천해 드렸어요!',
                style: Theme.of(context).textTheme.headlineMedium,
              ),
            ),
            const SizedBox(height: halfPadding),
            _recommendations(context),
            const SizedBox(height: 8),
            itemRecommendButton(context),
            const SizedBox(height: 8),
          ],
        ),
      ),
    );
  }

  Widget itemRecommendButton(BuildContext context) {
    return Center(
      child: ElevatedButton(
        onPressed:
            () => Navigator.of(context).push(
              MaterialPageRoute(
                builder: (context) => const HealthConcernScreen(),
              ),
            ),
        style: ElevatedButton.styleFrom(
          backgroundColor: Theme.of(context).colorScheme.primary,
          padding: const EdgeInsets.symmetric(vertical: 15, horizontal: 40),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(35),
          ),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 24,
              height: 24,
              alignment: Alignment.center,
              child: Transform.scale(
                scale: 3.0,
                child: Lottie.asset(
                  'assets/animations/loading.json',
                  fit: BoxFit.cover,
                ),
              ),
            ),
            const SizedBox(width: 10),
            Text(
              '내 몸에 꼭 맞는 영양제 찾으러 가기',
              style: Theme.of(context).textTheme.titleMedium?.copyWith(
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _recommendations(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(left: 16.0, right: 16.0),
      child: SizedBox(
        height: 300,
        child:
            viewModel.recommendList.isEmpty
                ? Center(
                  child: Text(
                    '추천받은 영양제가 없어요\n추천을 받아보세요',
                    textAlign: TextAlign.center,
                  ),
                )
                : GridView.builder(
                  scrollDirection: Axis.horizontal,
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 1,
                    mainAxisSpacing: smallPadding,
                    mainAxisExtent: 180,
                    crossAxisSpacing: 0,
                  ),
                  itemCount: viewModel.recommendList.length,
                  itemBuilder: (context, index) {
                    final item = viewModel.recommendList[index];
                    return GestureDetector(
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder:
                                (context) => ItemDetailScreen(
                                  itemTitle: item.name,
                                  imageUrl: item.imageLink!,
                                  price: item.price,
                                ),
                          ),
                        );
                      },
                      child: Card(
                        margin: const EdgeInsets.all(smallPadding),
                        clipBehavior: Clip.antiAlias,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Expanded(
                              flex: 5,
                              child: SizedBox(
                                width: double.infinity,
                                child: Image.network(
                                  item.imageLink ??
                                      'https://via.placeholder.com/500',
                                  fit: BoxFit.cover,
                                ),
                              ),
                            ),
                            Expanded(
                              flex: 3,
                              child: Padding(
                                padding: const EdgeInsets.all(halfPadding),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      item.name,
                                      maxLines: 2,
                                      overflow: TextOverflow.ellipsis,
                                      style: Theme.of(
                                        context,
                                      ).textTheme.bodyMedium?.copyWith(
                                        fontWeight: FontWeight.w500,
                                      ),
                                    ),
                                    const SizedBox(height: smallPadding),
                                    Text(item.price),
                                    Text('평점: ${item.rating}'),
                                  ],
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    );
                  },
                ),
      ),
    );
  }
}
