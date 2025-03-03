import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:supplementary_app/screens/main_screen.dart';
import 'package:supplementary_app/services/auth_service.dart';

class GetInfoScreen extends StatefulWidget {
  const GetInfoScreen({super.key});

  @override
  State<GetInfoScreen> createState() => _GetInfoScreenState();
}

class _GetInfoScreenState extends State<GetInfoScreen> {
  // 성별 선택 상태
  String? _selectedGender;

  // 생년월일 선택 상태
  DateTime? _selectedDate;

  // 인증 서비스
  final AuthService _authService = AuthService();

  // 로딩 상태
  bool _isLoading = false;

  // 현재 로그인된 사용자
  User? _currentUser;

  @override
  void initState() {
    super.initState();
    // 현재 로그인된 사용자 확인
    _currentUser = FirebaseAuth.instance.currentUser;

    // 로그인되지 않은 상태라면 로그인 화면으로 이동
    if (_currentUser == null) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        Navigator.of(context).pop(); // 이전 화면으로 돌아가기
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('추가 정보 입력'),
        // 뒤로가기 버튼 비활성화 (반드시 정보 입력 필요)
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
                  style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                ),

                const SizedBox(height: 32),

                // 성별 선택 섹션
                const Text(
                  '성별',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 16),
                Row(
                  children: [
                    Expanded(child: _buildGenderButton('남성', 'male')),
                    const SizedBox(width: 16),
                    Expanded(child: _buildGenderButton('여성', 'female')),
                  ],
                ),

                const SizedBox(height: 32),

                // 생년월일 선택 섹션
                const Text(
                  '생년월일',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 16),
                OutlinedButton(
                  onPressed: () => _selectDate(context),
                  style: OutlinedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(vertical: 16),
                  ),
                  child: Text(
                    _selectedDate != null
                        ? '${_selectedDate!.year}년 ${_selectedDate!.month}월 ${_selectedDate!.day}일'
                        : '생년월일 선택',
                    style: const TextStyle(fontSize: 16),
                  ),
                ),

                const Spacer(),

                // 완료 버튼
                ElevatedButton(
                  onPressed: _canProceed() ? _saveUserInfoAndProceed : null,
                  style: ElevatedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(vertical: 16),
                  ),
                  child: const Text('완료', style: TextStyle(fontSize: 16)),
                ),
              ],
            ),
          ),

          // 로딩 인디케이터
          if (_isLoading)
            Container(
              color: Colors.black.withOpacity(0.5),
              child: const Center(child: CircularProgressIndicator()),
            ),
        ],
      ),
    );
  }

  // 성별 선택 버튼 위젯
  Widget _buildGenderButton(String label, String value) {
    final isSelected = _selectedGender == value;

    return ElevatedButton(
      onPressed: () {
        setState(() {
          _selectedGender = value;
        });
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

  // 생년월일 선택 다이얼로그
  Future<void> _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: _selectedDate ?? DateTime(2000),
      firstDate: DateTime(1940),
      lastDate: DateTime.now(),
      helpText: '생년월일 선택',
      confirmText: '확인',
      cancelText: '취소',
    );

    if (picked != null && picked != _selectedDate) {
      setState(() {
        _selectedDate = picked;
      });
    }
  }

  // 정보 입력이 완료되었는지 확인
  bool _canProceed() {
    return _selectedGender != null && _selectedDate != null;
  }

  // 사용자 정보 저장 및 메인 화면으로 이동
  Future<void> _saveUserInfoAndProceed() async {
    if (_currentUser == null || !_canProceed()) return;

    try {
      setState(() {
        _isLoading = true;
      });

      // 사용자 추가 정보 저장
      await _authService.saveUserInfo(
        _currentUser!.uid,
        _selectedGender!,
        _selectedDate!,
      );

      // 메인 화면으로 이동
      if (mounted) {
        Navigator.of(context).pushReplacement(
          MaterialPageRoute(builder: (context) => const MainScreen()),
        );
      }
    } catch (e) {
      // 오류 메시지 표시
      if (mounted) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text('정보 저장 오류: $e')));
      }
    } finally {
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
      }
    }
  }
}
