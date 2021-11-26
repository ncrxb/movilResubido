






import 'package:flutter/widgets.dart';
import 'package:movil/app/ui/pages/home/home_page.dart';
import 'package:movil/app/ui/pages/request_permission/request_permission_page.dart';
import 'package:movil/app/ui/routes/routes.dart';
import 'package:movil/app/ui/splash/splash_page.dart';

Map<String, Widget Function(BuildContext)> appRoutes(){
  return{
    Routes.SPLASH:(_) => const SplashPage(),
    Routes.PERMISSIONS: (_) => RequestPermissionPage(),
    Routes.HOME: (_) => const HomePage()

  };
}