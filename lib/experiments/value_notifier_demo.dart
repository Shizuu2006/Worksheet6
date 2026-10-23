import 'package:flutter/material.dart';
import '../widgets/identity_banner.dart';
import 'provider_demo_page.dart';

class ValueNotifierDemoPage extends StatefulWidget {
  const ValueNotifierDemoPage({super.key});

  @override
  State<ValueNotifierDemoPage> createState() => _ValueNotifierDemoPageState();
}

class _ValueNotifierDemoPageState extends State<ValueNotifierDemoPage> {
  final ValueNotifier<int> favoriteCount = ValueNotifier<int>(0);

  @override
  void dispose() {
    favoriteCount.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    debugPrint('build: ValueNotifierDemoPage (parent)');
    return Scaffold(
      appBar: AppBar(
        title: const Text('Tahap 4 - ValueNotifier'),
        actions: [
          IconButton(
            tooltip: 'Demo Provider (Tahap 7)',
            icon: const Icon(Icons.share),
            onPressed: () => Navigator.push<void>(
              context,
              MaterialPageRoute<void>(
                builder: (_) => const ProviderDemoPage(),
              ),
            ),
          ),
        ],
      ),
      body: Column(
        children: [
          const IdentityBanner(),
          const SizedBox(height: 24),
          ValueListenableBuilder<int>(
            valueListenable: favoriteCount,
            builder: (context, value, child) {
              debugPrint('build: ValueListenableBuilder -> $value');
              return Text(
                'Jumlah favorite: $value',
                style: Theme.of(context).textTheme.headlineMedium,
              );
            },
          ),
          const SizedBox(height: 16),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              ElevatedButton(
                onPressed: () {
                  if (favoriteCount.value > 0) favoriteCount.value--;
                },
                child: const Text('- Kurangi'),
              ),
              const SizedBox(width: 12),
              ElevatedButton(
                onPressed: () => favoriteCount.value++,
                child: const Text('+ Tambah'),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
