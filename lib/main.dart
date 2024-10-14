import 'package:chatapp/core/local_repo/db_helper.dart';
import 'package:chatapp/core/local_repo/shared_pref.dart';
import 'package:chatapp/core/widgets/route_finder.dart';

import 'package:chatapp/features/auth/view_model/auth_provider.dart';
import 'package:chatapp/features/chat/view_model/chat_service.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'theme/theme.dart';

final GlobalKey<ScaffoldMessengerState> scaffoldMessengerKey =
    GlobalKey<ScaffoldMessengerState>();

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Initialize the shared preferences
  SharedPrefService prefService = SharedPrefService();

  final dbHelper = DatabaseHelper(); // Create instance of your DatabaseHelper
  await dbHelper.database;

  await prefService.init();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => SharedPrefService()),
        ChangeNotifierProvider(create: (_) => AuthProvider()),
        ChangeNotifierProvider(
            create: (_) => ChatProvider(
                  showSnackbarCallback: (message) =>
                      scaffoldMessengerKey.currentState?.showSnackBar(
                    SnackBar(
                      content: Text(message),
                    ),
                  ),
                )),
      ],
      child: MaterialApp(
          scaffoldMessengerKey: scaffoldMessengerKey,
          title: 'Flutter Demo',
          theme: AppTheme.darkThemeMode,
          debugShowCheckedModeBanner: false,
          home: const RouteFinder()),
    );
  }
}
