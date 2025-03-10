import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:supplementary_app/screens/healthcheck/health_concern_screen.dart';
import 'package:supplementary_app/screens/search/item_detail_screen.dart';
import 'package:supplementary_app/screens/banner/banner_screen.dart';
import 'package:supplementary_app/viewmodels/home/home_screen_view_model.dart';
// 로티 애니메이션 라이브러리 추가
import 'package:lottie/lottie.dart';

// HomeScreen 위젯: 앱의 홈 화면을 구성하는 상태 비저장 위젯
class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    // ChangeNotifierProvider를 사용하여 HomeScreenViewModel을 제공
    // ViewModel을 통해 화면 상태를 관리하고 UI와 데이터를 연결
    return ChangeNotifierProvider(
      create: (context) => HomeScreenViewModel(context: context),
      child: Consumer<HomeScreenViewModel>(
        // Consumer를 통해 ViewModel의 상태 변화를 감지하고 UI를 업데이트
        builder: (context, viewModel, _) {
          return _HomeScreen(viewModel: viewModel); // _HomeScreen으로 UI 위임
        },
      ),
    );
  }
}

// _HomeScreen 위젯: 홈 화면의 실제 UI를 구성하는 내부 위젯
class _HomeScreen extends StatelessWidget {
  const _HomeScreen({required this.viewModel});
  final HomeScreenViewModel viewModel; // ViewModel 인스턴스를 받아 데이터 관리

  // 일관된 간격을 위한 상수
  static const double basePadding = 16.0; // 기본 패딩
  static const double halfPadding = 8.0; // 중간 패딩
  static const double smallPadding = 4.0; // 작은 패딩

  @override
  Widget build(BuildContext context) {
    // 화면 하단 패딩 정보 (네비게이션 바 높이)
    final bottomPadding = MediaQuery.of(context).padding.bottom;
    // 안전 영역 패딩 계산
    final safeBottomPadding =
        bottomPadding > 0 ? bottomPadding + halfPadding : basePadding;

    // SafeArea: 화면의 노치나 상태바 영역을 피해서 안전하게 콘텐츠 배치
    return SafeArea(
      child: SingleChildScrollView(
        // SingleChildScrollView: 콘텐츠가 길어질 경우 세로 스크롤 가능
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center, // 세로 중앙 정렬
          crossAxisAlignment: CrossAxisAlignment.stretch, // 가로로 꽉 채움
          children: [
            const BannerScreen(), // 상단 배너 화면 표시
            const Divider(), // 배너와 추천 섹션 사이 구분선
            // 구분선과 제목 사이 간격
            const SizedBox(height: halfPadding),
            // 제목 영역
            Padding(
              padding: const EdgeInsets.symmetric(
                vertical: halfPadding,
                horizontal: basePadding,
              ),
              child: Text(
                '추천해 드렸어요!', // 추천 섹션 제목
                style: Theme.of(context).textTheme.headlineMedium, // 제목 글자 스타일
              ),
            ),
            // 제목과 추천 목록 사이 간격
            const SizedBox(height: halfPadding),
            _recommendations(context), // 추천 영양제 목록 표시
            // 카드와 버튼 사이 간격
            const SizedBox(height: 8),
            itemRecommendButton(context), // 추천 버튼 위젯
            // 버튼과 네비게이션 바 사이 간격
            const SizedBox(height: 8),
          ],
        ),
      ),
    );
  }

  // 영양제 추천 버튼 위젯
  Widget itemRecommendButton(BuildContext context) {
    return Center(
      child: ElevatedButton(
        onPressed:
            () => Navigator.of(context).push(
              // 버튼 클릭 시 HealthConcernScreen으로 이동
              MaterialPageRoute(
                builder: (context) => const HealthConcernScreen(),
              ),
            ),
        // 테마의 버튼 스타일 사용
        style: ElevatedButton.styleFrom(
          padding: const EdgeInsets.symmetric(
            vertical: 15, // 세로 패딩
            horizontal: 40, // 가로 패딩
          ),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(35), // 둥근 모서리
          ),
        ),
        // 버튼 내용: 아이콘과 텍스트
        child: Row(
          mainAxisSize: MainAxisSize.min, // 내용에 맞는 크기
          children: [
            // 로티 애니메이션 컨테이너
            Container(
              width: 24,
              height: 24,
              alignment: Alignment.center,
              child: Transform.scale(
                scale: 3.0, // 애니메이션 확대
                child: Lottie.asset(
                  'assets/animations/loading.json',
                  fit: BoxFit.cover,
                ),
              ),
            ),
            const SizedBox(width: 10), // 아이콘과 텍스트 사이 간격
            // 버튼 텍스트
            Text(
              '내 몸에 꼭 맞는 영양제 찾으러 가기',
              style: Theme.of(
                context,
              ).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold),
            ),
          ],
        ),
      ),
    );
  }

  // 추천 영양제 목록 위젯
  Widget _recommendations(BuildContext context) {
    return Padding(
      // 좌우 패딩만 적용
      padding: const EdgeInsets.only(left: 16.0, right: 16.0),
      child: SizedBox(
        height: 300, // 목록 높이
        child:
            viewModel.recommendList.isEmpty
                ? Center(
                  // 추천 목록이 비어 있을 경우 메시지 표시
                  child: Text(
                    '추천받은 영양제가 없어요\n추천을 받아보세요',
                    textAlign: TextAlign.center,
                  ),
                )
                : GridView.builder(
                  scrollDirection: Axis.horizontal, // 가로 스크롤
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 1, // 한 줄에 하나의 아이템
                    mainAxisSpacing: smallPadding, // 아이템 간 간격
                    mainAxisExtent: 180, // 카드 가로 길이
                    crossAxisSpacing: 0, // 세로 간격 없음
                  ),
                  itemCount: viewModel.recommendList.length, // 아이템 수
                  itemBuilder: (context, index) {
                    final item = viewModel.recommendList[index]; // 현재 아이템
                    return GestureDetector(
                      // 아이템 클릭 시 상세 화면으로 이동
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder:
                                (context) => ItemDetailScreen(
                                  itemTitle: item.name,
                                  imageUrl: item.imageLink!,
                                  price: item.price,
                                ),
                          ),
                        );
                      },
                      child: Card(
                        // 균일한 마진 적용
                        margin: const EdgeInsets.all(smallPadding),
                        clipBehavior: Clip.antiAlias, // 내용 잘림 방지
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start, // 왼쪽 정렬
                          children: [
                            // 이미지 영역 (5/8 비율)
                            Expanded(
                              flex: 5,
                              child: SizedBox(
                                width: double.infinity,
                                child: Image.network(
                                  item.imageLink ??
                                      'https://via.placeholder.com/500',
                                  fit: BoxFit.cover,
                                ),
                              ),
                            ),
                            // 텍스트 영역 (3/8 비율)
                            Expanded(
                              flex: 3,
                              child: Padding(
                                padding: const EdgeInsets.all(halfPadding),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    // 제품명
                                    Text(
                                      item.name,
                                      maxLines: 2,
                                      overflow: TextOverflow.ellipsis,
                                      style: Theme.of(
                                        context,
                                      ).textTheme.bodyMedium?.copyWith(
                                        fontWeight: FontWeight.w500,
                                      ),
                                    ),
                                    // 텍스트 간격
                                    const SizedBox(height: smallPadding),
                                    // 가격
                                    Text(item.price),
                                    // 평점
                                    Text('평점: ${item.rating}'),
                                  ],
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    );
                  },
                ),
      ),
    );
  }
}
