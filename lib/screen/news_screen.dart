import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class FullNewsScreen extends StatelessWidget {
  final List<Map<String, String>> newsItems;

  const FullNewsScreen({super.key, required this.newsItems});

  String formatDate(String? rawDate) {
    if (rawDate == null || rawDate.isEmpty) return 'Unknown';
    try {
      final parsed = DateFormat(
        'EEE, dd MMM yyyy HH:mm:ss Z',
      ).parse(rawDate, true);
      return DateFormat('MMM d, yyyy').format(parsed);
    } catch (_) {
      return 'Unknown';
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('All News'),
        backgroundColor: Colors.black,
      ),
      backgroundColor: Colors.black,
      body: ListView.separated(
        padding: const EdgeInsets.all(16),
        itemCount: newsItems.length,
        separatorBuilder: (_, __) => const SizedBox(height: 12),
        itemBuilder: (context, index) {
          final item = newsItems[index];
          final title = item['title'] ?? 'Untitled';
          final source = item['source'] ?? 'Unknown';
          final imageUrl = item['image'] ?? '';
          final date = formatDate(item['pubDate']);

          return Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: const Color(0xFF1A1A1A),
              borderRadius: BorderRadius.circular(12),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.2),
                  blurRadius: 6,
                  offset: const Offset(0, 2),
                ),
              ],
            ),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                ClipRRect(
                  borderRadius: BorderRadius.circular(8),
                  child: Image.network(
                    imageUrl,
                    width: 48,
                    height: 48,
                    fit: BoxFit.cover,
                    errorBuilder: (_, __, ___) => Container(
                      width: 48,
                      height: 48,
                      color: Colors.grey.shade800,
                      child: const Icon(
                        Icons.image_not_supported,
                        color: Colors.white54,
                        size: 20,
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        title,
                        style: const TextStyle(
                          fontSize: 13,
                          fontWeight: FontWeight.w700,
                          fontFamily: 'Inter',
                          color: Color.fromARGB(255, 193, 191, 187),
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        '$date • $source',
                        style: const TextStyle(
                          fontSize: 12,
                          color: Color.fromARGB(255, 135, 135, 133),
                          fontFamily: 'Inter',
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}
