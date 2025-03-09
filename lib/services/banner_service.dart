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

  // 샘플 배너 데이터를 만드는 함수 (앱 처음 실행할 때 테스트용으로 사용)
  //   Future<void> createSampleBanners() async {
  //     try {
  //       // 샘플 배너 3개를 만들어서 Firestore에 저장할 준비
  //       final samples = [
  //         BannerItem(
  //           id: 'banner1',
  //           imageUrl:
  //               'https://raw.githubusercontent.com/iampeel/fire030701storage/main/banner_magazine_image01_Biotin.png',
  //           title: '비오틴, 탈모에 진짜 효과 있나요?',
  //           description: '''
  // <h1>비오틴, 탈모에 진짜 효과 있나요?</h1>
  // <p>탈모는 유전 탓 아니라 남성호르몬 분비, 스트레스, 과도한 다이어트, 질환 등 다양한 원인으로 발생할 수 있어요.</p>
  // <p>그중 <strong>생활습관이나 스트레스 등으로 나타나는 탈모의 경우에는 모발 성장, 건강을 위한 영양제 섭취가 도움이 될 수 있어요!</strong></p>
  // <p>비오틴은 세포가 에너지를 만드는데 도움을 주고, 머리카락, 손톱, 피부를 건강하게 유지하는 케라틴, 콜라겐형성에 필요한 '항'을 가지고 있어서 탈모에 도움을 줄 수 있어요.</p>
  // <p>특히 흡연, 음주를 하거나 과도한 다이어트를 하는 경우, 항생제를 먹거나 장 질환이 있는 등 비오틴이 체내에 부족해진 분들이 드실 때 더 효과를 볼 수 있어요.</p>

  // <h2>비오틴 최적섭취량, 먹는 시간</h2>
  // <p>비오틴의 최적섭취량은 <strong>하루 50μg 이상</strong>이에요.</p>
  // <p>비오틴은 공복에 드시는 것이 흡수율을 높일 수 있어 <strong>식전 1시간 또는 식후 2시간</strong>에 드시는 것이 좋고,</p>
  // <p>세포 생성이 활발한 <strong>수면 시간에 맞춰 자기 전 복용</strong>하시는 것도 좋아요.</p>

  // <h2>비오틴 부작용</h2>
  // <p>효과가 잘 느껴지지 않아 <strong>고용량을 복용하는 경우, 여드름, 알레르기 등 부작용이 생길 수 있어요.</strong></p>
  // <p>또한 갑상선이나 심장 질환 검사에서 진단 검사에 오류가 생길 수 있으니 주의하셔야 해요.</p>

  // <h2>직접 먹어본 사람들이 뽑은 비오틴 영양제 TOP3 인기 제품 비교!</h2>
  // <div style="overflow-x: auto; width: 100%;">
  //   <table border="1" cellpadding="5" cellspacing="0" style="width:100%">
  //     <tr style="background-color:#f4f6fa">
  //       <th>제품명</th>
  //       <th>성분 함량(1일 섭취량 기준)</th>
  //       <th>가격 (온라인 구매가 기준)</th>
  //       <th>NutriPick 평점</th>
  //     </tr>
  //     <tr>
  //       <td>나우푸드 비오틴 5000mcg</td>
  //       <td><span style="color:#00c7c7">비오틴 - 5000μg</span></td>
  //       <td>₩10,409<br>(120정)</td>
  //       <td>⭐️ 4.5</td>
  //     </tr>
  //     <tr>
  //       <td>나트롤 비오틴 10000mcg</td>
  //       <td><span style="color:#00c7c7">비오틴 - 10000μg</span><br><span style="color:#ff69b4">칼슘 - 66mg</span></td>
  //       <td>₩29,579<br>(200정)</td>
  //       <td>⭐️ 4.61</td>
  //     </tr>
  //     <tr>
  //       <td>부가 비오틴 5000mcg</td>
  //       <td><span style="color:#00c7c7">비오틴 - 5000μg</span><br><span style="color:#ff69b4">칼슘 - 148mg</span></td>
  //       <td>₩27,068<br>(100정)</td>
  //       <td>⭐️ 4.53</td>
  //     </tr>
  //   </table>
  // </div>

  // <h2>나우푸드 비오틴 5000mcg</h2>
  // <img src="https://raw.githubusercontent.com/iampeel/fire030701storage/main/banner_magazine_image01_Biotin01.png" alt="나우푸드 비오틴" style="width:100%; max-width:300px; display:block; margin:10px auto;">
  // <p>나우푸드에서 만든 캡슐형 비오틴 제품으로, 식물성 캡슐을 사용한 비건 제품이에요.</p>
  // <p>캡슐당 5000μg이 들어있고 제조사에서는 따로 정해진 시간 없이 <strong>하루에 1회, 1개씩 섭취</strong>하는 것을 권장하고 있어요.</p>
  // <p>해외 직구로 구매할 수 있는 제품으로, 가성비가 좋은 편이라 많은 분들이 선호하는 제품이에요.</p>
  // <p>나우푸드 비오틴 5000mcg 제품을 섭취한 분들은 대표적인 효과로 <strong>탈모 개선, 피부 탄력 개선, 피로 개선</strong>을 꼽았어요.</p>
  // <p><strong>머리카락이 빠지는 양이 눈에 띄게 줄고 모발 성장에도 효과가 좋았다</strong>는 후기가 많았고, <strong>무미무취의 캡슐</strong>이라 섭취하기 편했다는 후기도 있었어요.</p>

  // <h2>나트롤 비오틴 10000mcg</h2>
  // <img src="https://raw.githubusercontent.com/iampeel/fire030701storage/main/banner_magazine_image01_Biotin02.png" alt="나트롤 비오틴" style="width:100%; max-width:300px; display:block; margin:10px auto;">
  // <p>나트롤 비오틴 10000mcg는 <strong>타블렛당 함량을 10000mcg까지 높인 고함량의 제품</strong>이에요.</p>
  // <p>높은 함량 대비 <strong>가성비가 좋은 제품</strong>으로 많은 분들이 선호하는 제품이에요!</p>
  // <p>비오틴 외에도 칼슘이 함께 들어있는데, 하루 섭취량에는 다소 부족한 양이므로 다른 영양제로 보충해주시는 것이 좋아요.</p>
  // <p>제조사에서는 <strong>하루 1회 1정씩, 저녁 식후</strong>에 섭취할 것을 권장하고 있어요.</p>
  // <p>나트롤의 다른 비오틴 제품 중에는 딸기맛이라 거부감없이 섭취하기 좋은 제품도 있고, 잘 녹는 형태로 나온 제품도 있어서 물 없이도 쉽게 섭취할 수 있어요.</p>
  // <p><strong>캡슐형 제품을 먹으면 속이 불편함을 느끼셨던 분들이라면 섭취하기 좋은 형태예요!</strong></p>

  // <h2>부가 비오틴 5000mcg</h2>
  // <img src="https://raw.githubusercontent.com/iampeel/fire030701storage/main/banner_magazine_image01_Biotin03.png" alt="부가 비오틴" style="width:100%; max-width:300px; display:block; margin:10px auto;">
  // <p>브랜드 평판이 좋은 부가에서 제조한 캡슐형 비오틴 제품으로 <strong>캡슐당 5000mcg</strong>이 들어있어요.</p>
  // <p>비오틴 외에도 칼슘이 함께 들어있는데, 하루 섭취량에는 다소 부족한 양이므로 다른 영양제로 보충해주시는 것이 좋아요.</p>
  // <p><strong>GMO 미사용 제품이고, 글루텐, 밀, 유제품이 포함되지 않은 비건 지향 제품</strong>이에요.</p>
  // <p>제조사에서는 하루 1회 1캡슐씩, 저녁 식후에 섭취할 것을 권장하고 있어요.</p>
  // ''',
  //           order: 1,
  //           isActive: true,
  //         ),
  //         BannerItem(
  //           id: 'banner2',
  //           imageUrl:
  //               'https://raw.githubusercontent.com/iampeel/fire030701storage/main/banner_magazine_image02_Milkthistle.png',
  //           title: '밀크씨슬 대표 인기 브랜드 TOP4 비교 총 정리!',
  //           description: '''<h1>밀크씨슬 대표 인기 브랜드 TOP4 비교 총 정리!</h1>
  // <p>가장 많은 분들이 찾아본 밀크씨슬 인기 제품 4개를 꼼꼼히 비교해 드릴게요!</p>
  // <p>다른 곳에서는 쉽게 찾기 힘든 '직접 먹어본 후기'까지 한 눈에 확인하고 비교해보세요. 👀</p>

  // <div style="overflow-x: auto; width: 100%;">
  //   <table border="1" cellpadding="5" cellspacing="0" style="width:100%; table-layout: fixed;">
  //     <tr style="background-color:#f4f6fa">
  //       <th style="width: 20%; word-wrap: break-word; text-align: left;">제품명</th>
  //       <th style="width: 40%; word-wrap: break-word; text-align: left;">성분 함량 (1일 섭취량 기준)</th>
  //       <th style="width: 20%; word-wrap: break-word; text-align: left;">가격 (온라인 최저가 기준)</th>
  //       <th style="width: 20%; word-wrap: break-word; text-align: left;">섭취시간/섭취량</th>
  //     </tr>
  //     <tr>
  //       <td style="word-wrap: break-word; text-align: left;">지에넴 건강한 간 밀크씨슬</td>
  //       <td style="word-wrap: break-word; text-align: left;">실리마린밀크씨슬 130mg<br>비타민B1 1.1mg<br>비타민B2 1.2mg<br>비타민B6 1.4mg<br>나이아신(B3) 13.5mg NE<br>판토텐산(B5) 4.6mg</td>
  //       <td style="word-wrap: break-word; text-align: left;"><strong>₩19,870</strong><br>(180정)</td>
  //       <td style="word-wrap: break-word; text-align: left;">1일 1회<br>1회당 1정</td>
  //     </tr>
  //     <tr>
  //       <td style="word-wrap: break-word; text-align: left;">나우푸드 실리마린 밀크씨슬 익스트렉스</td>
  //       <td style="word-wrap: break-word; text-align: left;">실리마린(밀크씨슬) 240mg<br>커큐민 700mg</td>
  //       <td style="word-wrap: break-word; text-align: left;"><strong>₩11,781</strong><br>(120정)</td>
  //       <td style="word-wrap: break-word; text-align: left;">1일 1-3회<br>1회당 2정</td>
  //     </tr>
  //     <tr>
  //       <td style="word-wrap: break-word; text-align: left;">쏜리서치 SAT</td>
  //       <td style="word-wrap: break-word; text-align: left;">실리빈(밀크씨슬) 300mg<br>아티초크추출물 300mg<br>커큐민 300mg</td>
  //       <td style="word-wrap: break-word; text-align: left;"><strong>₩49,052</strong><br>(60정)</td>
  //       <td style="word-wrap: break-word; text-align: left;">1일 2-3회<br>(아침,저녁 식후)<br>1회당 1캡슐</td>
  //     </tr>
  //     <tr>
  //       <td style="word-wrap: break-word; text-align: left;">캘리포니아골드뉴트리션 실리마린 컴플렉스</td>
  //       <td style="word-wrap: break-word; text-align: left;">실리마린(밀크씨슬) 240mg<br>엉겅퀴추출물 100mg<br>아티초크추출물 50mg</td>
  //       <td style="word-wrap: break-word; text-align: left;"><strong>₩19,076</strong><br>(120정)</td>
  //       <td style="word-wrap: break-word; text-align: left;">1일 1회<br>1회당 1캡슐</td>
  //     </tr>
  //   </table>
  // </div>

  // <h2>지에넴(GNM) 건강한 간 밀크씨슬</h2>
  // <p>지에넴 건강한 간 밀크씨슬은 실리마린 성분이 1일 섭취량인 <strong>1정 기준으로 130mg</strong> 들어있는 타블렛 형태의 제품이에요.</p>
  // <p>실리마린 외 비타민B1, B2, B6, 나이아신, 판토텐산도 포함되어 있지만, 1일 권장량 이하로 들어있어 다른 영양제로 보충이 필요해요.</p>

  // <p>제조사에서 권장하는 섭취량은 <strong>하루에 1회, 1회당 1정</strong>이에요.</p>
  // <p>지에넴 밀크씨슬 제품은 <strong>PTP 개별 포장 형태라 위생적으로 보관</strong>할 수 있다는 장점이 있어요.</p>
  // <p>알약 제형을 만들기 위해 부형제(이산화규소, 스테아린산마그네슘)가 첨가되어있고 중국산 원료가 일부 들어있으니, 제품 구매 전 확인해보시면 좋을 것 같네요!</p>

  // <h2>나우푸드 실리마린 밀크씨슬 익스트렉스 150mg (NOW Foods, Silymarin with Turmeric, 150 mg)</h2>
  // <p>나우푸드 실리마린 밀크씨슬 익스트렉스 제품은 <strong>1일 최소섭취량인 2캡슐을 기준으로 밀크씨슬이 240mg</strong> 함유되어 있어요.</p>
  // <p>밀크씨슬 외에도 <strong>항산화 효과가 있어 간 세포 손상을 막아주는 커큐민</strong>이 700mg으로 꽤 많은 함량이 들어있어요.</p>
  // <p>다만 커큐민은 흡수율이 낮기 때문에 어떤 원료를 사용했는지가 중요한 편인데, 원료에 대한 정보는 확인되지 않았아요.</p>

  // <p>제조사에서는 <strong>하루 최소 1회 - 최대 3회까지, 2캡슐</strong>씩 섭취할 것을 추천하고 있어요!</p>
  // <p>처음에는 최소량만 섭취해보시고 2주 정도 섭취해도 눈에 띄는 부작용이 없다면, 최대량까지 섭취량을 늘려보시는 것이 좋아요!</p>

  // <h2>쏜리서치 SAT (Thorne Research, SAT)</h2>
  // <p>쏜리서치 SAT 제품은 제품에 함유된 '실리마린, 아티초크, 터메릭(강황추출물/커큐민)'의 앞글자를 딴 제품으로, 간 기능에 도움이 되는 성분들이 들어있고, 유명한 브랜드인 Indena사의 원료를 사용해 인기가 많은 밀크씨슬 영양제예요.</p>

  // <p>1일 최소섭취량 2캡슐을 기준으로 <strong>'실리빈 파이토썸'이 300mg 함유되어 있어 다른 제품에 비해 함량이 높은 제품</strong>입니다.</p>
  // <p>밀크씨슬 추출물을 비교하기 위한 지표성분인 <strong>실리마린</strong>중에서도 특히 효능이 높은 성분이 바로 '<strong>실리빈</strong>'이에요.</p>
  // <p>이 실리빈의 함량이 높을 뿐만 아니라 흡수율을 높이기 위한 특수 공법인 '파이토썸' 형태로 만들어 효과를 높였어요.</p>

  // <p>또한 <b>담즙</b> 분비를 촉진해 소화에 도움을 주고 간 세포 손상을 막아주는 '아티초크추출물'과 항산화 작용으로 간 세포 손상을 막아주는 '커큐민'</strong>이 함께 포함되어 있어요.</p>
  // <p>커큐민은 흡수율이 낮은 편이라 각 원료사마다 흡수율을 높이기 위한 여러가지 기술을 적용하고 있는데요.</p>
  // <p>이 제품에서는 유명한 커큐민 원료인 '메리바®'를 사용했고, 실리빈과 마찬가지로 '파이토썸' 공법을 사용했어요!</p>
  // <p>제조사에서는 <b>아침, 저녁 식후에 하루 최소 2회 - 최대 3회까지 1캡슐</b>씩 섭취할 것을 추천하고 있어요.</p>
  // <p>처음에는 최소량만 섭취해보시고 2주 정도 섭취해도 눈에 띄는 부작용이 없다면, 최대량까지 섭취량을 늘려보시는 것이 좋아요!</p>

  // <p>쏜리서치 SAT 제품을 섭취한 분들은 대표적인 효과로 '피로 개선', '숙취 감소', '간 수치 개선'을 꼽았어요.</p>
  // <p>이 제품을 섭취했을때 <b>피로 회복이나 숙취 해소, 건강 검진에서 간 수치 개선</b>에 확실히 효과를 봤다는 후기가 많은 것을 볼 수 있었어요!</p>
  // <p>다만 <b>하루에 최대 3번까지 나눠서 섭취하는 제품이라 번거롭다</b>는 후기가 있었고, <b>해외 직구 제품이라 가격대가 높다</b>는 후기도 있었으니 참고하세요.</p>

  // <h2>캘리포니아골드뉴트리션 실리마린 컴플렉스 (California Gold Nutrition, Silymarin Complex)</h2>
  // <p>캘리포니아골드뉴트리션 실리마린 컴플렉스 제품은 <b>밀크씨슬이 1일 섭취량인 1캡슐 기준 240mg</b>이 포함된 캡슐형 제품입니다.</p>
  // <p>제조사에서는 <b>하루 1회 1캡슐</b>씩 섭취할 것을 추천하고 있어요.</p>

  // <p>이 제품에도 간 기능에 도움이 되는 성분인 엉겅퀴, 아티초크, 커큐민 등이 들어있지만 각각의 함량은 다소 적은 편이에요.</p>
  // <p>특히 <b>항산화 작용</b>으로 간 세포 손상을 막아주는 <b>커큐민</b>은 유명한 원료사인 'C3컴플렉스®'를 사용했지만 함량이 적어 큰 효과를 기대하기는 어려울 수 있어요.</p>

  // <p>캘리포니아골드뉴트리션 실리마린 컴플렉스 제품을 섭취한 분들은 대표적인 효과로 '피로 개선', '숙취 감소', '간 수치 개선'을 꼽았어요.</p>
  // <p><b>가격이 저렴해서 가성비가 좋다는 후기</b>가 있었고, <b>실리마린 함량이 높고 알약 크기가 많이 크지 않아 복용이 편하다</b>는 후기도 있었네요.</p>
  // <p><b>향이 조금 거부감</b>이 든다는 후기가 있었으나 그 외에 큰 부작용, 단점에 대한 후기는 많지 않은 편이었으니, 제품을 고르실 때 참고해보세요!</p>
  // ''',
  //           order: 2,
  //           isActive: true,
  //         ),
  //         BannerItem(
  //           id: 'banner3',
  //           imageUrl:
  //               'https://raw.githubusercontent.com/iampeel/fire030701storage/main/banner_magazine_image03_Bmax.png',
  //           title: '비맥스 메타, 비맥스 메타비, 비맥스 액티브 한 눈에 비교해 드립니다! 🔍',
  //           description: '''<h1>비맥스 메타, 비맥스 메타비, 비맥스 액티브 한 눈에 비교해 드립니다! 🔍</h1>
  // <p>활성비타민B군을 사용해 피로회복에 효과적인 종합비타민 제품들을 비교해 드릴게요.</p>

  // <div style="overflow-x: auto; width: 100%;">
  //   <table border="1" cellpadding="5" cellspacing="0" style="width:100%; table-layout: fixed;">
  //     <tr style="background-color:#f4f6fa">
  //       <th style="width: 20%; word-wrap: break-word; text-align: left;"></th>
  //       <th style="width: 26%; word-wrap: break-word; text-align: left;">비맥스 메타</th>
  //       <th style="width: 27%; word-wrap: break-word; text-align: left;">비맥스 메타비</th>
  //       <th style="width: 27%; word-wrap: break-word; text-align: left;">비맥스 액티브</th>
  //     </tr>
  //     <tr>
  //       <td style="word-wrap: break-word; text-align: left;"><strong>성분 함량 (1일 섭취량 기준)</strong></td>
  //       <td style="word-wrap: break-word; text-align: left;">비타민B1 100mg<br>벤포티아민 95mg<br>비스벤티아민 5mg<br>비타민B2 100mg<br>나이아신아마이드(B3) 10mg NE<br>판토텐산(B5) 100mg<br>피리독신염산염(B6) 100mg<br>비오틴 100μg<br>엽산 400μg<br>시아노코발라민(B12) 500μg<br>비타민D3 25μg<br>셀레늄(셀렌) 21.6μg<br>아연 24mg<br>ㆍ산화아연 30mg<br>UDCA 30mg<br>마그네슘 60mg<br>ㆍ산화마그네슘 100mg<br>콜린타르타르산 100mg<br>이노시톨 100mg</td>
  //       <td style="word-wrap: break-word; text-align: left;">비타민B1 130mg<br>ㆍ벤포티아민 100mg<br>ㆍ비스벤티아민 30mg<br>비타민B2 100mg<br>나이아신아마이드(B3) 10mg NE<br>판토텐산(B5) 100mg<br>비타민B6 100mg<br>비오틴 100μg<br>엽산 500μg<br>하이드록소코발라민(B12) 1000μg<br>비타민D3 25μg<br>셀레늄(셀렌) 21.6μg<br>L-시스테인 25mg<br>아연 30mg<br>ㆍ산화아연 37.4mg<br>UDCA 30mg<br>마그네슘 60mg<br>ㆍ산화마그네슘 100mg<br>콜린타르타르산 100mg<br>이노시톨 100mg</td>
  //       <td style="word-wrap: break-word; text-align: left;">비타민B1 50mg<br>ㆍ벤포티아민 50mg<br>비타민B2 50mg<br>ㆍ비타민B2 45mg<br>ㆍ리보플라빈부티레이트 5mg<br>나이아신아마이드(B3) 50mg NE<br>판토텐산(B5) 50mg<br>비타민B6 50mg<br>ㆍ피리독신염산염 45mg<br>ㆍ피리독살포스페이트 5mg<br>비오틴 50μg<br>엽산 250μg<br>하이드록소코발라민(B12) 50μg<br>비타민C 50mg<br>비타민D3 25μg<br>셀레늄(셀렌) 10.8μg<br>비타민E(토코페롤아세테이트) 10mg α-TE<br>아연 30mg<br>ㆍ산화아연 37.4mg<br>UDCA 15mg<br>마그네슘 60mg<br>ㆍ산화마그네슘 100mg<br>콜린타르타르산 50mg<br>이노시톨 50mg<br>감마오리자놀 3mg</td>
  //     </tr>
  //     <tr>
  //       <td style="word-wrap: break-word; text-align: left;"><strong>가격 (*대략적인 구매가로, 정확한 금액은 약국에서 확인하세요)</strong></td>
  //       <td style="word-wrap: break-word; text-align: left;"><strong>₩60,000~</strong><br>(120정)</td>
  //       <td style="word-wrap: break-word; text-align: left;"><strong>₩60,000~</strong><br>(120정)</td>
  //       <td style="word-wrap: break-word; text-align: left;"><strong>₩50,000~</strong><br>(120정)</td>
  //     </tr>
  //     <tr>
  //       <td style="word-wrap: break-word; text-align: left;"><strong>NutriPick 평점</strong></td>
  //       <td style="word-wrap: break-word; text-align: left;">⭐️ 4.61</td>
  //       <td style="word-wrap: break-word; text-align: left;">⭐️ 4.57</td>
  //       <td style="word-wrap: break-word; text-align: left;">⭐️ 4.6</td>
  //     </tr>
  //     <tr>
  //       <td style="word-wrap: break-word; text-align: left;"><strong>추천하는 분</strong></td>
  //       <td style="word-wrap: break-word; text-align: left;">- 표준 체중의 30~50대 남성</td>
  //       <td style="word-wrap: break-word; text-align: left;">- 활동량이 많고, 피로감이 매우 높은 30~50대<br>- 특히 두뇌활동량이 많은 분<br>- 체중이 많이 나가는 편인 분<br>- 채식을 주로 하는 분<br>- 당뇨약을 복용 중이신 분<br>- 신경통이 있는 분</td>
  //       <td style="word-wrap: break-word; text-align: left;">- 체중이 표준이거나 조금 적은 편인 여성<br>- 체격이 크지 않은 청소년<br>- 고함량 비타민을 드시고 속이 불편했던 경험이 있는 분</td>
  //     </tr>
  //   </table>
  // </div>

  // <p>*굵은 글씨의 영양성분은 다른 제품에 비해 성분 함량이 높거나 추가된 성분이에요.</p>
  // <p>*비맥스 제품의 가격은 판매 약국마다 상이하니, 정확한 가격은 약국을 방문해 확인하세요!</p>

  // <h2>비맥스 메타</h2>
  // <p>비맥스 메타는 <strong>고함량 활성비타민B군</strong>을 사용해 피로회복에 효과적인 종합비타민 제품이에요.</p>
  // <p>비교 제품에 비해 다양한 종류의 영양소가 들어있지는 않지만, <strong>비타민B군 8종과 함께 비타민D와 아연</strong> 등 꼭 필요한 영양소는 충분히 섭취할 수 있어요.</p>

  // <h3>💊 비맥스 메타의 효과/효능</h3>
  // <p>비맥스 메타에는 <strong>비타민B1이 활성화 비타민 형태로 들어있어요</strong>.</p>
  // <p>비타민B1은 특히 흡수율이 낮은 편이기 때문에 활성형태로 드시는 것이 좋은데 비맥스 메타에는 활성형태인 '<strong>벤포티아민</strong>'과 '<strong>비스벤티아민</strong>'을 사용했어요.</p>
  // <p>벤포티아민은 여러 형태 중에서도 <strong>흡수가 잘 되고 혈액 피로 개선</strong>에 좋은 활성비타민 형태예요.</p>
  // <p>벤포티아민은 담낭관장벽을 통과하기 어렵다는 단점이 있는데, 비스벤티아민은 담세포벽을 통과해 <strong>두뇌 피로 개선에 도움을 줄 수 있고 흡수율을 더욱 높인 형태</strong>예요.</p>

  // <p>간 건강에 도움을 주는 UDCA도 30mg 들어있어 <strong>간 노폐물 배출을 도와 피로 회복에도 더 효과적</strong>이에요.</p>

  // <h3>👍🏻 비맥스 메타, 이런 분에게 추천해요!</h3>
  // <p><strong>표준 체중의 30~50대 남성이 드시기에 적당해요.</strong></p>
  // <p>평소 <strong>식사를 균형롭게 잘 챙겨 드시지 못하고 피로감을 많이 느끼는 분</strong>에게 추천해요.</p>

  // <h3>⚠️ 비맥스 메타의 부작용</h3>
  // <ul>
  //   <li><strong>남성 흡연자 주의 - 비타민B6 / 비타민B12</strong></li>
  // </ul>
  // <p><a href="https://pubmed.ncbi.nlm.nih.gov/28829668/">남성 흡연자가 비타민B6, B12 보충제를 고함량으로 복용했을때 폐암 위험이 높아진다는 연구 결과</a>가 있어요.</p>
  // <p><strong>이 제품에는 비타민B6는 100mg, B12는 500μg이 들어있어 함량이 높은 편이므로 장기간 섭취하시는 것은 주의하시는 게 좋아요.</strong></p>

  // <h2>비맥스 메타비</h2>
  // <p>비맥스 메타비 역시 <strong>고함량의 비타민B군</strong>이 들어있는 종합비타민 제품이에요.</p>
  // <p>비맥스 메타의 업그레이드 버전으로 볼 수 있는데, 추가되거나 함량을 더 높인 성분들이 있어요.</p>

  // <h3>💊비맥스 메타비의 효과/효능</h3>
  // <p>비맥스 메타비 역시 비타민B1이 활성형태로 들어있어요.</p>
  // <p>메타와 비교해보면 <strong>벤포티아민 </strong>함량은 비슷한 수준이지만, <strong>비스벤티아민</strong> 함량을 많이 높였어요.</p>
  // <p>따라서 <strong>두뇌활동으로 인한 피로감을 개선하는 효과</strong>를 좀 더 기대해볼 수 있어요.</p>

  // <p>비타민B12는 시아노코발라민보다 효과가 나타나는 시간이 좀 더 빠르고, 지속 시간이 긴 형태인 <strong>하이드록소코발라민</strong>이 들어있어요.</p>
  // <p>함량은 <strong>1000μg</strong>으로 다른 제품에 비해 <strong>굉장히 높은 편</strong>이에요!</p>

  // <p>비맥스 메타에 비해 <strong>엽산</strong>과 <strong>아연</strong>의 함량도 조금 더 높아요.</p>
  // <p>또한 비맥스 메타와 달리 L-시스테인이 들어있는데, L-시스테인은 아미노산의 한 종류로 <strong>에너지를 생성하는데 도움</strong>을 줄 수 있어요.</p>

  // <h3>👍🏻비맥스 메타비, 이런 분에게 추천해요!</h3>
  // <p>피로 회복에 도움을 주는 성분이 <strong>고함량</strong>으로 들어있어 <strong>활동량이 많고 극심한 피로를 느끼는 분, 특히 두뇌활동이 많이 필요한 분께 추천해요.</strong></p>
  // <p>대부분의 성분이 고함량으로 포함되어 있기 때문에 <strong>체중이 많이 나가는 편인 분이 드시기에도 좋아요.</strong></p>

  // <p>특히 비타민B12가 1000μg으로 고함량 들어있어 <strong>채식을 주로 하시는 분들에게도 추천해요</strong>.</p>
  // <p>비타민B12는 주로 동물성 식품에 들어있기 때문에 채식을 하는 경우에는 따로 보충이 필요한 영양소예요.</p>

  // <p><strong>당뇨약을 복용하고 계신 분에게도 추천해요.</strong></p>
  // <p>당뇨약 중 '메트포르민'이라는 성분을 복용하는 경우에는 비타민B12의 흡수가 잘 안되기 때문에 부족해질 수 있어 영양제로 보충하시는 것을 추천해요.</p>

  // <p>비타민B12가 부족하면 손발이 저리고, 어깨나 허리 같은 곳이 아플 수 있기 때문에, <strong>신경통이 있는 분</strong>들에게도 도움이 될 수 있어요.</p>

  // <h3>⚠️비맥스 메타비의 부작용</h3>
  // <ul>
  //   <li><strong>속쓰림, 위림거림 등의 위장장애</strong></li>
  // </ul>
  // <p>대부분의 성분들이 매우 고함량으로 포함되어 있기 때문에 섭취 후 속이 불편할 수 있어요.</p>
  // <p>이런 증상을 예방하려면 <strong>식사 직후에, 따뜻한 물을 충분히 드시면서 섭취하는 것</strong>이 도움 돼요.</p>
  // <p>그래도 속이 불편한 증상이 이어진다면 섭취를 중단하고, 함량이 조금 낮은 제품을 선택하시는 걸 추천해요.</p>

  // <ul>
  //   <li><strong>피부트러블 주의 - 비타민B12</strong></li>
  // </ul>
  // <p>비타민B12는 수용성이기 때문에 소변으로 잘 배출되는 성질이 있어 건강한 사람에서는 고함량 섭취해도 심각한 이상반응이 보고된 사례는 없었고, 그 때문에 상한섭취량도 정해져 있지 않아요.</p>
  // <p>그렇네 혹시 알게 <strong>비타민B12 고함량을 오래 섭취하는 경우, 얼굴이나 몸에 여드름과 유사한 발진이 생길 수 있다는</strong> <a href="https://pubmed.ncbi.nlm.nih.gov/28594082/"><strong>보고</strong></a>가 있어요.</p>
  // <p>따라서 섭취 후 피부트러블이 생겼다면 함께 복용 중인 다른 영양제에 비타민B12가 없는지 확인하고, 잠시 섭취를 중단해보세요.</p>
  // <p>일반적으로 영양제로 인한 부작용이라면 섭취를 그만두고 몇 주 또는 몇 개월 안에 회복이 돼요.</p>

  // <ul>
  //   <li><strong>남성 흡연자 주의 - 비타민B6 / 비타민B12</strong></li>
  // </ul>
  // <p>이 제품에도 <strong>비타민B6는 100mg, B12는 1000μg</strong>이 들어있기 때문에 남성 흡연자의 경우 장기간 섭취하는 것은 주의하시는 게 좋아요.</p>

  // <h2>비맥스 액티브</h2>
  // <p>비맥스 액티브 역시 활성비타민을 사용한 제품으로, 앞서 얘기한 제품들보다는 함량이 낮은 편이지만 비타민B1 이외의 성분들에도 활성형을 조금씩 더 첨가했어요.</p>
  // <p><strong>영양소별 함량 차이의 폭이 작아 균형롭게 섭취하기에 적절한 제품이에요.</strong></p>

  // <h3>💊 비맥스 액티브의 효능/효과</h3>
  // <p><strong>비타민B1</strong>은 <strong>벤포티아민</strong> 한 가지 활성 형태로 들어있어요.</p>
  // <p><strong>비타민B12</strong>는 메타비와 마찬가지로 <strong>하이드록소코발라민</strong>이 들어있는데, 함량은 훨씬 적어요.</p>
  // <p><strong>비타민B2</strong>, <strong>B6</strong>에도 활성 형태인 <strong>리보플라빈, 피리독살포스페이트</strong>를 추가해 흡수율을 높였어요.</p>
  // <p>나이아신아마이드라고도 불리는 <strong>비타민B3</strong>가 위의 제품들에 비해 많이 들어있는데, 비타민B3는 우리 몸의 에너지 생성을 돕고 모세혈관을 넓혀 혈액순환이 좋아지게 해줘요.</p>

  // <p>또, 위의 제품들과 달리 <strong>비타민C와 비타민E</strong>가 들어있어요.</p>
  // <p>비타민C는 <strong>면역력, 피로 개선에 효과적</strong>이지만 최적의 효과를 보기에는 다소 부족한 양이 들어있어 다른 영양제로 보충해주시는 것이 좋아요.</p>

  // <p>비타민E는 항산화에 도움이 되는 영양소로, <strong>10mg이 들어있어 하루에 필요한 최소량</strong>은 충족할 수 있어요.</p>

  // <p>또한 <strong>숙면과 저혈압 개선</strong>에 도움이 되는 감마오리자놀이 추가로 들어있어요. 다만 최적섭취량에 비해서는 부족한 양이 들어있어요.</p>

  // <h3>👍🏻 비맥스 액티브, 이런 분에게 추천해요!</h3>
  // <p><strong>체중이 표준이거나 조금 적은 편인 여성</strong>이나 <strong>체격이 크지 않은 청소년</strong>이 섭취하기에 적당해요.</p>
  // <p>또, 초고함량 비타민을 드시고 속이 불편했던 경험이 있는 분이 드시기에도 좋아요.</p>

  // <h3>⚠️비맥스 액티브의 부작용</h3>
  // <ul>
  //   <li><strong>생리가 예정보다 빨라지거나 많아지거나, 혈압 응고에 문제가 있는 환자 주의 - 비타민E</strong></li>
  // </ul>
  // <p>이 제품에는 비타민E가 포함되어 있어, 위와 같은 주의 문구가 표시되어 있어요.</p>
  // <p>하지만 비타민E 하루 권장량에 비해 그리 높지 않은 용량이기 때문에 너무 걱정하지 않아도 괜찮아요.</p>
  // <p>만약 이런 증상이 나타난다면 섭취를 중단하고 전문가와 상의하세요.</p>

  // <ul>
  //   <li><strong>남성 흡연자 주의 - 비타민B6</strong></li>
  // </ul>
  // <p>이 제품에도 <strong>비타민B6가 50mg</strong> 들어있기 때문에 남성 흡연자는 주의하시는 게 좋아요.</p>
  // ''',
  //           order: 3,
  //           isActive: true,
  //         ),
  //         BannerItem(
  //           id: 'banner4',
  //           imageUrl:
  //               'https://raw.githubusercontent.com/iampeel/fire030701storage/main/banner_magazine_image04_vitamin.png',
  //           title: '활력 충전! 액상형 종합비타민 4종 비교해 드려요! 💪',
  //           description: '''<h1>활력 충전! 액상형 종합비타민 4종 비교해 드려요! 💪</h1>
  // <p>액상형 종합비타민 제품들을 비교해 드릴게요. 흡수가 빠른 액상형으로 더 효과적인 비타민 보충이 가능해요!</p>

  // <div style="overflow-x: auto; width: 100%;">
  //   <table border="1" cellpadding="5" cellspacing="0" style="min-width: 800px; width: 100%; table-layout: fixed;">
  //     <tr style="background-color:#f4f6fa">
  //       <th style="width: 14%; word-wrap: break-word; text-align: left;">제품명</th>
  //       <th style="width: 25%; word-wrap: break-word; text-align: left;">성분 함량 (1일 섭취량 대비)</th>
  //       <th style="width: 15%; word-wrap: break-word; text-align: left;">추천 대상</th>
  //       <th style="width: 12%; word-wrap: break-word; text-align: left;">가격</th>
  //       <th style="width: 12%; word-wrap: break-word; text-align: left;">용량</th>
  //       <th style="width: 12%; word-wrap: break-word; text-align: left;">맛</th>
  //     </tr>
  //     <tr>
  //       <td style="word-wrap: break-word; text-align: left;"><strong>더블<br>더블파워</strong></td>
  //       <td style="word-wrap: break-word; text-align: left;">총 16종<br>밀크씨슬추출물(실리마린) - 130mg<br>비타민B1 - 25㎎ (2,083%)<br>비타민B2 - 25㎎ (1,786%)<br>나이아신 - 10㎎ (67%)<br>판토텐산 - 5㎎ (100%)<br>비타민B6 - 25㎎ (1,667%)<br>비오틴 - 900㎍ (3,000%)<br>엽산 - 400㎍ (100%)<br>비타민B12 - 2.4㎍ (100%)<br>비타민C - 100㎎ (100%)<br>비타민K - 70㎍ (100%)<br>셀렌 - 55㎍ (100%)<br>철 - 12㎎ (100%)<br>아연 - 10㎎ (118%)<br>망간 - 1.5㎎ (50%)<br>요오드 - 55㎍ (37%)</td>
  //       <td style="word-wrap: break-word; text-align: left;">숙취 및 피로도가 높고,<br>나쁜 식습관으로<br>간 손상이 우려되는 분</td>
  //       <td style="word-wrap: break-word; text-align: left;">34,000원(7개입)<br><strong>1병당 약 4,857원</strong></td>
  //       <td style="word-wrap: break-word; text-align: left;">액상 20ml<br>+ 정제 1.2g</td>
  //       <td style="word-wrap: break-word; text-align: left;">유자맛</td>
  //     </tr>
  //     <tr>
  //       <td style="word-wrap: break-word; text-align: left;"><strong>마그랩<br>포 에너지</strong></td>
  //       <td style="word-wrap: break-word; text-align: left;">총 4종<br>비타민B1 - 1.2㎎ (100%)<br>비타민B2 - 1.4㎎ (100%)<br>비타민B6 - 1.5㎎ (100%)<br>글루콘산마그네슘 - 160mg (51%)</td>
  //       <td style="word-wrap: break-word; text-align: left;">근육이 뭉치거나<br>신경이 예민한 분</td>
  //       <td style="word-wrap: break-word; text-align: left;">39,000원(10개입)<br><strong>1병당 약 3,900원</strong></td>
  //       <td style="word-wrap: break-word; text-align: left;">액상 25ml</td>
  //       <td style="word-wrap: break-word; text-align: left;">레몬라임맛</td>
  //     </tr>
  //     <tr>
  //       <td style="word-wrap: break-word; text-align: left;"><strong>오메가<br>이뮨</strong></td>
  //       <td style="word-wrap: break-word; text-align: left;">총 18종<br>나이아신 - 70㎎NE (467%)<br>비타민B6 - 23㎎ (1,533%)<br>비오틴 - 170㎍ (567%)<br>엽산 - 800㎍ (200%)<br>비타민A - 470㎍ RAE (67%)<br>베타카로틴 - 6㎎<br>비타민C - 1,000㎎ (1,000%)<br>비타민E - 150㎎ α-TE (1,364%)<br>비타민K - 80㎍ (114%)<br>셀렌 - 50㎍ (91%)<br>철 - 7.2㎎ (60%)<br>아연 - 10㎎ (118%)<br>망간 - 2.0㎎ (67%)<br>요오드 - 150㎍ (100%)<br>구리 - 0.5㎎ (63%)<br>몰리브덴 - 65㎍ (260%)<br>크롬 - 30㎍ (100%)</td>
  //       <td style="word-wrap: break-word; text-align: left;">스트레스나 활동량이 많거나,<br>흡연을 하는 분</td>
  //       <td style="word-wrap: break-word; text-align: left;">38,000원(7개입)<br><strong>1병당 약 5,428원</strong></td>
  //       <td style="word-wrap: break-word; text-align: left;">액상 20ml<br>+ 정제 919mg<br>(노란색:447mg<br>+흰색:472mg)</td>
  //       <td style="word-wrap: break-word; text-align: left;">패션프루트향,<br>오렌지향,<br>파인애플향</td>
  //     </tr>
  //     <tr>
  //       <td style="word-wrap: break-word; text-align: left;"><strong>아임비타<br>멀티비타민<br>이뮨샷</strong></td>
  //       <td style="word-wrap: break-word; text-align: left;">총 18종<br>비타민B1 - 48㎎ (4,000%)<br>비타민B2 - 56㎎ (4,000%)<br>판토텐산 - 25㎎ (500%)<br>비타민B6 - 60㎎ (4,000%)<br>비오틴 - 1,200㎍ (4,000%)<br>비타민B12 - 96㎍ (4,000%)<br>베타카로틴 - 6㎎<br>비타민C - 100㎎ (100%)<br>비타민D - 10㎍ (100%)<br>비타민E - 11㎎ α-TE (100%)<br>비타민K - 70㎍ (100%)<br>셀렌 - 55㎍ (100%)<br>아연 - 17㎎ (200%)<br>망간 - 3㎎ (100%)<br>요오드 - 150㎍ (100%)<br>구리 - 0.8㎎ (100%)<br>몰리브덴 - 25㎍ (100%)<br>크롬 - 30㎍ (100%)</td>
  //       <td style="word-wrap: break-word; text-align: left;">면역력이 떨어지고,<br>평소 건강한 식단을<br>챙기시기 어려운 분</td>
  //       <td style="word-wrap: break-word; text-align: left;">25,000원(7개입)<br><strong>1병당 약 3,571원</strong></td>
  //       <td style="word-wrap: break-word; text-align: left;">액상 20ml<br>+ 정제 700mg<br>+ 캡슐 500mg</td>
  //       <td style="word-wrap: break-word; text-align: left;">자몽맛</td>
  //     </tr>
  //   </table>
  // </div>

  // <h2>더블 더블파워</h2>

  // <h3>효과</h3>
  // <p>더블 더블파워는 피로감을 근본적으로 해소할 수 있도록 <strong>간 기능을 지원하기 위한 영양소</strong>들로 구성된 액상형 건강기능식품이에요.</p>

  // <p>특히 간 건강을 위한 대표 성분인 <strong>밀크씨슬이 포함</strong>되어 있다는 점이 특징이에요.</p>
  // <p><strong>비타민B군 8종과 함께 철, 요오드 등의 미량미네랄을 포함</strong>해 <strong>10종의 비타민과 5종의 미네랄이 포함되어 있어 총 16종의 영양소</strong>가 포함되어 있어요.</p>

  // <h3>먹는 시간</h3>
  // <p><strong>1일 1회, 1병을 식후에 섭취할 것을 추천</strong>해요.</p>
  // <p>액상 제형의 제품을 충분히 흔들어 정제와 함께 섭취해주세요.</p>
  // <p>고농축 비타민인만큼 빈 속에 섭취할 경우, 속이 불편한 증상이 나타날 수 있으니 식후에 섭취하시는 것을 추천해요.</p>

  // <h2>마그랩 포 에너지</h2>

  // <h3>효과</h3>
  // <p>마그랩 포 에너지는 에너지 충전과 근육 건강을 함께 챙기는 것을 목적으로 구성된 액상형 건강기능식품이에요.</p>

  // <p>마그네슘은 근육 및 신경 안정에 관여하는 영양소로, <strong>흡수율이 높은 '글루콘산 마그네슘' </strong>형태로 들어있다는 점이 특징이에요.</p>
  // <p><strong>비타민B군 3종이 포함되어 있어 총 4종의 영양소</strong>가 포함되어 있어요.</p>

  // <h3>먹는 시간</h3>
  // <p>1일 1회, 1병을 식후에 섭취하세요.<br>
  // 빈 속에 섭취할 경우 고농축 비타민이기 때문에 속이 불편한 증상이 나타날 수 있어요.</p>

  // <h2>오메가 이뮨</h2>

  // <h3>효과</h3>
  // <p>독일 오메가사에서 생산되는 오메가 이뮨 종합비타민을 동아제약이 국내 정식 수입해 런칭한 제품으로, 해외 제품과는 구성 성분에서 일부 차이가 있어요.</p>

  // <p>'이뮨'이라는 이름답게 면역 기능에 집중한 제품으로, 정상적인 면역 시스템을 유지하기 위해 필요한 미량영양소 들이 배합되어 있어요.</p>
  // <p>특히 <strong>비타민C가 일반 권장량의 10배가 넘는 고함량</strong>이 포함되어 있고, <strong>엽산도 고함량</strong> 포함되어 있어요.</p>
  // <p>이외에도 요오드, 셀레늄 등의 미량미네랄을 포함해 <strong>10종의 비타민과 8종의 미네랄이 포함되어 있어 총 18종의 영양소</strong>가 포함되어 있어요.</p>

  // <h3>먹는 시간</h3>
  // <p>1일 1회, 1병을 식후에 섭취하세요.<br>
  // 빈 속에 섭취할 경우 고농축 비타민이기 때문에 속이 불편한 증상이 나타날 수 있어요.</p>

  // <h2>종근당건강 아임비타 멀티비타민이뮨샷</h2>

  // <h3>효과</h3>
  // <p>종근당건강 아임비타 멀티비타민이뮨샷은 1병으로 필요한 영양소를 다 챙긴다는 올인원 컨셉으로 구성된 액상형 건강기능식품이에요.</p>
  // <p>'이뮨샷'이라는 이름처럼 면역력에 도움이 되는 <strong>비타민D</strong>가 들어있고, <strong>아연</strong>도 높은 함량을 포함하고 있어요.</p>
  // <p><strong>11종의 비타민과 7종의 미네랄이 포함되어 있어 총 18종의 영양소</strong>가 포함되어 있어요.</p>

  // <h3>먹는 시간</h3>
  // <p>1일 1회, 1병을 식후에 섭취하세요.<br>
  // 빈 속에 섭취할 경우 고농축 비타민이기 때문에 속이 불편한 증상이 나타날 수 있어요.</p>
  // ''',
  //           order: 4,
  //           isActive: true,
  //         ),
  //         BannerItem(
  //           id: 'banner5',
  //           imageUrl:
  //               'https://raw.githubusercontent.com/iampeel/fire030701storage/main/banner_magazine_image05_Postbiotics.png',
  //           title: '5 번째 배너',
  //           description:
  //               '''<h1>장 건강에 효과 좋은 포스트바이오틱스 고르는 방법! 인기 제품 TOP4 효과, 후기, 부작용, 추천 제품 비교!</h1>

  // <p>최근 건강에 대한 관심이 높아지면서 '장 건강'의 중요성이 부각되고 있어요.</p>
  // <p>우리 몸의 70%를 차지하는 면역세포가 장에 있다는 사실은 이제 널리 알려졌죠.</p>
  // <p>이로 인해 장 건강은 단순한 소화기 문제를 넘어 전신 건강과 면역력에 직접적인 영향을 미치는 핵심 요소로 인식되고 있어요.</p>

  // <p>이러한 추세에 맞춰 많은 분들이 프로바이오틱스(유산균) 제품을 섭취하고 계실 텐데요.</p>
  // <p><strong>프로바이오틱스</strong>는 장내 유익균의 균형을 맞춰주는 살아있는 미생물을 말해요.</p>

  // <p>하지만 최근에는 프로바이오틱스를 넘어 '프리바이오틱스', '포스트바이오틱스'까지 포함된 복합 성분 제품이 다양하게 출시되고 있어요.</p>
  // <p><strong>프리바이오틱스</strong>는 유익균의 먹이가 되는 성분이고, <strong>포스트바이오틱스</strong>는 프로바이오틱스가 만들어내는 유익한 대사산물을 말해요.</p>

  // <p>특히 최근들어 안전한 형태의 유산균과 유산균의 핵심 성분이 함께 들어있는 '포스트바이오틱스'에 대한 관심이 높아지고 있어요.</p>
  // <p>포스트바이오틱스를 고를 때 어떤 제품이 좋을지, 내 장 건강에 딱 맞는 성분 배합은 무엇일지 궁금하시다면 오늘 NutriPick 연구소에서 맞춤형 제품 선택법을 자세히 알려드릴게요.</p>

  // <h2>✅ 프리바이오틱스, 프로바이오틱스, 포스트바이오틱스란?</h2>

  // <h3>👉 프리바이오틱스</h3>
  // <p><strong>프로바이오틱스의 먹이가 되는 성분을 말해요.</strong></p>
  // <p>대표적으로 프락토올리고당, 자일로올리고당 등이 있는데, 이는 채소나 과일에도 포함된 식이섬유 성분이에요.</p>
  // <p>장 내 미생물이 번식하고 성장할 수 있도록 도와, 건강한 장 내 환경을 유지하는데 도움을 줘요.</p>

  // <h3>👉 프로바이오틱스</h3>
  // <p><strong>장 속에서 유익한 역할을 하는 '살아있는 유산균'을 말해요.</strong></p>
  // <p>장 내 건강과 면역 기능을 강화하는데 도움이 되는 균주로, 살아서 장에 정착한 유산균은 유해균을 억제하고 장 환경을 개선시켜요.</p>
  // <p>그러나 프로바이오틱스가 유익한 역할을 하려면 장까지 잘 살아가야 하는데, 위산이나 담즙처럼 악조건에서 살아남지 못해 효과를 못 보는 경우가 발생하기도 해요.</p>

  // <h3>👉 포스트바이오틱스</h3>
  // <p><strong>유산균이 만들어내는 유익한 대사산물과 유산균의 사균체를 포함하는 개념</strong>이에요.</p>
  // <p>사균체는 고온처리 등 엄한 조건에서 만들어진 안전한 형태의 유산균을 말해요.</p>
  // <p>이는 살아있는 유산균과 달리 위산이나 담즙산에 의한 손실 없이 장까지 잘 도달할 수 있어요.</p>
  // <p>또한 유산균이 장 내에서 만들어낸 이로운 대사산물을 직접 함유하고 있기 때문에, 장에 유익한 물질이 농축된 핵심 성분으로 볼 수 있어요.</p>
  // <p>이런 유익한 물질들이 즉시 몸에 작용하기 때문에 비교적 빠른 효과를 기대할 수 있다는 장점이 있어요.</p>

  // <p>기존에는 유산균과 관련된 용어가 다양하고 복잡해 혼용되어 사용하고 있었어요.</p>
  // <p>지난 2021년 프리바이오틱스학회(ISAPP)에서 <strong>포스트바이오틱스의 정의</strong>를 '<strong>숙주의 건강에 유익한 미생물의 살아 있지 않은 형태 또는 그 미생물의 성분이 포함된 제형</strong>'이라고 명확히 했어요.</p>

  // <h2>일동제약 지큐랩 장건강 포스트솔루션</h2>
  // <h3>영양성분 정보와 효과</h3>
  // <p>📝 포스트바이오틱스</p>
  // <p>락토바실러스 람노서스 IDCC3201 열처리배양건조물 - 400mg</p>

  // <p>📝 프리바이오틱스</p>
  // <p>자일로올리고당 - 700 mg</p>
  // <hr>
  // <p>지큐랩 장건강 포스트솔루션은 <strong>장 건강과 피부면역에 도움이 되는 복합 기능성</strong>을 가지고 있어요.</p>

  // <p>포스트바이오틱스로 식약처로부터 인증받은 개별인정형 원료인 '락토바실러스 람노서스 IDCC3201 열처리배양건조물'이 들어있어요.</p>
  // <p>프리바이오틱스로는 '<strong>자일로올리고당</strong>'이 들어있는데, 자일로올리고당은 프락토올리고당에 비해 유해균을 억제하는 효과가 높다는 <a href="https://pubmed.ncbi.nlm.nih.gov/15173423/">연구 결과</a>가 있었어요.</p>

  // <p>가루형태로 위장 자극이 적은 편이기 때문에 <strong>캡슐을 삼키하는 분들에게 좋은 선택이 될 수 있어요.</strong></p>
  // <p>또, 유명 제약회사에서 만든 제품으로 장 건강에 대한 임상 자료가 풍부하고 기씨적 노하우를 갖춰을 가능성이 크기 때문에 <strong>신뢰도가 높은 편이</strong>라는 장점도 있어요.</p>

  // <p>다만 프로바이오틱스는 따로 들어있지 않다는 점 참고해주세요.</p>

  // <h4>추천 섭취량, 섭취 시간</h4>
  // <p>제조사에서는 <strong>1일 1회 1포</strong>씩 섭취할 것을 권장하고 있어요.</p>

  // <h2>뉴트리코어 메타바이옴 포스트바이오틱스 유산균</h2>
  // <h3>영양성분 정보와 효과</h3>
  // <p>📝 포스트바이오틱스</p>
  // <p>락토바실러스 람노서스 IDCC3201 열처리배양건조물 - 400mg</p>
  // <hr>
  // <p>메타바이오 포스트바이오틱스 유산균은 <strong>피부면역에 도움이 되는 기능성</strong>을 가지고 있어요.</p>

  // <p>포스트바이오틱스로 위에서 소개드린 제품과 동일한 성분인 '락토바실러스 람노서스 IDCC3201 열처리배양건조물'이 들어있어요.</p>
  // <p><strong>정제 형태이고, 개별 포장되어 있어 보관이 용이</strong>해요.</p>

  // <p>다만 프로바이오틱스, 프리바이오틱스는 따로 들어있지 않고, 단일 기능성을 가지고 있어요.</p>

  // <h4>추천 섭취량, 섭취 시간</h4>
  // <p>제조사에서는 <strong>1일 1회 1정</strong>씩 섭취할 것을 권장하고 있어요.</p>

  // <h2>JW중외제약 포스트 프리바이오틱스 프로바이오틱스 프롤린 모유 유산균</h2>
  // <h4>영양성분 정보와 효과</h4>
  // <p>포스트바이오틱스</p>
  // <p>유산균배양건조물 - 0.6mg</p>

  // <p>프리바이오틱스</p>
  // <p>프락토올리고당 - 3,000mg</p>

  // <p>프로바이오틱스</p>
  // <p>다니스코 유산균 7종</p>
  // <p>혼합 유산균 17종</p>
  // <p>모유 유래 유산균 3종 (L.루테리, L.가세리, L.퍼멘텀)</p>
  // <p>균치 유래 유산균</p>
  // <p>- 20억 CFU 투입, 1억 8천만 CFU 보장</p>
  // <hr>
  // <p>포스트 프리바이오틱스 프로바이오틱스 프롤린 모유 유산균은 이름에서도 알 수 있듯이 '프로+프리+포스트' 바이오틱스가 모두 함께 들어있는 제품이에요.</p>
  // <p>유산균으로는 신뢰도 높은 원료사인 다니스코 유산균을 포함하고 있어요.</p>

  // <p>다만 '기타가공품'으로 일반 식품에 해당해요.</p>
  // <p>즉, 건강기능식품이 아니기 때문에 각각의 원료별 함량을 표기되어 있지 않아 정확한 구성을 알기는 어려워요.</p>
  // <p>또, 포스트바이오틱스는 원료가 명확하지 않고 함량이 낮은 편이에요. (6g 중 유산균 배양 건조물 0.01% = 0.6mg)</p>

  // <p>가루형태로 위장 자극이 적은 편이기 때문에 <strong>캡슐을 삼키하는 분들에게 좋은 선택이 될 수 있어요.</strong></p>

  // <h4>추천 섭취량, 섭취 시간</h4>
  // <p>제조사에서는 1일 1회, 1회 1~2포를 직접 또는 물과 함께 섭취할 것을 권장하고 있어요.</p>

  // <h2>여에스더 포스트바이오틱스</h2>

  // <h4>영양성분 정보와 효과</h4>
  // <p>📝 포스트바이오틱스</p>
  // <p>유산균 배양건조물 (유산균 대사산물, L.acidophilus + L.ruteri 유래) - 10mg</p>
  // <p>유산균 사균체 (L.plantarum 유래) - 함량 표기 없음</p>

  // <p>📝 프리바이오틱스</p>
  // <p>프락토올리고당, 갈락토올리고당 - 함량 표기 없음</p>
  // <hr>
  // <p>여에스더 포스트바이오틱스는 포스트바이오틱스와 프리바이오틱스를 포함한 제품이에요.</p>
  // <p>제품 설명 중 <strong>파라바이오틱스</strong>라는 용어를 사용했는데, 이는 '유산균 사균체'를 의미하는 용어로 <strong>현재는 '포스트바이오틱스'라는 개념에 포함된 성분</strong>이라는 점 참고해주세요.</p>

  // <p>'기타가공품'으로 일반 식품에 해당하며, 건강기능식품이 아니기 때문에 각각의 원료별 함량을 표기되어 있지 않아 정확한 구성을 알기는 어려워요.</p>
  // <p><strong>포스트바이오틱스</strong>는 유래 균주를 명확히 밝혔지만, 유산균 사균체의 정확한 함량은 표기되어 있지 않아요.</p>
  // <p><strong>프리바이오틱스</strong>로는 프락토올리고당과 갈락토올리고당을 사용했는데, 정확한 함량은 표기되어 있지 않아요.</p>
  // <p><strong>갈락토올리고당</strong>은 유당이나 젖에서 얻어지는 성분으로, 열과 산에 안정적이라는 장점이 있어요.</p>
  // <p>프로바이오틱스는 들어있지 않아요.</p>

  // <p>가루형태로 위장 자극이 적은 편이기 때문에 캡슐을 삼키하는 분들에게 좋은 선택이 될 수 있어요.</p>

  // <h4>추천 섭취량, 섭취 시간</h4>
  // <p>제조사에서는 1일 1회 1포씩 섭취할 것을 권장하고 있어요.</p>
  // ''',
  //           order: 5,
  //           isActive: true,
  //         ),
  //       ];

  //       // 여러 데이터를 한 번에 저장하기 위해 '배치'라는 도구를 사용
  //       // 배치는 여러 작업을 한꺼번에 처리해서 빠르게 저장해줌
  //       final batch = _firestore.batch();
  //       for (var banner in samples) {
  //         // 각 배너마다 Firestore에 저장할 위치를 정함
  //         final docRef = _firestore.collection(collectionName).doc(banner.id);
  //         // 배너 데이터를 Map 형태로 바꿔서 저장
  //         batch.set(
  //           docRef, // 저장할 위치
  //           banner.toJson(), // 배너 데이터를 Map으로 변환
  //           SetOptions(merge: true), // 이미 데이터가 있으면 덮어쓰지 않고 합침
  //         );
  //       }
  //       // 모든 작업을 한꺼번에 Firestore에 저장
  //       await batch.commit();
  //       // 성공하면 메시지 출력
  //       print('샘플 배너가 성공적으로 생성 또는 업데이트되었습니다.');
  //     } catch (e) {
  //       // 샘플 데이터를 만들다가 오류가 나면 콘솔에 출력
  //       print('샘플 배너 생성 중 오류 발생: $e');
  //       // 오류를 다시 던져서 상위 코드에서 처리할 수 있게 함
  //       rethrow;
  //     }
  //   }
}
