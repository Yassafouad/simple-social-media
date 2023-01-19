import 'package:social_app/modules/login/login_screen.dart';
import 'package:social_app/shared/components/components.dart';
import 'package:social_app/shared/network/local/cache_helper.dart';

void signOut(context) {
  CacheHelper.removeData(key: 'token').then((value) {
    if(value) {
      navigateAndRemove(context, LoginScreen(),);
    }
  });
}

dynamic token = '';

dynamic uId = '';