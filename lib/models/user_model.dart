// 사용자 정보를 담는 모델 클래스
class UserModel {
  final String uid; // 사용자 고유 ID
  final String? gender; // 성별 ('male' 또는 'female')
  final DateTime? birthDate; // 생년월일
  final bool marketingAgreed; // 마케팅 수신 동의 여부

  UserModel({
    required this.uid,
    this.gender,
    this.birthDate,
    this.marketingAgreed = false,
  });

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
    );
  }

  // UserModel 객체를 Firestore 저장용 Map으로 변환
  Map<String, dynamic> toMap() {
    return {
      'gender': gender,
      'birthDate': birthDate?.millisecondsSinceEpoch,
      'marketingAgreed': marketingAgreed,
    };
  }
}
