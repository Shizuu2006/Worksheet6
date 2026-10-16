import 'package:flutter/material.dart';

import '../identity.dart';
import '../models/course.dart';

class ModelDemoPage extends StatelessWidget {
  const ModelDemoPage({super.key});

  @override
  Widget build(BuildContext context) {
    final course = Course.fromJson({
      'code': 'IF101',
      'title': 'Pemrograman Mobile',
      'credits': 3,
      'status': 'Aktif',
    });

    return Scaffold(
      appBar: AppBar(title: const Text('Tahap 8 - Model Course')),
      body: Column(
        children: [
          const IdentityBanner(),
          Padding(
            padding: const EdgeInsets.all(16),
            child: Card(
              child: ListTile(
                leading: CircleAvatar(
                  child: Text('${course.credits}'),
                ),
                title: Text(course.title),
                subtitle: Text('${course.code} - ${course.credits} SKS - ${course.status}'),
                trailing: Chip(
                  label: Text(course.status),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
