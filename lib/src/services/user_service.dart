import 'package:cloud_firestore/cloud_firestore.dart';

import '../collections.dart';
import '../model/UserModel.dart';

class UserService{
  static  Stream<List<UserModel>>? getAllUsers( {String? orderBy = 'createdAt',
    bool? descending = true,
    var startAt,}){
    try{
      Query query =  Collections.users.orderBy("createdAt",descending: true);

      return query.snapshots()
          .map((snapShot) => snapShot.docs.map<UserModel>((userModel) {

        Map _temp = userModel.data() as Map<dynamic, dynamic>;
        _temp['postId'] = userModel.id;
        // //(_temp);
        return UserModel.fromJson(_temp as Map<String, dynamic>);
      }).toList());
    }catch(e){
      return null;
    }
  }
}