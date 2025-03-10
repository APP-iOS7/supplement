// Flutter의 기본 UI 도구를 가져옴 (버튼, 텍스트, 화면 만들 때 씀)
// Material Design 스타일의 위젯을 사용하기 위해 필요
import 'package:flutter/material.dart';

// 인터넷 링크를 열기 위한 도구를 가져옴 (배너 링크 클릭 시 브라우저로 이동)
import 'package:url_launcher/url_launcher.dart';

// 배너 데이터 설계도(BannerItem 클래스)가 있는 파일을 가져옴
import 'package:supplementary_app/models/banner_item_model.dart';

// Firestore에서 배너 데이터를 가져오는 도우미 파일을 가져옴
// BannerService 클래스를 통해 데이터베이스와 통신
import 'package:supplementary_app/services/banner_service.dart';

// 배너 슬라이드 쇼를 보여주는 위젯 파일을 가져옴
// CarouselBanner는 배너를 슬라이드 형태로 표시
import 'package:supplementary_app/widgets/carousel_banner.dart';

// 배너 상세 화면 파일을 가져옴 (배너 클릭 시 이동)
// BannerDetailScreen은 배너 세부 정보를 보여줌
import 'banner_detail_screen.dart';

// 배너를 보여주는 화면 위젯
// StatefulWidget은 화면이 바뀔 수 있는 위젯이에요 (데이터 로딩 중/완료 상태 등)
class BannerScreen extends StatefulWidget {
  // 부모 화면에서 스크롤을 제어할 수 있는 도구 (스크롤이 필요할 때 사용)
  // 선택 사항이라 없어도 괜찮아요
  final ScrollController? scrollController;

  // 위젯을 만들 때 필요한 정보를 받는 곳
  const BannerScreen({
    super.key, // 위젯 구분용 키 (선택 가능)
    this.scrollController, // 스크롤 컨트롤러 (선택)
  });

  // 상태를 관리하는 부분을 연결
  // _BannerScreenState 클래스를 만들어 상태를 관리
  @override
  State<BannerScreen> createState() => _BannerScreenState();
}

// 배너 화면의 상태를 관리하는 클래스
class _BannerScreenState extends State<BannerScreen> {
  // Firestore에서 배너 데이터를 가져오는 도우미
  // BannerService 인스턴스를 만들어 데이터베이스와 통신
  final BannerService _bannerService = BannerService();

  // 배너 목록을 저장할 리스트 (처음엔 비어 있음)
  List<BannerItem> _bannerItems = [];

  // 로딩 중인지 알려주는 스위치 (true면 로딩 중)
  bool _isLoading = true;

  // 오류 메시지를 저장할 곳 (오류가 없으면 빈 문자열)
  String _errorMessage = '';

  // 화면이 처음 만들어질 때 실행되는 함수
  @override
  void initState() {
    super.initState(); // 부모 클래스 초기화 (필수)
    _loadBanners(); // 배너 데이터를 가져오는 함수 실행
  }

  // 배너 데이터를 Firestore에서 가져오는 함수
  Future<void> _loadBanners() async {
    try {
      // 로딩 시작
      setState(() {
        _isLoading = true; // 로딩 중이라고 표시
        _errorMessage = ''; // 오류 메시지 초기화
      });

      // BannerService를 통해 Firestore에서 배너 데이터를 가져옴
      final banners = await _bannerService.getBanners();

      // 활성화된 배너만 골라내기 (isActive가 true인 배너만)
      final activeBanners = banners.where((banner) => banner.isActive).toList();

      // 로딩 끝, 데이터 저장
      setState(() {
        _bannerItems = activeBanners; // 활성화된 배너 목록 저장
        _isLoading = false; // 로딩 끝
      });

      // 배너 이미지 프리로드 (선택적)
      // 이미지를 미리 로드해서 화면에 빠르게 표시되도록 함
      if (_bannerItems.isNotEmpty && mounted) {
        for (var banner in _bannerItems) {
          precacheImage(NetworkImage(banner.imageUrl), context);
        }
      }
    } catch (e) {
      // 데이터 가져오다가 오류가 나면
      if (mounted) {
        setState(() {
          _isLoading = false; // 로딩 끝
          _errorMessage = '배너 데이터를 불러오는 중 오류가 발생했습니다.'; // 오류 메시지 저장
        });
      }
      print('Error loading banners: $e'); // 콘솔에 오류 출력
    }
  }

  // 배너를 클릭했을 때 무슨 일을 할지 정하는 함수
  void _handleBannerTap(BannerItem bannerItem) async {
    // 배너에 링크가 있는지 확인
    if (bannerItem.linkUrl != null && bannerItem.linkUrl!.isNotEmpty) {
      // 링크가 있으면 브라우저로 이동
      final Uri url = Uri.parse(bannerItem.linkUrl!); // 링크를 준비
      if (await canLaunchUrl(url)) {
        // 링크를 열 수 있으면 브라우저로 이동
        await launchUrl(url, mode: LaunchMode.externalApplication);
      } else {
        // 링크를 열 수 없으면 오류 메시지 출력
        print('Could not launch $url');
      }
    } else {
      // 링크가 없으면 상세 화면으로 이동
      if (context.mounted) {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder:
                (context) =>
                    BannerDetailScreen(bannerItem: bannerItem), // 상세 화면으로 이동
          ),
        );
      }
    }
  }

  // 화면에 보여줄 UI를 만드는 함수
  @override
  Widget build(BuildContext context) {
    // 배너 내용을 만드는 함수
    Widget buildBannerContent() {
      if (_isLoading) {
        // 로딩 중일 때
        return SizedBox(
          height: 200, // 높이 200으로 고정
          child: const Center(child: CircularProgressIndicator()), // 로딩 바 보여줌
        );
      } else if (_errorMessage.isNotEmpty) {
        // 오류가 있을 때
        return SizedBox(
          height: 200,
          child: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center, // 가운데 정렬
              children: [
                Text(
                  _errorMessage, // 오류 메시지 보여줌
                  textAlign: TextAlign.center, // 가운데 정렬
                  style: const TextStyle(color: Colors.red), // 빨간색 글자
                ),
                const SizedBox(height: 16), // 아래로 16만큼 간격
                ElevatedButton(
                  onPressed: _loadBanners, // 다시 시도 버튼 클릭 시 배너 다시 로드
                  child: const Text('다시 시도'), // 버튼에 "다시 시도" 텍스트
                ),
              ],
            ),
          ),
        );
      } else if (_bannerItems.isEmpty) {
        // 배너가 없을 때
        return SizedBox(
          height: 200,
          child: const Center(child: Text('표시할 배너가 없습니다.')), // 메시지 보여줌
        );
      } else {
        // 배너가 있을 때
        return CarouselBanner(
          bannerItems: _bannerItems, // 배너 목록 전달
          height: 240, // 높이 200
          onBannerTap: _handleBannerTap, // 배너 클릭 시 실행할 함수 전달
        );
      }
    }

    // 최종적으로 배너 내용을 화면에 보여줌
    // RefreshIndicator는 사용하지 않음 (새로고침 기능 없음)
    return buildBannerContent();
  }
}
