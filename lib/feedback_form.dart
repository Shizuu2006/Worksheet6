import 'package:flutter/material.dart';

import 'identity.dart';

class FeedbackForm extends StatefulWidget {
  const FeedbackForm({super.key});

  @override
  State<FeedbackForm> createState() => _FeedbackFormState();
}

class _FeedbackFormState extends State<FeedbackForm> {
  final _formKey = GlobalKey<FormState>();
  final _nameCtrl = TextEditingController(text: studentName);
  final _nimCtrl = TextEditingController(text: studentId);
  final _commentCtrl = TextEditingController();
  String _selectedCategory = 'Tampilan UI';
  String? _result;
  bool _loading = false;

  final List<String> _categories = [
    'Tampilan UI',
    'Materi Kuliah',
    'Fitur & Navigasi',
    'Lainnya',
  ];

  @override
  void dispose() {
    _nameCtrl.dispose();
    _nimCtrl.dispose();
    _commentCtrl.dispose();
    super.dispose();
  }

  String? _required(String? v, String label) =>
      (v == null || v.trim().isEmpty) ? '$label wajib diisi' : null;

  Future<void> _submit() async {
    if (!_formKey.currentState!.validate()) return;

    final ok = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        title: const Row(
          children: [
            Icon(Icons.help_outline_rounded, color: Color(0xFF4F46E5)),
            SizedBox(width: 10),
            Text('Konfirmasi Kirim'),
          ],
        ),
        content: Text(
          'Kirim feedback kategori "$_selectedCategory" sekarang?',
          style: const TextStyle(fontSize: 14),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx, false),
            child: const Text('Batal'),
          ),
          FilledButton(
            onPressed: () => Navigator.pop(ctx, true),
            child: const Text('Kirim Sekarang'),
          ),
        ],
      ),
    );
    if (ok != true) return;

    setState(() => _loading = true);
    await Future.delayed(const Duration(seconds: 2));
    if (!mounted) return;

    setState(() {
      _loading = false;
      _result =
          '[$_selectedCategory] ${_nameCtrl.text} (${_nimCtrl.text}): ${_commentCtrl.text.trim()}';
    });
    _commentCtrl.clear();

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        backgroundColor: const Color(0xFF065F46),
        content: const Row(
          children: [
            Icon(Icons.check_circle_rounded, color: Colors.white, size: 20),
            SizedBox(width: 10),
            Text('Feedback berhasil disimpan dan terkirim!'),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Form(
      key: _formKey,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          // Category Selector
          const Text(
            'Kategori Feedback:',
            style: TextStyle(
              fontSize: 13,
              fontWeight: FontWeight.w600,
              color: Color(0xFF475569),
            ),
          ),
          const SizedBox(height: 8),
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Row(
              children: _categories.map((cat) {
                final isSelected = _selectedCategory == cat;
                return Padding(
                  padding: const EdgeInsets.only(right: 8),
                  child: ChoiceChip(
                    label: Text(cat),
                    selected: isSelected,
                    onSelected: (selected) {
                      if (selected) {
                        setState(() => _selectedCategory = cat);
                      }
                    },
                  ),
                );
              }).toList(),
            ),
          ),
          const SizedBox(height: 16),

          // Name Input
          TextFormField(
            controller: _nameCtrl,
            decoration: const InputDecoration(
              labelText: 'Nama Mahasiswa',
              prefixIcon: Icon(Icons.person_outline_rounded),
            ),
            validator: (v) => _required(v, 'Nama'),
          ),
          const SizedBox(height: 14),

          // NIM Input
          TextFormField(
            controller: _nimCtrl,
            decoration: const InputDecoration(
              labelText: 'NIM',
              prefixIcon: Icon(Icons.badge_outlined),
            ),
            validator: (v) => _required(v, 'NIM'),
          ),
          const SizedBox(height: 14),

          // Comment Input
          TextFormField(
            controller: _commentCtrl,
            maxLines: 4,
            decoration: const InputDecoration(
              labelText: 'Komentar / Saran',
              hintText: 'Tuliskan ulasan atau saran konstruktif Anda...',
              alignLabelWithHint: true,
              prefixIcon: Padding(
                padding: EdgeInsets.only(bottom: 50),
                child: Icon(Icons.comment_outlined),
              ),
            ),
            validator: (v) =>
                (v == null || v.trim().length < 5) ? 'Komentar minimal 5 karakter' : null,
          ),
          const SizedBox(height: 18),

          // Submit Button
          FilledButton.icon(
            onPressed: _loading ? null : _submit,
            icon: _loading
                ? const SizedBox(
                    height: 18,
                    width: 18,
                    child: CircularProgressIndicator(
                      strokeWidth: 2,
                      color: Colors.white,
                    ),
                  )
                : const Icon(Icons.send_rounded, size: 18),
            label: Text(_loading ? 'Mengirim data...' : 'Kirim Feedback'),
            style: FilledButton.styleFrom(
              padding: const EdgeInsets.symmetric(vertical: 14),
            ),
          ),

          // Result Card
          if (_result != null) ...[
            const SizedBox(height: 16),
            Container(
              padding: const EdgeInsets.all(14),
              decoration: BoxDecoration(
                color: const Color(0xFFF0FDF4),
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: const Color(0xFF86EFAC)),
              ),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Icon(
                    Icons.check_circle_rounded,
                    color: Color(0xFF16A34A),
                    size: 22,
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          'Feedback Terakhir Terkirim',
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 13,
                            color: Color(0xFF15803D),
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          _result!,
                          style: const TextStyle(
                            fontSize: 12,
                            color: Color(0xFF166534),
                            height: 1.35,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ],
        ],
      ),
    );
  }
}
