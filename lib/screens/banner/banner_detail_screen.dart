// Flutter에서 UI를 만들기 위한 기본 도구를 가져옴
// Material Design 스타일의 위젯을 사용하기 위해 필요해요
import 'package:flutter/material.dart';

// Markdown 형식의 텍스트를 화면에 표시하기 위한 도구를 가져옴
// HTML 대신 Markdown으로 변환된 내용을 렌더링할 때 사용
import 'package:flutter_markdown/flutter_markdown.dart';

// 외부 링크를 열기 위한 도구를 가져옴
// 사용자가 링크를 클릭하면 브라우저로 연결해줘요
import 'package:url_launcher/url_launcher.dart';

// HTML을 Markdown으로 변환해주는 도구를 가져옴
// BannerItem의 description이 HTML이라 이를 Markdown으로 바꿀 때 사용
import 'package:html2md/html2md.dart' as html2md;

// 배너 데이터의 설계도(BannerItem 클래스)가 있는 파일을 가져옴
// '../../models/banner_item_model.dart'는 프로젝트 구조상 상위 폴더에서 가져옴
import '../../models/banner_item_model.dart';

// 배너 상세 정보를 보여주는 화면을 만드는 클래스
// StatelessWidget은 상태가 변하지 않는(정적인) 화면을 만들 때 사용
class BannerDetailScreen extends StatelessWidget {
  // 화면에 표시할 배너 데이터 (외부에서 받아옴)
  final BannerItem bannerItem;

  // 생성자: bannerItem을 필수로 받아서 초기화
  // super.key는 부모 클래스에 key를 전달하기 위한 Flutter 기본 문법
  const BannerDetailScreen({super.key, required this.bannerItem});

  // 화면을 그리는 함수
  // BuildContext는 Flutter가 화면을 어디에 배치할지 아는 정보
  @override
  Widget build(BuildContext context) {
    // HTML 형식의 설명을 Markdown으로 변환
    // html2md.convert는 HTML 태그를 Markdown 문법으로 바꿔줌
    final markdownContent = html2md.convert(bannerItem.description);

    // 기본 화면 구조를 제공하는 Scaffold 위젯
    return Scaffold(
      // 상단에 앱바(뒤로가기 버튼 포함)를 추가
      appBar: AppBar(),

      // 스크롤 가능한 화면을 만들기 위해 SingleChildScrollView 사용
      body: SingleChildScrollView(
        // 세로로 쌓이는 위젯들을 배치
        child: Column(
          // 내용이 왼쪽 정렬되도록 설정
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // 배너 이미지를 표시
            Image.network(
              bannerItem.imageUrl, // 배너 이미지 URL
              width: double.infinity, // 화면 너비에 꽉 차게
              height: 250, // 이미지 높이 고정
              fit: BoxFit.fill, // 이미지가 영역을 꽉 채우도록 조정
              errorBuilder: (context, error, stackTrace) {
                // 이미지 로딩 실패 시 실행
                print('이미지 로딩 오류: $error'); // 오류 메시지 출력
                return Container(
                  width: double.infinity,
                  height: 200,
                  color: Colors.grey[200], // 회색 배경
                  child: const Center(
                    child: Text('이미지를 불러올 수 없습니다'),
                  ), // 오류 메시지 표시
                );
              },
            ),

            // 제목과 내용 사이에 여백 추가
            // 텍스트는 빈 문자열로, 사실상 여백용으로만 사용
            Padding(padding: const EdgeInsets.all(5.0), child: Text('')),

            // Markdown으로 변환된 내용을 표시
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0), // 좌우 여백 추가
              child: MarkdownBody(
                data: markdownContent, // 표시할 Markdown 내용
                selectable: true, // 텍스트 선택 가능하게 설정
                styleSheet: MarkdownStyleSheet(
                  // Markdown 스타일 정의
                  h1: const TextStyle(
                    fontSize: 25,
                    fontWeight: FontWeight.bold,
                  ), // h1 제목 스타일
                  h2: const TextStyle(
                    fontSize: 25,
                    fontWeight: FontWeight.bold,
                  ), // h2 제목 스타일
                  h3: const TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ), // h3 제목 스타일
                  h4: const TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ), // h4 제목 스타일
                  h2Padding: const EdgeInsets.only(
                    top: 60,
                    bottom: 10,
                  ), // h2 위아래 여백
                  p: const TextStyle(fontSize: 16, height: 1.5), // 본문 텍스트 스타일
                  strong: const TextStyle(
                    fontWeight: FontWeight.bold,
                  ), // 강조 텍스트 스타일
                  tableHead: TextStyle(
                    // 테이블 헤더 스타일
                    fontWeight: FontWeight.bold,
                    color: Colors.black,
                    backgroundColor: Colors.grey[200],
                  ),
                  tableBody: const TextStyle(fontSize: 16), // 테이블 본문 스타일
                  tableBorder: TableBorder.all(
                    // 테이블 테두리 스타일
                    color: Colors.grey.shade300,
                    width: 1,
                  ),
                  tableCellsPadding: const EdgeInsets.all(8), // 테이블 셀 안쪽 여백
                  horizontalRuleDecoration: BoxDecoration(
                    // 수평선 스타일
                    border: Border(
                      top: BorderSide(width: 1, color: Colors.grey.shade300),
                    ),
                  ),
                ),
                onTapLink: (text, href, title) {
                  // 링크 클릭 시 동작
                  if (href != null) {
                    launchUrl(Uri.parse(href)); // 외부 브라우저로 링크 열기
                  }
                },
                imageBuilder: (uri, title, alt) {
                  // Markdown 내 이미지 렌더링
                  return Padding(
                    padding: const EdgeInsets.symmetric(
                      vertical: 16.0,
                    ), // 이미지 위아래 여백
                    child: Image.network(
                      uri.toString(), // 이미지 URL
                      fit: BoxFit.contain, // 이미지 크기 조정
                      errorBuilder: (context, error, stackTrace) {
                        // 이미지 로딩 실패 시
                        return Container(
                          height: 150,
                          color: Colors.grey[200], // 회색 배경
                          child: Center(
                            child: Text(
                              '이미지를 불러올 수 없습니다: $alt', // 오류 메시지
                              style: TextStyle(color: Colors.grey[600]),
                            ),
                          ),
                        );
                      },
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
