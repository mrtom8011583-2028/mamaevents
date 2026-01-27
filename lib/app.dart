import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'screens/home_screen.dart';
import 'providers/app_config_provider.dart';
import 'providers/menu_provider.dart';

class WasabiCateringApp extends StatelessWidget {
  const WasabiCateringApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => AppConfigProvider()),
        ChangeNotifierProvider(create: (_) => MenuProvider()),
      ],
      child: MaterialApp(
        title: 'Wasabi Catering Co.',
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
          primarySwatch: Colors.green,
          fontFamily: 'Inter',
          useMaterial3: true,
        ),
        home: const HomeScreen(),
      ),
    );
  }
}