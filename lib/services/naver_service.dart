import 'dart:convert';

import 'package:http/http.dart' as http;

//아직 미완성. 데이터 가공 및 리턴 받아야 함.

class NaverService {
  Future<void> searchNaverShopping(String query) async {
    final baseUrl =
        'https://openapi.naver.com/v1/search/shop.json?query=$query';
    final headers = {
      'X-Naver-Client-Id': 'RDrpoiZKVn7qODKwQTkh',
      'X-Naver-Client-Secret': '1N0Hz55gfL',
    };

    final response = await http.get(Uri.parse(baseUrl), headers: headers);

    if (response.statusCode == 200) {
      final jsonResponse = jsonDecode(response.body) as Map<String, dynamic>;
      print(jsonResponse);
    } else {
      print('API 호출 실패: ${response.statusCode}');
      print(response.body);
    }
  }
}
