import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';

Widget Loading() {
  return Container(
    child: Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          SizedBox(
            width: 200,
            height: 200,
            child: Lottie.asset(
              'assets/animations/loading.json',
              fit: BoxFit.contain,
            ),
          ),
          const SizedBox(height: 24),
          Text(
            '로딩중입니다...',
            style: TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.w600,
              color: Colors.grey[800],
              letterSpacing: -0.5,
            ),
          ),
        ],
      ),
    ),
  );
}
