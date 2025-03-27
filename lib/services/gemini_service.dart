import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:supplementary_app/models/gemini_answer_model.dart';
import 'package:supplementary_app/models/item_detail_model.dart';
import 'package:supplementary_app/models/supplement_survey_model.dart';
import 'package:supplementary_app/models/user_model.dart';
import 'package:supplementary_app/secrets.dart';

class GeminiService {
  final String _baseUrl =
      'https://generativelanguage.googleapis.com/v1beta/models/gemini-2.0-flash:generateContent?key=${Secrets.geminiApi}';

  Future<AnswerModel> getRecommendSupplement({
    required UserModel user,
    required SupplementSurveyModel survey,
  }) async {
    final headers = {'Content-Type': 'application/json'};
    final body = jsonEncode({
      "contents": [
        {
          "parts": [
            {
              "text": '''
정보 : [나이 : ${user.birthDate.year}년생, 성별 : ${user.gender}, 목적 : ${survey.goal}, 흡연 유무 : ${survey.isSmoker ? '흡연자' : '비흡연자'} 
음주 : ${survey.isDrinker}, 알러지: ${survey.alergy}, 복용중인 약: ${survey.prescribedDrugs}, 주당 운동 횟수: 주${survey.exerciseFrequencyPerWeek}회
]
이를 위해 도움이 되는 영양제 제품 1개를 추천해줘. 
브랜드명을 포함한 정확한 제품명을 제공해줘. 
반드시 JSON 형식으로 응답해야 하며, 줄바꿈 없이 한 줄 JSON으로 반환해. 
JSON 코드 블록( ```json ... ``` )을 사용하지 마. 
추가적인 설명 없이 순수한 JSON 데이터만 반환해. 
정확한 JSON 형식은 다음과 같아:

{
  "recommendation": 
    {
      "name": "제품명",
      "caution": "주의사항",
      "functionality": "기능",
      "ingredients": ["성분1", "성분2", "성분3"],
      "mainEffect": "주요 효과",
      "manufacturer": "제조사",
      "dosageAndForm": "섭취 방법",
      "recommendedFor": "추천 대상",
      "sideEffects": "부작용",
      "storage": "보관 방법",
      "imageLink": null,
      "price": "가격",
      "rating": 4.5
    }
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
      try {
        final jsonResponse = jsonDecode(response.body) as Map<String, dynamic>;
        final String jsonText =
            jsonResponse['candidates'][0]['content']['parts'][0]['text'];

        final parsedJson = jsonDecode(jsonText) as Map<String, dynamic>;
        final recommendation =
            parsedJson['recommendation'] as Map<String, dynamic>;
        return AnswerModel.fromJson(recommendation);
      } catch (e) {
        print('JSON 파싱 오류: $e');
        throw '데이터를 불러오는 중 오류 발생';
      }
    } else {
      print('API 호출 실패: ${response.statusCode}');
      print(response.body);
      throw 'API 호출 오류';
    }
  }

  Future<ItemDetail> getDetailByName(
    String productName,
    String imageUrl,
    String price,
  ) async {
    final headers = {'Content-Type': 'application/json'};
    final body = jsonEncode({
      "contents": [
        {
          "parts": [
            {
              "text": '''
$productName에 대한 상세 정보를 제공해줘. 
반드시 JSON 형식으로 응답해야 하며, 줄바꿈 없이 한 줄 JSON으로 반환해. 
JSON 코드 블록( ```json ... ``` )을 사용하지 마. 
추가적인 설명 없이 순수한 JSON 데이터만 반환해. 

정확한 JSON 형식은 다음과 같아:

{
  "detail": {
    "name": "제품명",
    "imageUrl": "$imageUrl"
    "description": "설명",
    "ingredients": ["성분1", "성분2", "성분3"],
    "functionality": "기능",
    "dosage": "섭취 방법",
    "sideEffects": "부작용",
    "caution": "주의사항",
    "manufacturer": "제조사",
    "price": "$price",
    "rating": 4.5,
  }
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
      try {
        final jsonResponse = jsonDecode(response.body) as Map<String, dynamic>;
        final String jsonText =
            jsonResponse['candidates'][0]['content']['parts'][0]['text'];

        final parsedJson = jsonDecode(jsonText) as Map<String, dynamic>;
        final detail = parsedJson['detail'] as Map<String, dynamic>;
        return ItemDetail.fromJson(detail);
      } catch (e) {
        print('JSON 파싱 오류: $e');
        throw '데이터를 불러오는 중 오류 발생';
      }
    } else {
      print('API 호출 실패: ${response.statusCode}');
      print(response.body);
      throw 'API 호출 오류';
    }
  }
}
