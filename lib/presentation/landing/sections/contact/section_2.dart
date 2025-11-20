import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:flutter/material.dart';

/// Contact Location Section
class ContactLocationSection extends StatelessWidget {
  const ContactLocationSection({super.key});

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final isMobile = screenWidth < 768;

    return Container(
      color: const Color(0xFFF9F9F9),
      padding: EdgeInsets.all(isMobile ? 16 : 40),
      child: LayoutBuilder(
        builder: (context, constraints) {
          return Flex(
            direction: isMobile ? Axis.vertical : Axis.horizontal,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                flex: 1,
                child: Container(
                  height: isMobile ? 200 : 300, // ✅ smaller height on mobile
                  margin: EdgeInsets.only(
                    bottom: isMobile ? 20 : 0,
                    right: isMobile ? 0 : 32,
                  ),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(8),
                    color: Colors.white,
                  ),
                  child: kIsWeb
                      ? const HtmlElementView(viewType: 'map-iframe')
                      : const Center(
                          child: Text(
                            "Map preview available only on web build",
                            style: TextStyle(color: Colors.black54),
                          ),
                        ),
                ),
              ),
              Expanded(
                flex: 1,
                child: Container(
                  padding: EdgeInsets.all(isMobile ? 12 : 16),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "Investors Group of East Gate LLC",
                        style: TextStyle(
                          fontFamily: 'Inter',
                          fontSize: isMobile
                              ? 16
                              : 18, // ✅ responsive font size
                          fontWeight: FontWeight.bold,
                          color: const Color(0xFF00704A),
                        ),
                      ),
                      SizedBox(height: isMobile ? 8 : 12),
                      const Text(
                        "Office: 2972 Nostrand Ave, Brooklyn, New York, 11229",
                      ),
                      const Text("PO Box: 1612, Southampton, New York, 11969"),
                      const Text("Mobile: (917) 336-2521"),
                    ],
                  ),
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}
