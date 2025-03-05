// 사용자 정보를 담는 모델 클래스
class UserModel {
  final String uid; // 사용자 고유 ID
  final String? gender; // 성별 ('male' 또는 'female')
  final DateTime? birthDate; // 생년월일
  final bool marketingAgreed; // 마케팅 수신 동의 여부
  final DateTime createdAt; // 생성일
  final bool isLoggedOut; // 로그아웃 여부
  final DateTime lastLoginTime; // 마지막 로그인 시간
  final DateTime lastLogoutTime; // 마지막 로그아웃 시간
  final DateTime lastUpdated; // 마지막 업데이트 시간

  UserModel({
    required this.uid,
    this.gender,
    this.birthDate,
    this.marketingAgreed = false,
    required this.createdAt,
    required this.isLoggedOut,
    required this.lastLoginTime,
    required this.lastLogoutTime,
    required this.lastUpdated,
  });

  // isMen getter 추가
  bool get isMen => gender?.toLowerCase() == 'male';

  // 포맷팅된 생년월일을 반환하는 getter
  String get formattedBirthDate {
    if (birthDate == null) return '';
    return '${birthDate!.year}.${birthDate!.month.toString().padLeft(2, '0')}.${birthDate!.day.toString().padLeft(2, '0')}';
  }

  // Firestore 데이터를 UserModel 객체로 변환
  factory UserModel.fromMap(Map<String, dynamic> map, String id) {
    return UserModel(
      uid: id,
      gender: map['gender'],
      birthDate:
          map['birthDate'] != null
              ? DateTime.fromMillisecondsSinceEpoch(map['birthDate'])
              : null,
      marketingAgreed: map['marketingAgreed'] ?? false,
      createdAt: DateTime.fromMillisecondsSinceEpoch(map['createdAt']),
      isLoggedOut: map['isLoggedOut'] ?? false,
      lastLoginTime: DateTime.fromMillisecondsSinceEpoch(map['lastLoginTime']),
      lastLogoutTime: DateTime.fromMillisecondsSinceEpoch(
        map['lastLogoutTime'],
      ),
      lastUpdated: DateTime.fromMillisecondsSinceEpoch(map['lastUpdated']),
    );
  }

  // UserModel 객체를 Firestore 저장용 Map으로 변환
  Map<String, dynamic> toMap() {
    return {
      'gender': gender,
      'birthDate': birthDate?.millisecondsSinceEpoch,
      'marketingAgreed': marketingAgreed,
      'createdAt': createdAt.millisecondsSinceEpoch,
      'isLoggedOut': isLoggedOut,
      'lastLoginTime': lastLoginTime.millisecondsSinceEpoch,
      'lastLogoutTime': lastLogoutTime.millisecondsSinceEpoch,
      'lastUpdated': lastUpdated.millisecondsSinceEpoch,
    };
  }
}
