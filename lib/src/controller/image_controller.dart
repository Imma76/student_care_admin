import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

import '../services/image_service.dart';

class ImageController extends ChangeNotifier{

  List<File> audioFiles = [];
  List<File> imageFiles= List<File>.empty(growable: true);
  List<File> videoFiles = [];
  List<String> imageUrlList = [];
  List<String> audioUrlList = [];
  List<String> videoUrlList = [];

  final _picker = ImagePicker();

  void pickImage ()async{

    try {

      final pickedImageFiles = await _picker.pickMultiImage(
        // source: ImageSource.gallery,
      );



      if (pickedImageFiles!.isNotEmpty) {
        for (XFile image in pickedImageFiles) {
          imageFiles.add(File(image.path));
          notifyListeners();
        }
        // return ourImages;
      } else {
        print('selected image is null');
        // return ourImages;
      }
    } catch (e) {
      print('hhhh$e');

    }
  }
  // void pickVideos ()async{
  //   FilePickerResult? result = await FilePicker.platform.pickFiles(allowMultiple: true,type: FileType.video);
  //
  //   if (result != null) {
  //     videoFiles = result.paths.map((path) => File(path.toString())).toList();
  //     notifyListeners();
  //   } else {
  //     // User canceled the picker
  //   }
  // }
  // void pickAudios ()async{
  //   FilePickerResult? result = await FilePicker.platform.pickFiles(allowMultiple: true,type: FileType.audio);
  //
  //   if (result != null) {
  //     audioFiles = result.paths.map((path) => File(path.toString())).toList();
  //     notifyListeners();
  //   } else {
  //     // User canceled the picker
  //   }
  // }
  Future uploadImage()async{
    print('upload');

    if(imageFiles.isNotEmpty){
      print('not empty');
      for(var imageFile in imageFiles){
        String url  = await ImageService.storeImage(imageFile);
        imageUrlList.add(url);
      }
    }
  }
  Future uploadVideo()async{

    if(videoFiles.isNotEmpty){
      for(var imageFile in imageFiles){
        String url  = await ImageService.storeVideo(imageFile);
        videoUrlList.add(url);
      }
    }
  }
  Future uploadAudio()async{

    if(videoFiles.isNotEmpty){
      for(var imageFile in imageFiles){
        String url  = await ImageService.storeAudio(imageFile);
        audioUrlList.add(url);
      }
    }
  }
  void clearList(){
    imageFiles.clear();
    videoFiles.clear();
    audioFiles.clear();
    imageUrlList.clear();
    audioUrlList.clear();
    videoUrlList.clear();
  }
}


