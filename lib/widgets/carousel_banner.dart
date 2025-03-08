// Flutter의 기본 UI 도구를 가져옴 (버튼, 텍스트, 이미지 등을 만들 때 씀)
// Material Design 스타일의 위젯을 사용하기 위해 필요
import 'package:flutter/material.dart';

// 타이머 기능을 사용하기 위해 필요한 도구를 가져옴 (자동으로 사진 넘기기 위함)
// Dart의 기본 라이브러리로, 주기적인 작업을 실행할 때 사용
import 'dart:async';

// BannerItem이라는 데이터 모델을 정의한 파일을 가져옴 (배너의 이미지, 제목, 설명 등을 담음)
// '../../models/banner_item_model.dart'는 프로젝트 구조상 상위 폴더에서 가져옴
import '../../models/banner_item_model.dart';

// 이미지 캐싱을 위한 패키지 추가
// 네트워크 이미지를 캐싱해서 로딩 속도를 개선하고 데이터 사용량을 줄임
import 'package:cached_network_image/cached_network_image.dart';

// 캐러셀(사진이 자동으로 넘어가는 슬라이드 쇼)을 만드는 위젯
// StatefulWidget은 상태가 바뀔 수 있는(동적인) 위젯으로, 페이지 이동 등을 관리
class CarouselBanner extends StatefulWidget {
  // 밖에서 주는 배너 데이터 목록 (예: [배너1, 배너2, 배너3])
  final List<BannerItem> bannerItems;

  // 캐러셀의 높이 (기본값은 200, 밖에서 변경 가능)
  final double height;

  // 배너를 클릭했을 때 무슨 일을 할지 알려주는 함수 (밖에서 줌)
  final Function(BannerItem) onBannerTap;

  // 위젯을 만들 때 필요한 정보를 받는 곳
  const CarouselBanner({
    super.key, // 위젯을 구분하는 고유 키 (선택 가능)
    required this.bannerItems, // 배너 목록은 필수!
    this.height = 200, // 높이는 기본값 200으로, 안 주면 이걸 씀
    required this.onBannerTap, // 클릭했을 때 할 일을 필수로 줘야 해
  });

  // 상태를 관리하는 클래스를 연결
  @override
  State<CarouselBanner> createState() => _CarouselBannerState();
}

// 캐러셀의 상태를 관리하는 클래스
class _CarouselBannerState extends State<CarouselBanner> {
  // 페이지 전환을 제어하는 도구 (사진을 왼쪽/오른쪽으로 넘기게 해줌)
  final PageController _pageController = PageController();

  // 지금 보고 있는 페이지 번호 (0부터 시작)
  int _currentPage = 0;

  // 자동으로 사진을 넘기기 위한 타이머 (나중에 끄거나 켤 수 있음)
  Timer? _timer;

  // 위젯이 화면에 처음 나타날 때 실행되는 곳
  @override
  void initState() {
    super.initState(); // 부모 클래스 초기화 (필수)
    _startAutoSlide(); // 자동으로 사진 넘기기 시작!
  }

  // 사진을 자동으로 넘기는 함수
  void _startAutoSlide() {
    // 500초마다 사진을 넘기도록 설정 (원래 의도는 아마 5초였을 가능성)
    _timer = Timer.periodic(const Duration(seconds: 500), (timer) {
      // 현재 페이지가 마지막 페이지가 아니면 다음으로, 맞으면 처음으로
      if (_currentPage < widget.bannerItems.length - 1) {
        _currentPage++; // 다음 페이지로 넘김
      } else {
        _currentPage = 0; // 처음으로 돌아감
      }

      // 페이지 컨트롤러가 준비되어 있으면 부드럽게 이동
      if (_pageController.hasClients) {
        _pageController.animateToPage(
          _currentPage, // 이동할 페이지 번호
          duration: const Duration(milliseconds: 300), // 0.3초 동안 천천히 이동
          curve: Curves.easeInOut, // 부드러운 애니메이션 효과 (시작과 끝이 자연스러움)
        );
      }
    });
  }

  // 위젯이 화면에서 사라질 때 정리하는 곳
  @override
  void dispose() {
    _timer?.cancel(); // 타이머를 끄기 (메모리 낭비 방지)
    _pageController.dispose(); // 페이지 컨트롤러 정리 (메모리 정리)
    super.dispose(); // 부모 클래스 정리
  }

