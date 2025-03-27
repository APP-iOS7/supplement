// 배너 한 개의 정보를 담는 설계도(클래스)
// 이 클래스는 배너의 이미지, 제목, 설명 등을 저장해요
class BannerItem {
  // 배너의 고유 번호 (Firestore에서 문서 ID로 사용)
  // final은 한 번 정하면 바꿀 수 없는 값이에요
  final String id;

  // 배너 이미지의 인터넷 주소 (예: "https://example.com/image.jpg")
  final String imageUrl;

  // 배너의 제목 (예: "첫 번째 배너")
  final String title;

  // 배너에 대한 자세한 설명 (HTML 형식의 문자열로 저장됨)
  // 예: "<h2>제목</h2><p>내용</p><img src='https://example.com/image.png'/>"
  final String description;

  // 배너의 정렬 순서 (1, 2, 3처럼 순서를 정할 때 사용)
  final int order;

  // 배너를 클릭했을 때 이동할 외부 링크 (없어도 됨, 선택 사항)
  // ?는 "이 값이 없을 수도 있어요"라는 뜻
  final String? linkUrl;

  // 배너가 활성화되어 있는지 여부 (true면 보임, false면 숨김)
  final bool isActive;

  // BannerItem 객체를 만들 때 필요한 정보를 받는 곳
  // required는 "이건 꼭 줘야 해!"라는 뜻
  BannerItem({
    required this.id, // ID는 필수
    required this.imageUrl, // 이미지 주소는 필수
    required this.title, // 제목은 필수
    required this.description, // 설명은 필수 (HTML 형식으로 저장)
    this.order = 0, // 순서는 기본값 0 (안 주면 0이 됨)
    this.linkUrl, // 링크는 선택 (안 주면 null)
    this.isActive = true, // 활성화 여부는 기본값 true (안 주면 활성화)
  });

  // Firestore에서 데이터를 받아서 BannerItem 객체로 만드는 메서드
  // factory는 "특별한 방법으로 객체를 만드는 곳"이라는 뜻
  // json은 Firestore에서 온 데이터, docId는 문서 ID (없으면 json에서 찾아봄)
  factory BannerItem.fromJson(Map<String, dynamic> json, {String? docId}) {
    return BannerItem(
      id: docId ?? json['id'] ?? '', // docId가 있으면 그걸, 없으면 json의 'id', 없으면 빈 문자열
      imageUrl: json['imageUrl'] ?? '', // 'imageUrl'이 없으면 빈 문자열
      title: json['title'] ?? '', // 'title'이 없으면 빈 문자열
      description:
          json['description'] ?? '', // 'description'이 없으면 빈 문자열 (HTML 형식으로 저장됨)
      order: json['order'] ?? 0, // 'order'가 없으면 0
      linkUrl: json['linkUrl'], // 'linkUrl'은 null일 수 있음
      isActive: json['isActive'] ?? true, // 'isActive'가 없으면 true
    );
    // ??는 "앞에 값이 없으면 뒤에 값을 써!"라는 뜻 (오류 방지)
  }

  // BannerItem 객체를 Firestore에 저장할 수 있는 데이터로 바꾸는 메서드
  // Map<String, dynamic>은 "키: 값" 쌍으로 된 데이터 (Firestore에 맞는 형태)
  Map<String, dynamic> toJson() {
    return {
      'id': id, // ID를 저장
      'imageUrl': imageUrl, // 이미지 주소를 저장
      'title': title, // 제목을 저장
      'description': description, // 설명을 저장 (HTML 형식의 문자열)
      'order': order, // 순서를 저장
      'linkUrl': linkUrl, // 링크를 저장 (없으면 null)
      'isActive': isActive, // 활성화 여부를 저장
    };
    // 이건 Firestore에 넣을 수 있는 데이터로 변환된 형태예요
  }
}
