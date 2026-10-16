import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../course_data.dart';
import '../identity.dart';
import '../providers/course_provider.dart';

class ProviderDemoPage extends StatelessWidget {
  const ProviderDemoPage({super.key});

  @override
  Widget build(BuildContext context) {
    debugPrint('build: ProviderDemoPage (halaman, tidak listen)');
    return Scaffold(
      appBar: AppBar(title: const Text('Tahap 7 - watch/read/Consumer')),
      body: Column(
        children: [
          const IdentityBanner(),
          const _FavoriteCount(),
          const SizedBox(height: 8),
          Expanded(
            child: ListView(
              children: courses
                  .map((c) => _CourseTile(code: c['code'] as String))
                  .toList(),
            ),
          ),
        ],
      ),
    );
  }
}

class _FavoriteCount extends StatelessWidget {
  const _FavoriteCount();

  @override
  Widget build(BuildContext context) {
    final provider = context.watch<CourseProvider>();
    debugPrint('build: _FavoriteCount');
    return Padding(
      padding: const EdgeInsets.all(16),
      child: Text(
        'Jumlah favorite: ${provider.favorites.length}',
        style: Theme.of(context).textTheme.titleLarge,
      ),
    );
  }
}

class _CourseTile extends StatelessWidget {
  final String code;
  const _CourseTile({required this.code});

  @override
  Widget build(BuildContext context) {
    debugPrint('build: _CourseTile $code');
    return ListTile(
      title: Text(code),
      trailing: Consumer<CourseProvider>(
        builder: (context, provider, child) {
          debugPrint('build: Consumer ikon $code');
          return IconButton(
            icon: Icon(
              provider.isFavorite(code)
                  ? Icons.favorite
                  : Icons.favorite_border,
              color: provider.isFavorite(code) ? Colors.red : null,
            ),
            onPressed: () => context.read<CourseProvider>().toggleFavorite(code),
          );
        },
      ),
    );
  }
}
