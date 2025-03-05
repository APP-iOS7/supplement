import 'package:flutter/material.dart';
import 'package:supplementary_app/screens/healthcheck/health_concern_screen.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: ElevatedButton(
        onPressed: () => _supplementRecommendButtonPressed(context),
        child: Text('추천해줘'),
      ),
    );
  }

  _supplementRecommendButtonPressed(BuildContext context) {
    Navigator.of(
      context,
    ).push(MaterialPageRoute(builder: (context) => HealthConcernScreen()));
  }
}
