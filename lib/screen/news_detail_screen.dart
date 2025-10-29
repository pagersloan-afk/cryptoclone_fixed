import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:url_launcher/url_launcher.dart';

class NewsDetailScreen extends StatelessWidget {
  final Map<String, String> newsItem;
  const NewsDetailScreen({super.key, required this.newsItem});

  @override
  Widget build(BuildContext context) {
    final title = newsItem['title'] ?? 'Untitled';
    final imageUrl = newsItem['image'] ?? '';
    final source = newsItem['source'] ?? 'Unknown';
    final date = newsItem['pubDate'] ?? '';
    final content = (newsItem['description']?.isNotEmpty == true)
        ? newsItem['description']!
        : (newsItem['summary']?.isNotEmpty == true)
        ? newsItem['summary']!
        : 'No additional content available.';
    final link = newsItem['link'];

    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        title: const Text('News'),
        backgroundColor: Colors.transparent,
        elevation: 0,
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          if (imageUrl.isNotEmpty)
            ClipRRect(
              borderRadius: BorderRadius.circular(12),
              child: Image.network(
                imageUrl,
                errorBuilder: (_, __, ___) => const SizedBox(),
              ),
            ),
          const SizedBox(height: 16),
          Text(
            title,
            style: const TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            '$source • $date',
            style: const TextStyle(fontSize: 13, color: Colors.white70),
          ),
          const SizedBox(height: 16),
          Text(
            content,
            style: const TextStyle(fontSize: 15, color: Colors.white),
          ),
          if (link != null && link.isNotEmpty) ...[
            const SizedBox(height: 24),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.white10,
                foregroundColor: const Color(0xFF00FFB0),
              ),
              onPressed: () async {
                HapticFeedback.selectionClick();

                try {
                  final uri = Uri.tryParse(link);
                  final messenger = ScaffoldMessenger.of(context);

                  if (uri != null && await canLaunchUrl(uri)) {
                    await launchUrl(uri, mode: LaunchMode.externalApplication);
                  } else {
                    messenger.showSnackBar(
                      const SnackBar(content: Text('Could not open article')),
                    );
                  }
                } catch (_) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Invalid article link')),
                  );
                }
              },
              child: const Text('Read Full Article'),
            ),
          ],
        ],
      ),
    );
  }
}
