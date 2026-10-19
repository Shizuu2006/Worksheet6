import 'package:flutter/material.dart';

import 'app_theme.dart';
import 'identity.dart';

void main() => runApp(const CourseExplorerApp());

class CourseExplorerApp extends StatelessWidget {
  const CourseExplorerApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Course Explorer',
      debugShowCheckedModeBanner: false,
      theme: appTheme,
      home: const Stage0(),
    );
  }
}

class Stage0 extends StatelessWidget {
  const Stage0({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Tahap 0 - Environment')),
      body: const Column(
        children: [
          IdentityBanner(),
          Expanded(
            child: Center(
              child: Text(
                'Project siap dijalankan.',
                style: TextStyle(fontSize: 16),
              ),
            ),
          ),
        ],
      ),
    );
  }
}