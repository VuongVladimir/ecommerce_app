import 'package:ecommerce_app_fluterr_nodejs/common/widgets/bottom_bar.dart';
import 'package:ecommerce_app_fluterr_nodejs/constants/global_variables.dart';
import 'package:ecommerce_app_fluterr_nodejs/features/admin/screens/admin_screen.dart';
import 'package:ecommerce_app_fluterr_nodejs/features/auth/screens/auth_screen.dart';
import 'package:ecommerce_app_fluterr_nodejs/features/auth/services/auth_service.dart';
import 'package:ecommerce_app_fluterr_nodejs/providers/user_provider.dart';
import 'package:ecommerce_app_fluterr_nodejs/router.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

void main() {
  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(
          create: (context) => UserProvider(),
        ),
      ],
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  final AuthService authService = AuthService();
  @override
  void initState() {
    super.initState();
    authService.getUserData(context);
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'E-commerce App Demo',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(
          seedColor: GlobalVariables.backgroundColor,
          background: GlobalVariables.backgroundColor,
        ),
        useMaterial3: true,
      ),
      onGenerateRoute: (settings) => generateRoute(settings),
      home: (Provider.of<UserProvider>(context).user.token.isNotEmpty)
          ? (Provider.of<UserProvider>(context).user.type == "user")
              ? const BottomBar()
              : const AdminScreen()
          : const AuthScreen(),
    );
  }
}
