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
    return Column(
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
      height: 250,
      width: 150,
      child: GridView.builder(
        scrollDirection: Axis.horizontal,
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 1,
          mainAxisSpacing: 8,
        ),
        itemCount: viewModel.recommendList.length,
        itemBuilder: (context, index) {
          final item = viewModel.recommendList[index];
          if (item == 0) Text('없어요');
          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Image.network(item.imageLink!, fit: BoxFit.cover),
              const SizedBox(height: 8),
              Text(
                item.name,
                style: const TextStyle(fontWeight: FontWeight.bold),
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
              ),
              Text(item.price, style: const TextStyle(color: Colors.blue)),
            ],
          );
        },
      ),
    );
  }
}
