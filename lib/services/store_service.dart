import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:supplementary_app/models/recommend_item_model.dart';
import 'package:supplementary_app/models/user_model.dart';

class StoreService {
  final _store = FirebaseFirestore.instance;

  Future<void> makeUserInfo(UserModel usermodel) async {
    await _store.collection('users').doc(usermodel.uid).set({
      'gender': usermodel.gender,
      'birthDate': usermodel.birthDate,
      'createdAt': usermodel.createdAt,
    });
  }

  Future<UserModel> getUserInfoByUid(String uid) async {
    final doc = await _store.collection('users').doc(uid).get();

    if (!doc.exists) {
      throw Exception('User not found');
    }

    final data = doc.data()!;
    return UserModel(
      uid: uid,
      gender: data['gender'],
      birthDate: (data['birthDate'] as Timestamp).toDate(),
      createdAt: (data['createdAt'] as Timestamp).toDate(),
    );
  }

  Future<void> saveToMyRecommendaions(
    String uid,
    RecommendItemModel recommendation,
  ) async {
    await _store.collection('recommendations').doc(uid).set({
      'recommendItems': FieldValue.arrayUnion([recommendation.toJson()]),
    }, SetOptions(merge: true));
  }

  Future<List<RecommendItemModel>> getRecommendations() async {
    final snapshot = await _store.collection('recommendations').get();
    return snapshot.docs
        .map((doc) {
          final data = doc.data();
          final items = data['recommendItems'] as List;
          return items
              .map((item) => RecommendItemModel.fromJson(item))
              .toList();
        })
        .expand((element) => element)
        .toList();
  }

  Stream<List<RecommendItemModel>> streamRecommendations() {
    return _store.collection('recommendations').snapshots().map((snapshot) {
      return snapshot.docs
          .map((doc) {
            final data = doc.data();
            final items = data['recommendItems'] as List;
            return items
                .map((item) => RecommendItemModel.fromJson(item))
                .toList();
          })
          .expand((element) => element)
          .toList();
    });
  }
}
