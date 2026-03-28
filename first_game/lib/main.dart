import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'core/services/storage_service.dart';
import 'core/theme/app_theme.dart';
import 'routes/app_routes.dart';
import 'routes/route_generator.dart';

// Controllers
import 'features/auth/auth_controller.dart';
import 'features/devices/device_controller.dart';
import 'features/home/home_controller.dart';
import 'features/voice_control/voice_controller.dart';
import 'features/gesture_control/gesture_controller.dart';
import 'features/web_control/web_controller.dart';
import 'features/automation/automation_controller.dart';
import 'features/settings/settings_controller.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await StorageService.init();
  runApp(
    const ProviderScope(
      child: SmartHomeApp(),
    ),
  );
}

class SmartHomeApp extends StatelessWidget {
  const SmartHomeApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => AuthController()),
        ChangeNotifierProvider(create: (_) => VoiceController()),
        ChangeNotifierProvider(create: (_) => GestureController()),
        ChangeNotifierProvider(create: (_) => WebController()),
        ChangeNotifierProvider(create: (_) => AutomationController()),
        ChangeNotifierProvider(create: (_) => SettingsController()),
      ],
      child: Consumer<SettingsController>(
        builder: (_, settings, __) {
          return MaterialApp(
            title: 'Smart Home AI',
            debugShowCheckedModeBanner: false,
            theme: settings.isDarkMode ? AppTheme.darkTheme : AppTheme.lightTheme,
            initialRoute: AppRoutes.login,
            onGenerateRoute: RouteGenerator.generateRoute,
          );
        },
      ),
    );
  }
}