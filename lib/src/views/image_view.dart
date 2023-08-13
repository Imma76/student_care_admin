import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';

import '../theme/app_theme.dart';

class ImageView extends StatelessWidget {
  final String? imageUrl;
  const ImageView({Key? key,this.imageUrl}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading:IconButton(onPressed: (){
          Navigator.pop(context);
        },icon: const Icon(Icons.arrow_back_ios_rounded,color: AppTheme.black,),),

        backgroundColor: Colors.transparent,elevation: 0.0,),
      body: Center(child: CachedNetworkImage(imageUrl: imageUrl!,),),
    );
  }
}
