import 'package:ecommerce_app/models/portfolio_item.dart';
import 'package:flutter/material.dart';

class PortfolioCard extends StatelessWidget {
  final String balance;
  final double changePercent;
  final VoidCallback onDeposit;
  final VoidCallback onWithdraw;
  final void Function(PortfolioItem) onSend;
  final PortfolioItem asset;

  const PortfolioCard({
    super.key,
    required this.balance,
    required this.changePercent,
    required this.onDeposit,
    required this.onSend,
    required this.onWithdraw,
    required this.asset,
  });

  @override
  Widget build(BuildContext context) {
    final isPositive = changePercent >= 0;
    final changeColor = isPositive ? Colors.greenAccent : Colors.redAccent;
    final changePrefix = isPositive ? '+' : '';

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: const Color(0xFF1D1E33),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Portfolio Balance',
            style: TextStyle(color: Colors.white70, fontSize: 14),
          ),
          const SizedBox(height: 8),
          RichText(
            text: TextSpan(
              children: [
                TextSpan(
                  text: balance.split(' ')[0],
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const TextSpan(
                  text: ' USD',
                  style: TextStyle(color: Colors.white70, fontSize: 16),
                ),
              ],
            ),
          ),
          const SizedBox(height: 4),
          Row(
            children: [
              Text(
                '$changePrefix${changePercent.toStringAsFixed(2)}%',
                style: TextStyle(color: changeColor, fontSize: 16),
              ),
              const SizedBox(width: 6),
              const Text(
                'Past 24h',
                style: TextStyle(color: Colors.white54, fontSize: 14),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Row(
            children: [
              Expanded(
                child: SizedBox(
                  height: 48,
                  child: ElevatedButton(
                    onPressed: onDeposit,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.greenAccent,
                      foregroundColor: Colors.black,
                      padding: const EdgeInsets.symmetric(horizontal: 8),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: const [
                        Icon(Icons.account_balance_wallet, size: 14),
                        SizedBox(width: 6),
                        Text(
                          'Deposit',
                          style: TextStyle(
                            fontSize: 12,
                            fontWeight: FontWeight.w600,
                          ),
                          overflow: TextOverflow.ellipsis,
                        ),
                      ],
                    ),
                  ),
                ),
              ),
              const SizedBox(width: 8),
              Expanded(
                child: SizedBox(
                  height: 48,
                  child: ElevatedButton(
                    onPressed: onWithdraw,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.blueAccent,
                      foregroundColor: Colors.white,
                      padding: const EdgeInsets.symmetric(horizontal: 8),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: const [
                        Icon(Icons.account_balance, size: 12),
                        SizedBox(width: 6),
                        Text(
                          'Withdraw',
                          style: TextStyle(
                            fontSize: 11,
                            fontWeight: FontWeight.w600,
                          ),
                          overflow: TextOverflow.ellipsis,
                        ),
                      ],
                    ),
                  ),
                ),
              ),
              const SizedBox(width: 8),
              Expanded(
                child: SizedBox(
                  height: 48,
                  child: ElevatedButton(
                    onPressed: () => onSend(asset),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color.fromARGB(255, 219, 69, 87),
                      foregroundColor: Colors.black,
                      padding: const EdgeInsets.symmetric(horizontal: 8),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: const [
                        Icon(Icons.send, size: 16),
                        SizedBox(width: 6),
                        Text(
                          'Send',
                          style: TextStyle(
                            fontSize: 12,
                            fontWeight: FontWeight.w600,
                          ),
                          overflow: TextOverflow.ellipsis,
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
