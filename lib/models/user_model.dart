// 사용자 정보를 담는 모델 클래스
class UserModel {
  final String uid;
  final String gender;
  final DateTime birthDate;
  final DateTime createdAt;

  UserModel({
    required this.uid,
    required this.gender,
    required this.birthDate,
    required this.createdAt,
  });
}
