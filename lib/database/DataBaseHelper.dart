import 'package:ChatApp/model/User.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

CollectionReference<User> getUsersCollectionWithConverter(){
  return FirebaseFirestore.instance.collection(User.CollectionName).withConverter<User>(
    fromFirestore: (snapshot, _) =>
        User.fromJson(snapshot.data()!),
    toFirestore: (user, _) => user.toJson(),
  );
}