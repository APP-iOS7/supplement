import 'package:flutter/material.dart';
import 'package:supplementary_app/screens/healthcheck/exercise_frequency_screen.dart';

class MedicationScreen extends StatefulWidget {
  const MedicationScreen({super.key});

  @override
  State<MedicationScreen> createState() => _MedicationScreenState();
}

class _MedicationScreenState extends State<MedicationScreen> {
  String? selectedOption;
  String medicationInput = '';
  final TextEditingController _medicationController = TextEditingController();

  @override
  void dispose() {
    _medicationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Navigator.of(context).pop(),
        ),
        title: const Text('', style: TextStyle(color: Colors.grey)),
        centerTitle: true,
        backgroundColor: Colors.transparent,
        elevation: 0,
      ),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              '복용중인 약이 있다면\n알려주세요',
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 10),
            const Text(
              '영양제와 함께 복용시 주의해야 할\n약물이 있는지 확인해드릴게요',
              style: TextStyle(
                color: Colors.grey,
                fontSize: 16,
              ),
            ),
            const SizedBox(height: 30),
            _buildOptionCard('복용중인 약 없음', '복용중인 약 없음'),
            const SizedBox(height: 16),
            _buildOptionCard('복용중인 약 있음', '복용중인 약 있음'),
            
            if (selectedOption == '복용중인 약 있음')
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const SizedBox(height: 20),
                    Container(
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: Colors.grey.shade100,
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(color: Colors.grey.shade300),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text(
                            '복용중인 약을 입력해주세요',
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 16,
                            ),
                          ),
                          const SizedBox(height: 12),
                          TextField(
                            controller: _medicationController,
                            decoration: const InputDecoration(
                              hintText: '예: 혈압약, 당뇨약, 항생제 등',
                              border: OutlineInputBorder(),
                              filled: true,
                              fillColor: Colors.white,
                            ),
                            maxLines: 3,
                            onChanged: (value) {
                              setState(() {
                                medicationInput = value;
                              });
                            },
                          ),
                          const SizedBox(height: 8),
                          const Text(
                            '여러 약을 복용 중이라면 쉼표(,)로 구분해주세요',
                            style: TextStyle(
                              color: Colors.grey,
                              fontSize: 12,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              )
            else
              const Spacer(),
              
            SizedBox(
              width: double.infinity,
              height: 56,
              child: ElevatedButton(
                onPressed: selectedOption != null && 
                          (selectedOption != '복용중인 약 있음' || medicationInput.isNotEmpty)
                    ? () {
                        final result = {
                          'hasMedication': selectedOption == '복용중인 약 있음',
                          'medications': medicationInput,
                        };
                        
                        // 다음 화면(ExerciseFrequencyScreen)으로 이동
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => const ExerciseFrequencyScreen(),
                          ),
                        ).then((exerciseData) {
                          // 필요한 경우 여기서 exerciseData 처리
                          if (exerciseData != null) {
                            // 약 데이터와 운동 데이터를 합쳐서 처리할 수 있음
                            final combinedData = {
                              ...result,
                              'exerciseFrequency': exerciseData,
                            };
                            
                            // 이전 화면으로 결과 전달
                            Navigator.pop(context, combinedData);
                          }
                        });
                      }
                    : null,
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.deepPurple,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                child: const Text(
                  '다음',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildOptionCard(String title, String value) {
    final isSelected = selectedOption == value;
    
    return GestureDetector(
      onTap: () {
        setState(() {
          selectedOption = value;
          if (value == '복용중인 약 없음') {
            medicationInput = '';
            _medicationController.clear();
          }
        });
      },
      child: Container(
        width: double.infinity,
        height: 80,
        decoration: BoxDecoration(
          color: isSelected ? Colors.blue.shade50 : Colors.grey.shade100,
          borderRadius: BorderRadius.circular(16),
          border: isSelected
              ? Border.all(color: Colors.deepPurple, width: 2)
              : null,
        ),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                title,
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                ),
              ),
              if (isSelected)
                Container(
                  width: 24,
                  height: 24,
                  decoration: const BoxDecoration(
                    color: Colors.deepPurple,
                    shape: BoxShape.circle,
                  ),
                  child: const Icon(
                    Icons.check,
                    color: Colors.white,
                    size: 16,
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }
}