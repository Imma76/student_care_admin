import 'dart:io';

import 'package:firebase_storage/firebase_storage.dart';
import 'package:uuid/uuid.dart';

var uuid = Uuid();
class ImageService{




  static Future<String> storeImage(File image, )async{
    print('kkkkkkkhere');
    final name = uuid.v4();
    try{
      final upload = await FirebaseStorage.instance.ref('images/').child(name).putFile(image);

      final url = await upload.ref.getDownloadURL();
      return url;
    }catch(e){
      print(e.toString());
      return '';

    }


  }
  static Future<String> storeVideo(File image, )async{
    final name = uuid.v4();

    final upload = await FirebaseStorage.instance.ref('videos/').child(name).putFile(image);

    final url = await FirebaseStorage.instance.ref('videos/').child(name).getDownloadURL();
    return url;
  }
  static Future<String> storeAudio(File image, )async{
    final name = uuid.v4();

    final upload = await FirebaseStorage.instance.ref('audios/').child(name).putFile(image);

    final url = await FirebaseStorage.instance.ref('audios/').child(name).getDownloadURL();
    return url;
  }
}