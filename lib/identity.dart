import 'package:flutter/material.dart';

// Identitas mahasiswa (wajib tampil di UI)
const String studentName = 'I Kadek Agus Mertha Kusuma';
const String studentId = '2415051054';
const String studentClass = 'PTI 5 C';
const String studentPhoto = 'assets/images/profile.jpg';

/// Banner identitas: Nama & NIM selalu terlihat (reusable widget).
class IdentityBanner extends StatelessWidget {
  final bool compact;
  const IdentityBanner({super.key, this.compact = false});

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    return Container(
      width: double.infinity,
      color: cs.primaryContainer,
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
      child: Row(
        children: [
          ClipOval(
            child: Image.asset(
              studentPhoto,
              width: 32,
              height: 32,
              fit: BoxFit.cover,
              errorBuilder: (_, __, ___) => CircleAvatar(
                radius: 16,
                backgroundColor: cs.primary,
                child: const Icon(Icons.person, size: 18, color: Colors.white),
              ),
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Text(
              '$studentId - $studentName',
              style: TextStyle(
                fontWeight: FontWeight.w600,
                color: cs.onPrimaryContainer,
              ),
              overflow: TextOverflow.ellipsis,
            ),
          ),
        ],
      ),
    );
  }
}
