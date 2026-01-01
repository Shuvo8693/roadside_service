import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

import 'app/routes/app_pages.dart';
import 'common/app_constant/app_constant.dart';
import 'common/controller/localization_controller.dart';
import 'common/di/di.dart';
import 'common/themes/light_theme.dart';
import 'common/widgets/message.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  Map<String, Map<String, String>> languages = await init();

  SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
    DeviceOrientation.portraitDown
  ]).then((_) {
    runApp(MyApp(languages: languages));
  });
}

class MyApp extends StatelessWidget {
  const MyApp({super.key, required this.languages});

  final Map<String, Map<String, String>> languages;

  @override
  Widget build(BuildContext context) {
    final localizeController = Get.find<LocalizationController>();
    return ScreenUtilInit(
        designSize: const Size(393, 852),
        minTextAdapt: true,
        splitScreenMode: true,
        builder: (_, child) {
          return GetMaterialApp(
            title: AppConstants.APP_NAME,
            debugShowCheckedModeBanner: false,
            navigatorKey: Get.key,
            theme: light(),
            defaultTransition: Transition.noTransition,
            locale: localizeController.locale,
            translations: Messages(languages: languages),
            fallbackLocale: Locale(
                AppConstants.languages[0].languageCode,
                AppConstants.languages[0].countryCode
            ),
            transitionDuration: const Duration(milliseconds: 500),
            getPages: AppPages.routes,
            initialRoute: AppPages.INITIAL,
          );
        }
    );
  }
}