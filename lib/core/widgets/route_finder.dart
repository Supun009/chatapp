import 'package:chatapp/core/local_repo/shared_pref.dart';
import 'package:chatapp/core/widgets/login_or_signup.dart';
import 'package:chatapp/features/auth/view_model/auth_provider.dart';

import 'package:chatapp/features/chat/view/main_page.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class RouteFinder extends StatefulWidget {
  const RouteFinder({super.key});

  @override
  State<RouteFinder> createState() => _RouteFinderState();
}

class _RouteFinderState extends State<RouteFinder> {
  SharedPrefService prefService = SharedPrefService();

  @override
  void initState() {
    super.initState();
    loadPhonenumber();
  }

  String? phoneNumber;

  loadPhonenumber() {
    Provider.of<AuthProvider>(context, listen: false).loadPhonenumber();
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<AuthProvider>(builder: (context, authProvider, child) {
      if (authProvider.phoneNumber == null) {
        return const LoginOrSignup();
      } else {
        return const MainPage();
      }
    });
  }
}
