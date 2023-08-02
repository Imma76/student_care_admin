import 'package:flutter/cupertino.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';

import '../theme/app_theme.dart';

class Indicator2 extends StatelessWidget {
  final Color? color;
  const Indicator2({Key? key,this.color}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Center(child: SizedBox(
        child:SpinKitDoubleBounce(color: AppTheme.primary,)
    ));
  }
}