import 'package:flutter/material.dart';
import 'package:supplementary_app/screens/healthcheck/smoking_screen.dart';

class HealthConcernScreen extends StatefulWidget {
  const HealthConcernScreen({super.key});

  @override
  State<HealthConcernScreen> createState() => _HealthConcernScreenState();
}

class _HealthConcernScreenState extends State<HealthConcernScreen> {
  final List<Map<String, dynamic>> healthConcerns = [
    {
      'title': '면역력 강화',
      'icon': 'assets/icons/immune.png',
      'color': const Color.fromARGB(255, 255, 231, 247),
      'isSelected': false,
      'tag': '',
    },
    {
      'title': '체중 감량/근육 증가',
      'icon': 'assets/icons/muscle.png',
      'color': const Color.fromARGB(255, 255, 231, 247),
      'isSelected': false,
      'tag': '',
    },
    {
      'title': '피로 회복',
      'icon': 'assets/icons/tiredness.png',
      'color': const Color.fromARGB(255, 255, 231, 247),
      'isSelected': false,
      'tag': '',
    },
    {
      'title': '피부 건강',
      'icon': 'assets/icons/depilation.png',
      'color': const Color.fromARGB(255, 255, 231, 247),
      'isSelected': false,
      'tag': '',
    },
    {
      'title': '심혈관 건강',
      'icon': 'assets/icons/heart.png',
      'color': const Color.fromARGB(255, 255, 231, 247),
      'isSelected': false,
      'tag': '',
    },
    {
      'title': '뇌 기능 & 기억력',
      'icon': 'assets/icons/brainstorm.png',
      'color': const Color.fromARGB(255, 255, 231, 247),
      'isSelected': false,
      'tag': '',
    },
    {
      'title': '눈 건강',
      'icon': 'assets/icons/eyes.png',
      'color': const Color.fromARGB(255, 255, 231, 247),
      'isSelected': false,
      'tag': '',
    },
    {
      'title': '소화 건강 / 장 건강',
      'icon': 'assets/icons/stomach.png',
      'color': const Color.fromARGB(255, 255, 231, 247),
      'isSelected': false,
      'tag': '',
    },
    {
      'title': '혈당 조절',
      'icon': 'assets/icons/sugarblood.png',
      'color':const Color.fromARGB(255, 255, 231, 247),
      'isSelected': false,
      'tag': '',
    },
    {
      'title': '갱년기 건강',
      'icon': 'assets/icons/menopause.png',
      'color': const Color.fromARGB(255, 255, 231, 247),
      'isSelected': false,
      'tag': '',
    },
    {
      'title': '스트레스 완화',
      'icon': 'assets/icons/headache.png',
      'color': const Color.fromARGB(255, 255, 231, 247),
      'isSelected': false,
      'tag': '',
    },
    {
      'title': '치아 건강',
      'icon': 'assets/icons/tooth.png',
      'color': const Color.fromARGB(255, 255, 231, 247),
      'isSelected': false,
      'tag': '',
    }
  ];

  int selectedCount = 0;
  final int maxSelections = 8;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Navigator.of(context).pop(),
        ),
        title: Text('', style: TextStyle(color: Colors.grey)),
        centerTitle: true,
        backgroundColor: Colors.transparent,
        elevation: 0,
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(20.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  '고민되시거나 개선하고 싶은\n건강고민을 선택해주세요',
                  style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 10),
                Text(
                  '최대 $maxSelections개 선택',
                  style: TextStyle(
                    color: Colors.grey,
                    fontSize: 16,
                  ),
                ),
              ],
            ),
          ),
          Expanded(
            child: GridView.builder(
              padding: const EdgeInsets.all(16),
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 3,
                childAspectRatio: 0.85,
                crossAxisSpacing: 12,
                mainAxisSpacing: 12,
              ),
              itemCount: healthConcerns.length,
              itemBuilder: (context, index) {
                final concern = healthConcerns[index];
                return GestureDetector(
                  onTap: () {
                    setState(() {
                      if (concern['isSelected']) {
                        concern['isSelected'] = false;
                        selectedCount--;
                      } else {
                        if (selectedCount < maxSelections) {
                          concern['isSelected'] = true;
                          selectedCount++;
                        }
                      }
                    });
                  },
                  child: Container(
                    decoration: BoxDecoration(
                      color: concern['color'],
                      borderRadius: BorderRadius.circular(16),
                      border: concern['isSelected']
                          ? Border.all(color: Colors.blue, width: 2)
                          : null,
                    ),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        if (concern['tag'].isNotEmpty)
                          Container(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 8, vertical: 2),
                            decoration: BoxDecoration(
                              color: Colors.purple.shade300,
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: Text(
                              concern['tag'],
                              style: const TextStyle(
                                color: Colors.white,
                                fontSize: 12,
                              ),
                            ),
                          ),
                        const SizedBox(height: 8),
                        Image.asset(
                          concern['icon'],
                          width: 60,
                          height: 60,
                          errorBuilder: (context, error, stackTrace) {
                            return Icon(
                              Icons.healing,
                              size: 60,
                              color: Colors.blue.shade700,
                            );
                          },
                        ),
                        const SizedBox(height: 8),
                        Text(
                          concern['title'],
                          style: const TextStyle(
                            fontSize: 13,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: ElevatedButton(
              onPressed: selectedCount > 0
                  ? () {
                      // 선택된 건강 고민들을 처리하는 로직
                      final selectedConcerns = healthConcerns
                          .where((concern) => concern['isSelected'])
                          .toList();
                      
                      // 다음 화면(SmokingScreen)으로 이동
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const SmokingScreen(),
                        ),
                      ).then((smokingData) {
                        // 필요한 경우 여기서 smokingData 처리
                      });
                    }
                  : null,
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.purple,
                minimumSize: const Size(double.infinity, 56),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(16),
                ),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Text(
                    '확인',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const Spacer(),
                  Text(
                    '$selectedCount/$maxSelections',
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 16,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}