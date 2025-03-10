import 'package:flutter/material.dart'; // Flutter의 기본 UI 위젯 라이브러리
import 'package:flutter_markdown/flutter_markdown.dart'; // 마크다운 렌더링을 위한 패키지
import 'package:url_launcher/url_launcher.dart'; // URL을 열기 위한 패키지
import 'package:html2md/html2md.dart' as html2md; // HTML을 마크다운으로 변환하는 패키지
import '../../models/banner_item_model.dart'; // 배너 데이터 모델 파일 임포트

// 배너 상세 정보를 보여주는 StatelessWidget 클래스
class BannerDetailScreen extends StatelessWidget {
  final BannerItem bannerItem; // 화면에 표시할 배너 데이터 객체

  // 생성자: 배너 데이터를 필수로 받음
  const BannerDetailScreen({super.key, required this.bannerItem});

  @override
  // 화면을 구성하는 빌드 메서드
  Widget build(BuildContext context) {
    // 배너 설명(description)을 HTML 형식으로 가져옴
    final String html = bannerItem.description;

    // HTML에서 테이블(<table>) 부분을 추출하기 위한 정규식
    final RegExp tableRegex = RegExp(r'<table.*?</table>', dotAll: true);
    // 모든 테이블 태그를 찾음 (dotAll: 개행 문자도 포함)
    final Iterable<RegExpMatch> tableMatches = tableRegex.allMatches(html);

    // 텍스트와 테이블을 위젯으로 변환해 저장할 리스트
    List<Widget> contentWidgets = [];
    // 이전 테이블의 끝 위치를 추적하기 위한 변수
    int lastEnd = 0;

    // HTML을 순회하며 테이블과 일반 텍스트를 분리
    for (var match in tableMatches) {
      // 테이블 이전 부분이 존재하면 처리
      if (match.start > lastEnd) {
        // 테이블 전 텍스트를 추출
        final beforeTable = html.substring(lastEnd, match.start);
        // HTML을 마크다운으로 변환
        final markdownContent = html2md.convert(beforeTable);
        // 마크다운 위젯을 리스트에 추가
        contentWidgets.add(
          MarkdownBody(
            data: markdownContent, // 변환된 마크다운 텍스트
            selectable: true, // 텍스트를 선택 가능하도록 설정
            styleSheet: MarkdownStyleSheet(
              // 마크다운 스타일 정의
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
              ), // h2 제목의 상하 여백
              p: const TextStyle(
                fontSize: 16,
                height: 1.5,
              ), // 본문 텍스트 스타일 (줄 간격 포함)
              strong: const TextStyle(
                fontWeight: FontWeight.bold,
              ), // 강조 텍스트 스타일
            ),
            // 링크 클릭 시 동작 정의
            onTapLink: (text, href, title) {
              // href가 null이 아니면 URL을 실행
              if (href != null) {
                launchUrl(Uri.parse(href)); // 외부 브라우저로 링크 열기
              }
            },
          ),
        );
      }

      // 테이블 HTML 코드를 추출
      final tableHtml = match.group(0)!;
      // 테이블을 커스텀 위젯으로 변환해 리스트에 추가
      contentWidgets.add(_buildTableWidget(tableHtml));

      // 다음 시작점을 현재 테이블의 끝으로 업데이트
      lastEnd = match.end;
    }

