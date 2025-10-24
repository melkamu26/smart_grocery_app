import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'state/app_state.dart';
import 'state/theme_provider.dart';
import 'screens/home_screen.dart';
import 'screens/add_edit_screen.dart';
import 'screens/checklist_screen.dart';
import 'screens/weekly_generator_screen.dart';
import 'theme/app_theme.dart';

void main() {
  runApp(const SmartGroceryApp());
}

class SmartGroceryApp extends StatelessWidget {
  const SmartGroceryApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => AppState()),
        ChangeNotifierProvider(create: (_) => ThemeProvider()),
      ],
      child: Consumer<ThemeProvider>(
        builder: (context, themeProvider, _) {
          return MaterialApp(
            debugShowCheckedModeBanner: false,
            title: 'Smart Grocery List',
            theme: AppTheme.light(),
            darkTheme: AppTheme.dark(),
            themeMode: themeProvider.themeMode,
            routes: {
              '/': (_) => const HomeScreen(),
              AddEditScreen.route: (_) => const AddEditScreen(),
              ChecklistScreen.route: (_) => const ChecklistScreen(),
              WeeklyGeneratorScreen.route: (_) => const WeeklyGeneratorScreen(),
            },
          );
        },
      ),
    );
  }
}