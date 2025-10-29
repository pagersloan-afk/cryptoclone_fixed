import 'package:http/http.dart' as http;
import 'package:xml/xml.dart';

class RssNewsService {
  final Uri feedUrl = Uri.parse(
    'https://www.coindesk.com/arc/outboundfeeds/rss/',
  );

  Future<List<Map<String, String>>> fetchNews() async {
    final response = await http.get(feedUrl);
    if (response.statusCode == 200) {
      final document = XmlDocument.parse(response.body);
      final items = document.findAllElements('item');

      return items.take(10).map((item) {
        final title = item.getElement('title')?.text ?? 'No title';
        final pubDate = item.getElement('pubDate')?.text ?? '';
        final enclosure = item.getElement('enclosure');
        final mediaContent = item.getElement('media:content');
        final imageUrl =
            enclosure?.getAttribute('url') ??
            mediaContent?.getAttribute('url') ??
            '';

        final description = item.getElement('description')?.text ?? '';
        final link = item.getElement('link')?.text ?? '';
        final summary = item.getElement('summary')?.text ?? '';

        return {
          'title': title,
          'source': 'CoinDesk',
          'pubDate': pubDate,
          'image': imageUrl,
          'description': description,
          'summary': summary,
          'link': link,
        };
      }).toList();
    } else {
      throw Exception('Failed to load RSS feed');
    }
  }
}
