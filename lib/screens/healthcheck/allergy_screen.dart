import 'package:flutter/material.dart';
import 'package:supplementary_app/screens/healthcheck/medication_screen.dart';

class AllergyScreen extends StatefulWidget {
  const AllergyScreen({super.key});

  @override
  State<AllergyScreen> createState() => _AllergyScreenState();
}

class _AllergyScreenState extends State<AllergyScreen> {
  String? selectedOption;
  final List<String> allergyTypes = [
    '견과류',
    '갑각류',
    '대두',
    '글루텐',
    '특정 약 성분 (ex: 철분, 비타민C 과다 등)'
  ];
  List<String> selectedAllergies = [];
  // 특정 약 성분에 대한 사용자 입력을 저장할 변수
  String specificMedicineInput = '';
  // 텍스트 입력 컨트롤러
  final TextEditingController _specificMedicineController = TextEditingController();

  @override
  void dispose() {
    _specificMedicineController.dispose();
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
              '갖고있는 알러지가 있다면\n선택해주세요',
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 10),
            const Text(
              '각 상태에서 피해야 하는 영양성분을\n분석해드릴게요',
              style: TextStyle(
                color: Colors.grey,
                fontSize: 16,
              ),
            ),
            const SizedBox(height: 30),
            _buildOptionCard('알러지가 없어요', '알러지가 없어요'),
            const SizedBox(height: 16),
            _buildOptionCard('알러지가 있어요', '알러지가 있어요'),
            
            if (selectedOption == '알러지가 있어요')
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const SizedBox(height: 20),
                    Expanded(
                      child: SingleChildScrollView(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Wrap(
                              spacing: 8,
                              runSpacing: 8,
                              children: allergyTypes.map((type) {
                                final isSelected = selectedAllergies.contains(type);
                                return FilterChip(
                                  selected: isSelected,
                                  backgroundColor: Colors.grey.shade200,
                                  selectedColor: Colors.deepPurple.shade100,
                                  checkmarkColor: Colors.deepPurple,
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(20),
                                    side: isSelected 
                                        ? BorderSide(color: Colors.deepPurple)
                                        : BorderSide.none,
                                  ),
                                  label: Text(type),
                                  onSelected: (selected) {
                                    setState(() {
                                      if (selected) {
                                        selectedAllergies.add(type);
                                        // 특정 약 성분을 선택한 경우 다이얼로그 표시
                                        if (type == '특정 약 성분 (ex: 철분, 비타민C 과다 등)') {
                                          _showSpecificMedicineDialog();
                                        }
                                      } else {
                                        selectedAllergies.remove(type);
                                        // 특정 약 성분 선택을 해제한 경우 입력값 초기화
                                        if (type == '특정 약 성분 (ex: 철분, 비타민C 과다 등)') {
                                          specificMedicineInput = '';
                                          _specificMedicineController.clear();
                                        }
                                      }
                                    });
                                  },
                                );
                              }).toList(),
                            ),
                            
                            // 특정 약 성분이 선택되었고 입력값이 있는 경우 표시
                            if (selectedAllergies.contains('특정 약 성분 (ex: 철분, 비타민C 과다 등)') && 
                                specificMedicineInput.isNotEmpty)
                              Padding(
                                padding: const EdgeInsets.only(top: 16.0),
                                child: Container(
                                  padding: const EdgeInsets.all(12),
                                  decoration: BoxDecoration(
                                    color: Colors.deepPurple.shade50,
                                    borderRadius: BorderRadius.circular(12),
                                    border: Border.all(color: Colors.deepPurple.shade200),
                                  ),
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Row(
                                        children: [
                                          const Text(
                                            '특정 약 성분:',
                                            style: TextStyle(
                                              fontWeight: FontWeight.bold,
                                              color: Colors.deepPurple,
                                            ),
                                          ),
                                          const SizedBox(width: 8),
                                          Expanded(
                                            child: Text(
                                              specificMedicineInput,
                                              style: const TextStyle(
                                                color: Colors.black87,
                                              ),
                                            ),
                                          ),
                                          IconButton(
                                            icon: const Icon(Icons.edit, size: 18),
                                            color: Colors.deepPurple,
                                            onPressed: () {
                                              _showSpecificMedicineDialog();
                                            },
                                          ),
                                        ],
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                          ],
                        ),
                      ),
                    ),
                    if (allergyTypes.isNotEmpty)
                      Padding(
                        padding: const EdgeInsets.only(top: 16.0),
                        child: Row(
                          children: [
                            Icon(Icons.info_outline, color: Colors.amber, size: 20),
                            SizedBox(width: 8),
                            Text('찾는 알러지가 없나요?', 
                              style: TextStyle(
                                color: Colors.amber.shade800,
                                fontWeight: FontWeight.w500,
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
                          (selectedOption != '알러지가 있어요' || selectedAllergies.isNotEmpty) &&
                          (!selectedAllergies.contains('특정 약 성분 (ex: 철분, 비타민C 과다 등)') || 
                           specificMedicineInput.isNotEmpty)
                    ? () {
                        final result = {
                          'hasAllergy': selectedOption == '알러지가 있어요',
                          'allergies': selectedAllergies,
                          'specificMedicine': specificMedicineInput,
                        };
                        
                        // 다음 화면(MedicationScreen)으로 이동
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => const MedicationScreen(),
                          ),
                        ).then((medicationData) {
                          // 필요한 경우 여기서 medicationData 처리
                          if (medicationData != null) {
                            // 알러지 데이터와 약 데이터를 합쳐서 처리할 수 있음
                            final combinedData = {
                              ...result,
                              ...medicationData,
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
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Text(
                      '다음',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    if (selectedAllergies.isNotEmpty)
                      Padding(
                        padding: const EdgeInsets.only(left: 8.0),
                        child: Text(
                          '${selectedAllergies.length}개',
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 16,
                          ),
                        ),
                      ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  // 특정 약 성분 입력을 위한 다이얼로그 표시
  void _showSpecificMedicineDialog() {
    _specificMedicineController.text = specificMedicineInput;
    
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('특정 약 성분 입력'),
        content: TextField(
          controller: _specificMedicineController,
          decoration: const InputDecoration(
            hintText: '예: 철분, 비타민C, 아스피린 등',
            border: OutlineInputBorder(),
          ),
          maxLines: 3,
          autofocus: true,
        ),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.pop(context);
            },
            child: const Text('취소'),
          ),
          ElevatedButton(
            onPressed: () {
              setState(() {
                specificMedicineInput = _specificMedicineController.text.trim();
              });
              Navigator.pop(context);
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.deepPurple,
            ),
            
            child: const Text(
              '확인',
              style: TextStyle(
                color: Colors.white,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildOptionCard(String title, String value) {
    final isSelected = selectedOption == value;
    
    return GestureDetector(
      onTap: () {
        setState(() {
          selectedOption = value;
          if (value == '알러지가 없어요') {
            selectedAllergies.clear();
            specificMedicineInput = '';
            _specificMedicineController.clear();
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