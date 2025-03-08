import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:supplementary_app/screens/healthcheck/health_concern_screen.dart';
import 'package:supplementary_app/services/auth_service.dart';
import 'package:supplementary_app/screens/banner/banner_screen.dart';
import 'package:supplementary_app/viewmodels/home/home_screen_view_model.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) => HomeScreenViewModel(context: context),
      child: Consumer<HomeScreenViewModel>(
        builder: (context, viewModel, child) {
          return _HomeScreen(viewModel: viewModel);
        },
      ),
    );
  }
}

class _HomeScreen extends StatelessWidget {
  const _HomeScreen({required this.viewModel});
  final HomeScreenViewModel viewModel;

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: SingleChildScrollView(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // 배너 캐러셀 화면을 상단에 추가
            BannerScreen(),
            Divider(),
            _recommendations(),
            Divider(),
            itemRecommendButton(context),
            ElevatedButton(
              onPressed: () => AuthService().signOut(),
              child: Text('로그아웃'),
            ),
          ],
        ),
      ),
    );
  }

  ElevatedButton itemRecommendButton(BuildContext context) {
    return ElevatedButton(
      onPressed:
          () => Navigator.of(context).push(
            MaterialPageRoute(builder: (context) => HealthConcernScreen()),
          ),
      child: Text('추천해줘'),
    );
  }

  Widget _recommendations() {
    return SizedBox(
      height: 280,
      width: 150,
      child:
          viewModel.recommendList.isEmpty
              ? const Center(
                child: Text(
                  '추천받은 영양제가 없어요\n추천을 받아보세요',
                  textAlign: TextAlign.center,
                ),
              )
              : GridView.builder(
                scrollDirection: Axis.horizontal,
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 1,
                  mainAxisSpacing: 4,
                  mainAxisExtent: 180,
                  crossAxisSpacing: 0,
                ),
                itemCount: viewModel.recommendList.length,
                itemBuilder: (context, index) {
                  final item = viewModel.recommendList[index];
                  return Card(
                    margin: EdgeInsets.symmetric(horizontal: 2),
                    clipBehavior: Clip.antiAlias,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Expanded(
                          flex: 3,
                          child: SizedBox(
                            width: double.infinity,
                            child: Image.network(
                              item.imageLink!,
                              fit: BoxFit.cover,
                            ),
                          ),
                        ),
                        Expanded(
                          flex: 2,
                          child: Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  item.name,
                                  maxLines: 2,
                                  overflow: TextOverflow.ellipsis,
                                ),
                                const SizedBox(height: 4),
                                Text(item.price),
                                Text('평점: ${item.rating}'),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                  );
                },
              ),
    );
  }
}