    // 마지막 테이블 이후 남은 텍스트가 있으면 처리
    if (lastEnd < html.length) {
      // 남은 HTML 텍스트 추출
      final afterTable = html.substring(lastEnd);
      // HTML을 마크다운으로 변환
      final markdownContent = html2md.convert(afterTable);
      // 마크다운 위젯을 리스트에 추가
      contentWidgets.add(
        MarkdownBody(
          data: markdownContent, // 변환된 마크다운 텍스트
          selectable: true, // 텍스트 선택 가능
          styleSheet: MarkdownStyleSheet(
            h1: const TextStyle(
              fontSize: 25,
              fontWeight: FontWeight.bold,
            ), // h1 스타일
            h2: const TextStyle(
              fontSize: 25,
              fontWeight: FontWeight.bold,
            ), // h2 스타일
            h3: const TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
            ), // h3 스타일
            h4: const TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
            ), // h4 스타일
            h2Padding: const EdgeInsets.only(top: 60, bottom: 10), // h2 여백
            p: const TextStyle(fontSize: 16, height: 1.5), // 본문 스타일
            strong: const TextStyle(fontWeight: FontWeight.bold), // 강조 스타일
          ),
          // 링크 클릭 시 동작
          onTapLink: (text, href, title) {
            if (href != null) {
              launchUrl(Uri.parse(href)); // URL 열기
            }
          },
          // 마크다운 내 이미지 처리
          imageBuilder: (uri, title, alt) {
            return Padding(
              padding: const EdgeInsets.symmetric(vertical: 16.0), // 이미지 상하 여백
              child: Image.network(
                uri.toString(), // 이미지 URL
                fit: BoxFit.contain, // 이미지를 컨테이너에 맞게 조정
                // 이미지 로딩 실패 시 대체 UI
                errorBuilder: (context, error, stackTrace) {
                  return Container(
                    height: 150, // 고정 높이
                    color: Colors.grey[200], // 배경색
                    child: Center(
                      child: Text(
                        '이미지를 불러올 수 없습니다: $alt', // 오류 메시지
                        style: TextStyle(color: Colors.grey[600]), // 텍스트 색상
                      ),
                    ),
                  );
                },
              ),
            );
          },
        ),
      );
    }

    // 전체 화면 레이아웃 구성
    return Scaffold(
      appBar: AppBar(), // 기본 상단 앱바
      body: SingleChildScrollView(
        // 세로 스크롤 가능한 컨테이너
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start, // 좌측 정렬
          children: [
            // 배너 이미지 표시
            Image.network(
              bannerItem.imageUrl, // 배너 이미지 URL
              width: double.infinity, // 화면 전체 너비
              height: 250, // 고정 높이
              fit: BoxFit.fill, // 이미지를 공간에 꽉 채움
              // 이미지 로딩 실패 시 대체 UI
              errorBuilder: (context, error, stackTrace) {
                print('이미지 로딩 오류: $error'); // 콘솔에 오류 출력
                return Container(
                  width: double.infinity, // 전체 너비
                  height: 200, // 고정 높이
                  color: Colors.grey[200], // 배경색
                  child: const Center(child: Text('이미지를 불러올 수 없습니다')), // 오류 메시지
                );
              },
            ),

            // 이미지와 콘텐츠 사이 간격 추가
            Padding(padding: const EdgeInsets.all(5.0), child: Text('')),

            // 콘텐츠 영역
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0), // 좌우 여백
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start, // 좌측 정렬
                children: contentWidgets, // 텍스트와 테이블 위젯 리스트
              ),
            ),
            const SizedBox(height: 60),
          ],
        ),
      ),
    );
  }

  // HTML 테이블을 Flutter Table 위젯으로 변환하는 메서드
  Widget _buildTableWidget(String tableHtml) {
    // 테이블 헤더(<th>)를 추출하기 위한 정규식
    final RegExp headerRegex = RegExp(r'<th.*?>(.*?)</th>', dotAll: true);
    // 모든 헤더 텍스트를 리스트로 변환
    final headers =
        headerRegex
            .allMatches(tableHtml)
            .map((match) => match.group(1) ?? '')
            .toList();

    // 테이블 행(<tr>)을 추출하기 위한 정규식
    final RegExp rowRegex = RegExp(r'<tr.*?>(.*?)</tr>', dotAll: true);
    // 모든 행을 리스트로 변환
    final rows = rowRegex.allMatches(tableHtml).toList();

    // 데이터 행(<td>)을 저장할 리스트 (헤더 제외)
    List<List<String>> dataRows = [];
    // 헤더를 제외한 데이터 행 처리
    for (int i = 1; i < rows.length; i++) {
      final rowMatch = rows[i]; // 현재 행
      final rowContent = rowMatch.group(1) ?? ''; // 행 내용

      // 셀(<td>)을 추출하기 위한 정규식
      final RegExp cellRegex = RegExp(r'<td.*?>(.*?)</td>', dotAll: true);
      // 셀 내용을 리스트로 변환
      final cells =
          cellRegex
              .allMatches(rowContent)
              .map((match) => match.group(1) ?? '')
              .toList();

      // 데이터 행 리스트에 추가
      dataRows.add(cells);
    }

    // 열 개수 설정 (헤더 기준)
    int columnCount = headers.length;
    // 각 열의 최대 텍스트 길이를 저장할 리스트
    List<int> maxLengths = List.filled(columnCount, 0);

    // 헤더 텍스트 길이 계산
    for (int i = 0; i < headers.length; i++) {
      // HTML 태그 제거 후 텍스트만 추출
      final cleanHeader = headers[i].replaceAll(RegExp(r'<[^>]*>'), '').trim();
      // 최대 길이 갱신
      if (cleanHeader.length > maxLengths[i]) {
        maxLengths[i] = cleanHeader.length;
      }
    }

    // 데이터 행의 셀 텍스트 길이 계산
    for (var row in dataRows) {
      for (int i = 0; i < row.length && i < columnCount; i++) {
        // HTML 태그 제거 및 텍스트 처리
        String processedText = _processHtmlText(row[i]);
        // 줄바꿈으로 텍스트 분리
        List<String> lines = processedText.split('\n');
        // 각 줄의 길이 확인
        for (var line in lines) {
          if (line.length > maxLengths[i]) {
            maxLengths[i] = line.length; // 최대 길이 갱신
          }
        }
      }
    }

    // 열 너비를 저장할 맵
    Map<int, TableColumnWidth> columnWidths = {};
    // 모든 열의 텍스트 길이 합계
    int totalLength = maxLengths.fold(0, (sum, length) => sum + length);

    // 최소 열 너비 비율 (10%)
    const double minWidthRatio = 0.1;

    // 각 열의 너비 비율 계산
    for (int i = 0; i < columnCount; i++) {
      // 텍스트 길이에 비례한 비율 계산, 최소값 보장
      double ratio =
          totalLength > 0
              ? (maxLengths[i] / totalLength).clamp(minWidthRatio, 1.0)
              : 1.0 / columnCount;
      // 열 너비 설정
      columnWidths[i] = FractionColumnWidth(ratio);
    }

    // 테이블 전체 너비 계산을 위한 평균 글자 너비
    final double avgCharWidth = 10.0;
    // 총 텍스트 길이에 기반한 테이블 너비
    final double tableWidth = totalLength * avgCharWidth;
    // 최소 테이블 너비 설정
    final double minTableWidth = 600.0;
    // 테이블 오른쪽 여백
    final double rightPadding = 32.0;

    // 테이블 위젯 반환
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 16.0), // 상하 여백
      child: SingleChildScrollView(
        scrollDirection: Axis.horizontal, // 가로 스크롤 가능
        physics: const AlwaysScrollableScrollPhysics(), // 항상 스크롤 가능하도록 설정
        child: Padding(
          padding: EdgeInsets.only(right: rightPadding), // 오른쪽 여백 추가
          child: SizedBox(
            // 테이블 너비를 계산된 값 또는 최소값으로 설정
            width: tableWidth > minTableWidth ? tableWidth : minTableWidth,
            child: Table(
              border: TableBorder.all(
                color: Colors.grey.shade300,
              ), // 테이블 테두리 스타일
              columnWidths: columnWidths, // 동적 열 너비 적용
              defaultVerticalAlignment:
                  TableCellVerticalAlignment.top, // 셀 내용 상단 정렬
              children: [
                // 헤더 행 생성
                TableRow(
                  // ✅ 여길 삭제하면 됨
                  // decoration: BoxDecoration(color: Colors.grey[200]), // 헤더 배경색
                  children:
                      headers.map((header) {
                        // HTML 태그 제거 후 텍스트 추출
                        final cleanHeader =
                            header.replaceAll(RegExp(r'<[^>]*>'), '').trim();
                        return Padding(
                          padding: const EdgeInsets.all(8.0), // 셀 내부 여백
                          child: Align(
                            alignment: Alignment.topLeft, // 좌측 상단 정렬
                            child: Text(
                              cleanHeader, // 헤더 텍스트
                              style: const TextStyle(
                                fontWeight: FontWeight.bold, // 굵게
                                fontSize: 14, // 글자 크기
                              ),
                            ),
                          ),
                        );
                      }).toList(),
                ),
                // 데이터 행 생성
                ...dataRows.map((cells) {
                  return TableRow(
                    children:
                        cells.map((cell) {
                          // 셀 텍스트 처리
                          String processedText = _processHtmlText(cell);
                          // <strong> 태그 여부 확인
                          bool isBold = cell.contains('<strong>');
                          return Padding(
                            padding: const EdgeInsets.all(8.0), // 셀 내부 여백
                            child: Align(
                              alignment: Alignment.topLeft, // 좌측 상단 정렬
                              child: Text(
                                processedText, // 처리된 텍스트
                                style: TextStyle(
                                  fontSize: 14, // 글자 크기
                                  fontWeight:
                                      isBold
                                          ? FontWeight.bold
                                          : FontWeight.normal, // 굵기 조정
                                ),
                              ),
                            ),
                          );
                        }).toList(),
                  );
                }),
              ],
            ),
          ),
        ),
      ),
    );
  }

  // HTML 텍스트를 일반 텍스트로 변환하는 메서드
  String _processHtmlText(String htmlText) {
    // <br> 태그를 줄바꿈 문자로 변환
    String processedText = htmlText.replaceAll('<br>', '\n');

    // <strong> 태그 내용을 추출하고 태그 제거
    processedText = processedText.replaceAllMapped(
      RegExp(r'<strong>(.*?)</strong>', dotAll: true),
      (match) => match.group(1) ?? '',
    );

    // <span> 태그 내용을 추출하고 태그 제거 (스타일 정보 무시)
    processedText = processedText.replaceAllMapped(
      RegExp(r'<span[^>]*>(.*?)</span>', dotAll: true),
      (match) => match.group(1) ?? '',
    );

    // 나머지 모든 HTML 태그 제거
    return processedText.replaceAll(RegExp(r'<[^>]*>'), '').trim();
  }
}
