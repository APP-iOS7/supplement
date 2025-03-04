import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:supplementary_app/secrets.dart';

//아직 미완성. 데이터 가공 및 리턴 받아야 함.

class NaverService {
  Future<void> searchNaverShopping(String query) async {
    final baseUrl =
        'https://openapi.naver.com/v1/search/shop.json?query=$query';
    final headers = {
      'X-Naver-Client-Id': Secrets.naverClientId,
      'X-Naver-Client-Secret': Secrets.naverClientSecret,
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

  Future<String> getImageUrlFromNaverShopping(String query) async {
    final baseUrl =
        'https://openapi.naver.com/v1/search/shop.json?query=$query&display=1';
    final headers = {
      'X-Naver-Client-Id': Secrets.naverClientId,
      'X-Naver-Client-Secret': Secrets.naverClientSecret,
    };

    final response = await http.get(Uri.parse(baseUrl), headers: headers);
    if (response.statusCode == 200) {
      final jsonResponse = jsonDecode(response.body) as Map<String, dynamic>;
      final String imageUrl = jsonResponse['items'][0]['image'];
      return imageUrl;
    } else {
      print('API 호출 실패: ${response.statusCode}');
      print(response.body);
      throw '네이버 쇼핑 이미지 불러오기 실패';
    }
  }
}
