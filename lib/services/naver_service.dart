import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:supplementary_app/models/naver_search_Item_model.dart';
import 'package:supplementary_app/secrets.dart';

class NaverService {
  final String _baseUrl = 'https://openapi.naver.com/v1/search/shop.json';

  Map<String, String> _getHeaders() {
    return {
      'X-Naver-Client-Id': Secrets.naverClientId,
      'X-Naver-Client-Secret': Secrets.naverClientSecret,
    };
  }

  String _removeHtmlTags(String htmlString) {
    final RegExp exp = RegExp(r'<[^>]*>', multiLine: true, caseSensitive: true);
    return htmlString.replaceAll(exp, '');
  }

  Future<List<SearchItem>> searchNaverShopping(String query) async {
    final response = await http.get(
      Uri.parse('$_baseUrl?query=$query'),
      headers: _getHeaders(),
    );

    if (response.statusCode == 200) {
      final jsonResponse = jsonDecode(response.body) as Map<String, dynamic>;
      final items = jsonResponse['items'] as List;
      return items.map((item) {
        final searchItem = SearchItem.fromJson(item);
        searchItem.title = _removeHtmlTags(searchItem.title);
        return searchItem;
      }).toList();
    } else {
      print('API 호출 실패: ${response.statusCode}');
      print(response.body);
      throw '네이버 쇼핑 검색 실패';
    }
  }

  Future<String> getImageUrlFromNaverShopping(String query) async {
    final response = await http.get(
      Uri.parse('$_baseUrl?query=$query&display=1'),
      headers: _getHeaders(),
    );

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
