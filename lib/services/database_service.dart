import 'package:cloud_firestore/cloud_firestore.dart';

class DatabaseService{
  final String? uid;
  DatabaseService({this.uid});


  //reference for our collection
  final CollectionReference userCollection =
  FirebaseFirestore.instance.collection("users");

  //updating
Future savingUserData(String fullName , String email)async{
return await userCollection.doc(uid).set({
  "fullName":fullName,
  "email": email,
  "profilePic":"",
  "uid": uid,
});
}
// getting user data
  Future gettingUserData(String email) async {
    QuerySnapshot snapshot =
    await userCollection.where("email", isEqualTo: email).get();
    return snapshot;
  }
}