  // 화면에 보여줄 UI를 만드는 곳
  @override
  Widget build(BuildContext context) {
    return Column(
      // 세로 방향으로 위젯들을 배치 (캐러셀 + 페이지 인디케이터)
      children: [
        // 캐러셀의 주요 컨테이너 - 설정된 높이만큼 공간 확보
        SizedBox(
          height: widget.height, // 외부에서 전달받은 높이 적용
          child: PageView.builder(
            // 스와이프로 페이지를 넘길 수 있는 페이지뷰 생성
            controller: _pageController, // 페이지 이동을 제어하는 컨트롤러
            physics:
                const BouncingScrollPhysics(), // 스크롤 물리 효과 추가 (iOS 스타일 바운스)
            onPageChanged: (index) {
              // 사용자가 스와이프해서 페이지가 변경될 때 호출
              setState(() {
                _currentPage = index; // 현재 페이지 상태 업데이트 (화면 다시 그림)
              });
            },
            itemCount: widget.bannerItems.length, // 전체 배너 아이템 개수
            itemBuilder: (context, index) {
              // 각 배너 아이템을 클릭 가능한 요소로 만듦
              return GestureDetector(
                onTap:
                    () => widget.onBannerTap(
                      widget.bannerItems[index],
                    ), // 배너 클릭 시 외부 함수 실행
                child: Container(
                  margin: const EdgeInsets.all(10), // 모든 방향으로 10픽셀 여백
                  decoration: BoxDecoration(
                    // 컨테이너 스타일 정의
                    borderRadius: BorderRadius.circular(
                      20,
                    ), // 모서리 둥글게 (20픽셀 반경)
                    boxShadow: [
                      // 그림자 효과 설정
                      BoxShadow(
                        color: Colors.black.withValues(
                          alpha: 0.1,
                        ), // 약간의 검은 그림자
                        blurRadius: 2, // 그림자 흐림 정도
                        offset: const Offset(0, 1), // 그림자 위치 (아래쪽으로 1픽셀)
                      ),
                    ],
                  ),
                  child: ClipRRect(
                    // 자식 위젯이 부모의 둥근 모서리에 맞게 잘리도록 함
                    borderRadius: BorderRadius.circular(20), // 컨테이너와 동일한 라운드 처리
                    child: Stack(
                      fit: StackFit.expand, // Stack이 가능한 모든 공간을 차지하도록 설정
                      children: [
                        // CachedNetworkImage로 네트워크 이미지 표시 (캐싱 적용)
                        CachedNetworkImage(
                          imageUrl:
                              widget.bannerItems[index].imageUrl, // 배너 이미지 URL
                          fit: BoxFit.cover, // 이미지가 컨테이너를 꽉 채우도록 조정
                          placeholder:
                              (context, url) => Container(
                                // 로딩 중일 때 표시할 위젯
                                color: Colors.transparent, // 투명한 배경
                                child: const SizedBox(), // 빈 공간 (로딩 인디케이터 제거)
                              ),
                          errorWidget:
                              (context, url, error) => Container(
                                // 이미지 로드 실패 시 대체 위젯
                                color: Colors.grey[200], // 연한 회색 배경
                                child: const Center(
                                  child: Icon(
                                    Icons.broken_image, // 깨진 이미지 아이콘
                                    size: 50, // 아이콘 크기
                                    color: Colors.grey, // 아이콘 색상
                                  ),
                                ),
                              ),
                          cacheKey:
                              widget.bannerItems[index].id, // 캐시 키로 배너 ID 사용
                          memCacheWidth: 1080, // 메모리 캐시 너비 (고해상도 지원)
                          fadeInDuration: const Duration(
                            milliseconds: 100,
                          ), // 페이드인 시간 단축
                        ),
                      ],
                    ),
                  ),
                ),
              );
            },
          ),
        ),

        // 캐러셀 아래 점 (현재 페이지 표시) - 페이지 인디케이터
        Padding(
          padding: const EdgeInsets.only(top: 10), // 위쪽에만 10픽셀 여백
          child: Row(
            // 점들을 가로로 배열
            mainAxisAlignment: MainAxisAlignment.center, // 가로 방향 중앙 정렬
            children: List.generate(widget.bannerItems.length, (index) {
              // 배너 개수만큼 점 생성
              return Container(
                width: _currentPage == index ? 12 : 8, // 현재 페이지면 더 넓게, 아니면 좁게
                height: 8, // 높이는 모두 동일
                margin: const EdgeInsets.symmetric(horizontal: 4), // 좌우 여백
                decoration: BoxDecoration(
                  // 점 스타일 정의
                  shape: BoxShape.circle, // 동그란 모양
                  color:
                      _currentPage == index
                          ? const Color(0xFF17B978) // 현재 페이지는 녹색
                          : Colors.grey[400], // 다른 페이지는 회색
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withValues(alpha: 0.1), // 약간의 그림자
                      blurRadius: 2, // 그림자 흐림 정도
                      offset: const Offset(0, 1), // 그림자 위치 (아래쪽으로 1픽셀)
                    ),
                  ],
                ),
              );
            }),
          ),
        ),
      ],
    );
  }
}
