import 'package:flutter/material.dart';

import 'attendance_home_page.dart';

void main() {
  runApp(const AttendanceApp());
}

class AttendanceApp extends StatelessWidget {
  const AttendanceApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Attendance Calculator',
      theme: ThemeData(
        primarySwatch: Colors.red,
        brightness: Brightness.light, // Dark theme for bold color contrast
        textTheme: const TextTheme(
          bodyLarge: TextStyle(color: Colors.black),
        ),
      ),
      home: const AttendanceHomePage(),
    );
  }
}
