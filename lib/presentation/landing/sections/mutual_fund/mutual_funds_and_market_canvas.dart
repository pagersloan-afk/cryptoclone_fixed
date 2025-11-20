import 'package:flutter/material.dart';
import 'package:web/web.dart' as web; // modern DOM APIs
import 'dart:ui_web' as ui; // platformViewRegistry
import 'dart:js_interop';

class MarketCanvasSection extends StatelessWidget {
  const MarketCanvasSection({super.key});

  @override
  Widget build(BuildContext context) {
    const viewType = 'tradingview-iframe';

    ui.platformViewRegistry.registerViewFactory(viewType, (int id) {
      final iframe = web.HTMLIFrameElement()
        ..style.border = 'none'
        ..style.width = '100%'
        ..style.height = '100%'
        ..srcdoc =
            """
<!DOCTYPE html>
<html>
<head><meta name="viewport" content="width=device-width, initial-scale=1.0"></head>
<body style="margin:0;padding:0;">
  <div class="tradingview-widget-container" style="width:100%;height:100%;">
    <div class="tradingview-widget-container__widget"></div>
    <script type="text/javascript" src="https://s3.tradingview.com/external-embedding/embed-widget-symbol-overview.js" async></script>
    <script type="text/javascript">
      new TradingView.widget({
        "symbols": [
          ["Apple", "AAPL|1D"],
          ["Google", "GOOGL|1D"],
          ["Microsoft", "MSFT|1D"]
        ],
        "width":"100%",
        "height":"100%",
        "locale":"en",
        "colorTheme":"dark",
        "autosize":true
      });
    </script>
  </div>
</body>
</html>
"""
                .toJS;
      return iframe;
    });

    // 🔑 Responsive height logic
    return LayoutBuilder(
      builder: (context, constraints) {
        final isMobile = constraints.maxWidth < 600;

        // Instead of filling the viewport, use smaller heights
        final height = isMobile
            ? 400.0 // compact for mobile
            : MediaQuery.of(context).size.height * 0.4;
        // desktop: 40% of viewport height

        return SizedBox(
          width: MediaQuery.of(context).size.width, // edge-to-edge
          height: height,
          child: const HtmlElementView(viewType: viewType),
        );
      },
    );
  }
}
