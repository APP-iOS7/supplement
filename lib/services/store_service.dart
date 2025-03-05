import 'package:cloud_firestore/cloud_firestore.dart';
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
}
