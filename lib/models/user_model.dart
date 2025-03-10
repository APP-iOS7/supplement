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

  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(
      uid: json['uid'] as String,
      gender: json['gender'] as String,
      birthDate: (json['birthDate'] as DateTime),
      createdAt: (json['createdAt'] as DateTime),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'uid': uid,
      'gender': gender,
      'birthDate': birthDate,
      'createdAt': createdAt,
    };
  }
}
