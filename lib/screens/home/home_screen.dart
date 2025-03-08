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
  final viewModel;

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        // 배너 캐러셀 화면을 상단에 추가
        BannerScreen(),
        ElevatedButton(
          onPressed: () => _supplementRecommendButtonPressed(context),
          child: Text('추천해줘'),
        ),
        ElevatedButton(
          onPressed: () => AuthService().signOut(),
          child: Text('로그아웃'),
        ),
      ],
    );
  }

  _supplementRecommendButtonPressed(BuildContext context) {
    Navigator.of(
      context,
    ).push(MaterialPageRoute(builder: (context) => HealthConcernScreen()));
  }
}
