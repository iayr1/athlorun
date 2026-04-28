import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:health/health.dart';
import 'package:hive_flutter/adapters.dart';
import 'package:athlorun/config/di/dependency_injection.dart';
import 'package:athlorun/config/routes/navigation_service.dart';
import 'config/routes/routes.dart';
import 'core/utils/windows.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Hive.initFlutter();
  await Health().configure();
  await Hive.openBox('userBox');
  await setupServiceLocator();
  // Set status bar color to white and icons/text to dark
  SystemChrome.setSystemUIOverlayStyle(
    const SystemUiOverlayStyle(
      statusBarColor: Colors.white,
      statusBarIconBrightness: Brightness.dark,
      statusBarBrightness: Brightness.light,
    ),
  );
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    NavigationService navigationService = sl<NavigationService>();
    Window().adaptDeviceScreenSize(view: View.of(context));
    return MaterialApp(
      navigatorKey: navigationService.navigatorKey,
      debugShowCheckedModeBanner: false,
      title: 'athlorun',
      initialRoute: AppRoutes.navigateScreen,
      onGenerateRoute: AppRoutes.generateRoute,
      theme: ThemeData(
        scaffoldBackgroundColor: Colors.white,
      ),
    );
  }
}
