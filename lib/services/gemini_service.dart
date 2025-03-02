import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:supplementary_app/secrets.dart';

//파라메터와 리턴 수정해야함. -> 리런은 List<String>으로.

class GeminiService {
  final String _baseUrl =
      'https://generativelanguage.googleapis.com/v1beta/models/gemini-2.0-flash:generateContent?key=${Secrets.geminiApi}';

  Future<List<String>> getRecommendSupplement() async {
    final headers = {'Content-Type': 'application/json'};
    final body = jsonEncode({
      "contents": [
        {
          "parts": [
            {
              "text": '''
나는 31세 여성이며, 수면 장애를 개선하고 싶어. 
      이를 위해 도움이 되는 영양제 제품 10개를 추천해줘. 
      브랜드명을 포함한 정확한 제품명을 제공해줘. 
      반드시 JSON 형식으로 응답해야 하며, 줄바꿈 없이 한 줄 JSON으로 반환해. 
      JSON 코드 블록( ```json ... ``` )을 사용하지 마. 
      추가적인 설명 없이 순수한 JSON 데이터만 반환해. 
      정확한 JSON 형식은 다음과 같아:
      
      {
        "recommendations": [
          {"name": ""},
          {"name": ""},
          {"name": ""},
          {"name": ""},
          {"name": ""},
          {"name": ""},
          {"name": ""},
          {"name": ""},
          {"name": ""},
          {"name": ""}
        ]
      }
      
      줄바꿈 없이, 한 줄 JSON 데이터만 응답해.
      ''',
            },
          ],
        },
      ],
    });

    final response = await http.post(
      Uri.parse(_baseUrl),
      headers: headers,
      body: body,
    );

    if (response.statusCode == 200) {
      final jsonResponse = jsonDecode(response.body) as Map<String, dynamic>;
      String rawText =
          jsonResponse['candidates'][0]['content']['parts'][0]['text'];
      Map<String, dynamic> parsedJson = jsonDecode(rawText);

      List<String> recommendations =
          (parsedJson['recommendations'] as List)
              .map((item) => item['name'] as String)
              .toList();
      return recommendations;
    } else {
      print('API 호출 실패: ${response.statusCode}');
      print(response.body);
      throw '지미나이';
    }
  }
}
