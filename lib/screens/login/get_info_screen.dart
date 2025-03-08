import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:supplementary_app/screens/main_screen.dart';
import 'package:supplementary_app/viewmodels/login/get_info_viewmodel.dart';

class GetInfoScreen extends StatelessWidget {
  const GetInfoScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => GetInfoViewModel(),
      child: Consumer<GetInfoViewModel>(
        builder: (context, viewModel, child) {
          return Scaffold(
            appBar: AppBar(
              title: const Text('추가 정보 입력'),
              automaticallyImplyLeading: false,
            ),
            body: Stack(
              children: [
                Padding(
                  padding: const EdgeInsets.all(24.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      const Text(
                        '맞춤 영양제 추천을 위해\n정보를 입력해주세요',
                        style: TextStyle(
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 32),
                      const Text(
                        '성별',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 16),
                      Row(
                        children: [
                          Expanded(
                            child: _buildGenderButton(context, '남성', 'male'),
                          ),
                          const SizedBox(width: 16),
                          Expanded(
                            child: _buildGenderButton(context, '여성', 'female'),
                          ),
                        ],
                      ),
                      const SizedBox(height: 32),
                      const Text(
                        '생년월일',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 16),
                      OutlinedButton(
                        onPressed: () => viewModel.selectDate(context),
                        style: OutlinedButton.styleFrom(
                          padding: const EdgeInsets.symmetric(vertical: 16),
                        ),
                        child: Text(
                          viewModel.selectedDate != null
                              ? '${viewModel.selectedDate!.year}년 ${viewModel.selectedDate!.month}월 ${viewModel.selectedDate!.day}일'
                              : '생년월일 선택',
                          style: const TextStyle(fontSize: 16),
                        ),
                      ),
                      const Spacer(),
                      ElevatedButton(
                        onPressed:
                            viewModel.canProceed
                                ? () {
                                  viewModel.saveUserInfo();
                                  Navigator.of(context).pushReplacement(
                                    MaterialPageRoute(
                                      builder: (context) => const MainScreen(),
                                    ),
                                  );
                                }
                                : null,
                        style: ElevatedButton.styleFrom(
                          padding: const EdgeInsets.symmetric(vertical: 16),
                        ),
                        child: const Text('완료', style: TextStyle(fontSize: 16)),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }

  Widget _buildGenderButton(BuildContext context, String label, String value) {
    final viewModel = Provider.of<GetInfoViewModel>(context);
    final isSelected = viewModel.selectedGender == value;

    return ElevatedButton(
      onPressed: () {
        viewModel.selectGender = value;
      },
      style: ElevatedButton.styleFrom(
        backgroundColor:
            isSelected ? Theme.of(context).primaryColor : Colors.grey.shade200,
        foregroundColor: isSelected ? Colors.white : Colors.black,
        elevation: isSelected ? 2 : 0,
        padding: const EdgeInsets.symmetric(vertical: 16),
      ),
      child: Text(label),
    );
  }
}
