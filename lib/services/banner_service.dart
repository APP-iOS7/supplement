// Flutter 앱에서 Firestore라는 클라우드 데이터베이스를 사용하기 위해 필요한 도구를 가져옴
// Firestore는 구글에서 제공하는 저장소로, 앱에서 데이터를 저장하고 꺼내올 수 있어요
import 'package:cloud_firestore/cloud_firestore.dart';

// 배너 데이터의 설계도(BannerItem 클래스)가 있는 파일을 가져옴
// '../models/banner_item_model.dart'는 프로젝트 폴더에서 'models'라는 폴더에 있는 파일이에요
import '../models/banner_item_model.dart';

// 배너 데이터를 Firestore에서 관리하는 도우미 클래스
// 이 클래스는 데이터를 가져오고 저장하는 일을 담당해요
class BannerService {
  // Firestore 데이터베이스와 연결하는 도구를 준비
  // FirebaseFirestore.instance는 Firestore를 사용하기 위한 기본 열쇠 같은 거예요
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  // Firestore에서 배너 데이터를 저장할 폴더 이름 정하기
  // '컬렉션'은 데이터베이스에서 폴더 같은 개념으로, 여기서는 'banners'라는 이름으로 저장
  final String collectionName = 'banners';

  // 모든 배너 데이터를 한 번에 가져오는 함수
  // Future는 "나중에 데이터를 줄게!"라는 약속이고, List<BannerItem>은 배너 목록을 의미
  Future<List<BannerItem>> getBanners() async {
    // 혹시 오류가 날까봐 안전하게 try-catch로 감싸줌
    try {
      // Firestore에서 'banners'라는 폴더에 있는 데이터를 요청
      // QuerySnapshot은 요청한 데이터를 담은 상자 같은 거예요
      final QuerySnapshot snapshot =
          await _firestore
              .collection(collectionName) // 'banners' 폴더를 열어
              .orderBy(
                'order',
                descending: false,
              ) // 'order'라는 기준으로 정렬 (작은 숫자부터 순서대로)
              // descending: false는 1, 2, 3 순서, true면 3, 2, 1 순서
              .get(); // 데이터를 한 번 가져와! (await는 기다리는 중)

      // 가져온 데이터를 BannerItem으로 바꿔서 리스트로 만듦
      final List<BannerItem> banners =
          snapshot.docs.map((doc) {
            // snapshot.docs는 가져온 데이터 조각(문서)들의 리스트예요
            // doc은 각 문서 하나를 의미
            final data = doc.data() as Map<String, dynamic>;
            // doc.data()는 문서 안에 있는 데이터를 꺼내줌
            // Map<String, dynamic>은 "키: 값" 형태 (예: "title": "첫 번째 배너")
            return BannerItem.fromJson(
              data,
            ); // BannerItem.fromJson은 데이터를 BannerItem이라는 형태로 바꿔줌
            // BannerItem은 배너의 이미지, 제목, 설명 등을 담는 설계도
          }).toList(); // 변환한 걸 리스트로 만들어줌

      return banners; // 배너 리스트를 돌려줌
    } catch (e) {
      // 데이터 가져오다가 문제가 생기면 콘솔에 오류 메시지 출력
      print('Error fetching banners: $e');
      // 오류가 나도 앱이 꺼지지 않게 빈 리스트를 돌려줌
      return [];
    }
  }

  // 배너 데이터를 실시간으로 계속 감시하면서 가져오는 함수
  // Stream은 "데이터가 바뀔 때마다 계속 알려줄게!"라는 흐름 같은 거예요
  Stream<List<BannerItem>> getBannersStream() {
    return _firestore
        .collection(collectionName) // 'banners' 폴더를 열어
        .orderBy('order', descending: false) // 'order' 기준으로 정렬
        .snapshots() // 실시간으로 데이터를 감시 (데이터가 바뀌면 바로 알려줌)
        .map((snapshot) {
          // snapshots()가 주는 스냅샷(현재 데이터 상태)을 받아서 처리
          return snapshot.docs.map((doc) {
            // 스냅샷 안의 각 문서를 하나씩 꺼냄
            final data = doc.data(); // 문서 데이터를 꺼냄 (Map 형태로 되어 있음)
            return BannerItem.fromJson(data); // 데이터를 BannerItem으로 바꿔줌
          }).toList(); // 변환된 BannerItem들을 리스트로 만듦
        }); // 실시간으로 배너 리스트를 돌려줌
    // 이걸 UI에서 사용하면 데이터가 바뀔 때마다 화면이 자동으로 갱신돼요
  }

  // 특정 배너 하나만 ID로 찾아서 가져오는 함수
  // bannerId는 찾고 싶은 배너의 고유 번호예요 (Firestore에서 문서 ID로 사용)
  Future<BannerItem?> getBanner(String bannerId) async {
    try {
      // Firestore에서 특정 배너 데이터를 가져옴
      final DocumentSnapshot doc =
          await _firestore
              .collection(collectionName) // 'banners' 폴더로 이동
              .doc(bannerId) // bannerId라는 이름의 문서를 찾아
              .get(); // 그 문서 데이터를 가져와! (await로 기다림)

      // 문서가 있는지 확인
      if (doc.exists) {
        // 문서가 있으면 데이터를 BannerItem으로 바꿔줌
        return BannerItem.fromJson(doc.data() as Map<String, dynamic>);
        // doc.data()는 Map 형태로 데이터를 주고, 이를 BannerItem으로 변환
      } else {
        return null; // 문서가 없으면 null을 돌려줌 (배너가 없다는 뜻)
      }
    } catch (e) {
      // 데이터 가져오다가 오류가 나면 콘솔에 출력
      print('Error fetching banner details: $e');
      // 오류가 나도 앱이 멈추지 않게 null을 돌려줌
      return null;
    }
  }
}
