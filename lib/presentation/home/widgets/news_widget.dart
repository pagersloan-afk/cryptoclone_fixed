import 'package:ecommerce_app/screen/news_detail_screen.dart';
import 'package:ecommerce_app/screen/news_screen.dart';
import 'package:flutter/material.dart';
import 'package:ecommerce_app/services/rss_news_service.dart';
import 'package:flutter/services.dart';
import 'package:shimmer/shimmer.dart';
import 'package:intl/intl.dart';

class NewsWidget extends StatelessWidget {
  const NewsWidget({super.key});

  Widget _shimmerItem() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 6),
      child: Shimmer.fromColors(
        baseColor: Colors.grey.shade800,
        highlightColor: Colors.grey.shade600,
        child: Container(
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            color: Colors.white.withOpacity(0.05), // ✅ Match Watchlist
            borderRadius: BorderRadius.circular(12),
          ),
          child: Row(
            children: [
              Container(width: 48, height: 48, color: Colors.black),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      height: 14,
                      width: double.infinity,
                      color: Colors.black,
                    ),
                    const SizedBox(height: 6),
                    Container(height: 10, width: 120, color: Colors.black),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final rssService = RssNewsService();

    return Container(
      margin: const EdgeInsets.only(bottom: 24),
      child: FutureBuilder<List<Map<String, String>>>(
        future: rssService.fetchNews(),
        builder: (context, snapshot) {
          final isLoading = snapshot.connectionState == ConnectionState.waiting;

          return Column(
            children: [
              Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: 16.0,
                  vertical: 4,
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text(
                      '📰 News',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.w700,
                        color: Colors.white,
                        fontFamily: 'Inter',
                      ),
                    ),
                    GestureDetector(
                      onTap: () {
                        if (snapshot.hasData) {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (_) =>
                                  FullNewsScreen(newsItems: snapshot.data!),
                            ),
                          );
                        }
                      },
                      child: const Text(
                        'See All',
                        style: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w500,
                          color: Color(0xFF00FFB0),
                          fontFamily: 'Inter',
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 8),
              if (isLoading)
                Column(children: List.generate(5, (_) => _shimmerItem()))
              else if (snapshot.hasError || !snapshot.hasData)
                Column(
                  children: List.generate(3, (_) => _shimmerItem()),
                ) // ✅ fallback shimmer
              else
                ListView.separated(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  itemCount: 5,
                  separatorBuilder: (_, __) => const SizedBox(height: 12),
                  itemBuilder: (context, index) {
                    final item = snapshot.data![index];
                    final title = item['title'] ?? 'Untitled';
                    final source = item['source'] ?? 'Unknown';
                    final imageUrl = item['image'] ?? '';

                    String formattedDate = 'Today';
                    try {
                      final rawDate = item['pubDate'] ?? '';
                      if (rawDate.isNotEmpty) {
                        final parsedDate = DateFormat(
                          'EEE, dd MMM yyyy HH:mm:ss Z',
                        ).parse(rawDate, true);
                        formattedDate = DateFormat(
                          'MMM d, yyyy',
                        ).format(parsedDate);
                      }
                    } catch (_) {
                      formattedDate = 'Unknown';
                    }

                    return Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 16.0),
                      child: GestureDetector(
                        onTap: () {
                          HapticFeedback.selectionClick();
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (_) => NewsDetailScreen(newsItem: item),
                            ),
                          );
                        },
                        child: Container(
                          padding: const EdgeInsets.all(12),
                          decoration: BoxDecoration(
                            color: Colors.white.withOpacity(0.05),
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
                                        color: Color.fromARGB(
                                          255,
                                          193,
                                          191,
                                          187,
                                        ),
                                      ),
                                    ),
                                    const SizedBox(height: 4),
                                    Text(
                                      '$formattedDate • $source',
                                      style: const TextStyle(
                                        fontSize: 12,
                                        color: Color.fromARGB(
                                          255,
                                          135,
                                          135,
                                          133,
                                        ),
                                        fontFamily: 'Inter',
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    );
                  },
                ),
            ],
          );
        },
      ),
    );
  }
}
