import 'package:flutter/material.dart';

/// 💬 Testimonials Section
class TestimonialsSection extends StatelessWidget {
  const TestimonialsSection({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(vertical: 60, horizontal: 24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          // <h2>
          Text(
            "What Our Investors Say",
            style: Theme.of(context).textTheme.headlineSmall?.copyWith(
              fontFamily: 'Inter',
              fontWeight: FontWeight.bold,
              color: Colors.black87,
            ),
          ),
          const SizedBox(height: 40),

          // ✅ Responsive testimonial grid
          LayoutBuilder(
            builder: (context, constraints) {
              final isMobile = constraints.maxWidth < 600;

              if (isMobile) {
                // Stack cards vertically on mobile
                return Column(
                  children: const [
                    _TestimonialCard(
                      quote:
                          "“IGEG-LOCK gave me peace of mind and a solid return. I’m reinvesting again!”",
                      author: "— James O., California",
                    ),
                    SizedBox(height: 24),
                    _TestimonialCard(
                      quote:
                          "“With IGEG-SAVE, I see my money grow daily. It’s flexible and powerful.”",
                      author: "— Alvina B., Texas",
                    ),
                  ],
                );
              } else {
                // Side-by-side on desktop/tablet
                return Wrap(
                  spacing: 24,
                  runSpacing: 24,
                  alignment: WrapAlignment.center,
                  children: const [
                    _TestimonialCard(
                      quote:
                          "“IGEG-LOCK gave me peace of mind and a solid return. I’m reinvesting again!”",
                      author: "— James O., California",
                    ),
                    _TestimonialCard(
                      quote:
                          "“With IGEG-SAVE, I see my money grow daily. It’s flexible and powerful.”",
                      author: "— Alvina B., Texas",
                    ),
                  ],
                );
              }
            },
          ),
        ],
      ),
    );
  }
}

/// Single testimonial card
class _TestimonialCard extends StatelessWidget {
  final String quote;
  final String author;

  const _TestimonialCard({required this.quote, required this.author});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 320,
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(8),
        color: Colors.white,
        boxShadow: const [
          BoxShadow(color: Colors.black12, blurRadius: 6, offset: Offset(0, 4)),
        ],
      ),
      child: Column(
        children: [
          Text(
            quote,
            style: const TextStyle(
              fontFamily: 'Inter',
              fontSize: 16,
              fontStyle: FontStyle.italic,
              color: Colors.black87,
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 12),
          Text(
            author,
            style: const TextStyle(
              fontFamily: 'Inter',
              fontSize: 14,
              color: Colors.black54,
            ),
          ),
        ],
      ),
    );
  }
}
