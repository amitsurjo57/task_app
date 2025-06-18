import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:task_app/presentation/screens/feed_screen.dart';
import 'package:task_app/presentation/screens/log_in_screen.dart';
import 'package:task_app/service/shared_preference_service.dart';

Future<void> main() async {
  await Supabase.initialize(
    url: 'https://oydqliyqqbnfekpyhsfl.supabase.co',
    anonKey:
        'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6Im95ZHFsaXlxcWJuZmVrcHloc2ZsIiwicm9sZSI6ImFub24iLCJpYXQiOjE3NTAxMzc5NzYsImV4cCI6MjA2NTcxMzk3Nn0.8IoaxEHS1OWHChJ3pZwDNJspdEj8t7ulJrwc5BVSxnY',
  );
  runApp(const MyApp());
}

final supaBase = Supabase.instance.client;

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  bool _chooseFeed = false;

  @override
  void initState() {
    super.initState();
    _screenChoose();
  }

  Future<void> _screenChoose() async {
    String? getId = await SharedPreferenceService().getUserId();

    if (getId == null) {
      _chooseFeed = false;
    } else {
      _chooseFeed = true;
    }
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: _chooseFeed ? FeedScreen() : LogInScreen(),
      theme: ThemeData(
        scaffoldBackgroundColor: Color(0xFFF0F2F6),
        drawerTheme: DrawerThemeData(
          backgroundColor: Color(0xFFF0F2F6),
        ),
        appBarTheme: AppBarTheme(backgroundColor: Colors.white),
        iconTheme: IconThemeData(color: Colors.black),
        inputDecorationTheme: InputDecorationTheme(
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(25)),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(25),
            borderSide: BorderSide(color: Colors.black, width: 2),
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(25),
            borderSide: BorderSide(color: Colors.black),
          ),
          hintStyle: TextStyle(color: Colors.black),
        ),
        progressIndicatorTheme: ProgressIndicatorThemeData(color: Colors.black),
        elevatedButtonTheme: ElevatedButtonThemeData(
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.black,
            foregroundColor: Colors.white,
            textStyle: TextStyle(fontSize: 20, fontWeight: FontWeight.w500),
            minimumSize: Size(double.infinity, 52),
          ),
        ),
      ),
    );
  }
}
